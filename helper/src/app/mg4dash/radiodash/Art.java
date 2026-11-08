package app.mg4dash.radiodash;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.util.LruCache;

import java.io.File;
import java.lang.ref.WeakReference;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Images DAB+ d'une station. Une station en envoie de deux sortes, par deux canaux distincts :
 *  - le diaporama (MOT SlideShow) : pochettes, animateurs, pubs… ; une image chasse l'autre, sans indication de genre.
 *    Le patch DAB+ garde la dernière dans fichiers/dab_<serviceId>.jpg ;
 *  - le logo SPI, diffusé à part avec le guide des programmes ; la radio le range par station dans sa base
 *    (RadioStorage.getDabLogoInfoList, table dab_logo_info_list_table) et le garde.
 *
 * Règle : une image du diaporama ne vaut que 5 minutes après son arrivée (ou jusqu'à la suivante). Ensuite, le logo
 * de la station, sinon rien. Lecteur et MG4Dash (session média) : diaporama récent, sinon logo. Liste des stations :
 * logo d'abord (il identifie la station), sinon diaporama récent, sinon le nom seul.
 *
 * Branché dans le smali : DabTunerCallback.onDabSlideShowChanged → live() ; RadioMBService.toSetSessionMetadataDabBitmap
 * → session() ; RadioMBService.toSetSessionMetadataDabTitle → current().
 */
public final class Art {
    private static final String TAG = "RadioDash";
    /** Durée de vie d'une image du diaporama. */
    static final long SLIDE_TTL = 5 * 60 * 1000L;
    private static final int LOGO_MAX = 320;

    private static final Handler main = new Handler(Looper.getMainLooper());
    /** Image que le diaporama vient d'envoyer, reconnue quand elle arrive à la session média. */
    private static WeakReference<Bitmap> pending = new WeakReference<>(null);
    /** Diaporama de la station écoutée, reçu en direct (horloge de démarrage : insensible au réglage de l'heure). */
    private static long liveSid = -1, liveAt;
    private static Bitmap liveBitmap;
    private static WeakReference<Object> service = new WeakReference<>(null);

    private Art() {}

    // ── Branchements smali ───────────────────────────────────────────────────

    /** DabTunerCallback.onDabSlideShowChanged, juste avant l'envoi de l'image (déjà mise au carré) à la session. */
    public static void live(Bitmap b) {
        pending = new WeakReference<>(b);
    }

    /**
     * RadioMBService.toSetSessionMetadataDabBitmap : l'image à publier. Celle du diaporama qui arrive passe telle quelle
     * et lance le compte à rebours ; les autres envois de la radio (image en cache au changement de station, logo ou
     * rien au réglage) sont remplacés par la règle.
     */
    public static Bitmap session(Context svc, Object station, Bitmap incoming) {
        try {
            long sid = sid(station);
            if (incoming != null && incoming == pending.get() && sid > 0) {
                pending = new WeakReference<>(null);   // reconnue une seule fois : un renvoi plus tard ne la rajeunit pas
                synchronized (Art.class) {
                    liveSid = sid;
                    liveAt = SystemClock.elapsedRealtime();
                    liveBitmap = incoming;
                }
                service = new WeakReference<Object>(svc);
                main.removeCallbacks(expire);
                main.postDelayed(expire, SLIDE_TTL + 1000);
                return incoming;
            }
            Bitmap b = current(svc, station);
            if (b != incoming) Log.i(TAG, "image DAB+ " + sid + " : " + (b == null ? "aucune" : b == liveBitmap ? "diaporama" : "logo ou diaporama en cache"));
            return b;
        } catch (Throwable t) {
            Log.w(TAG, "image DAB+ (session) : " + t);
            return incoming;
        }
    }

    /** Lecteur et session média : diaporama de moins de 5 minutes, sinon logo SPI, sinon rien. */
    public static Bitmap current(Context c, Object station) {
        if (c == null || station == null) return null;
        return forPlayer(c, sid(station));
    }

    /** Cinq minutes après la dernière image du diaporama : la session repasse au logo (ou à rien). */
    private static final Runnable expire = new Runnable() {
        @Override public void run() {
            Object svc = service.get();
            if (svc == null) return;
            try {
                Field f = svc.getClass().getDeclaredField("mRadioDabStation");
                f.setAccessible(true);
                Object st = f.get(svc);
                if (st == null) return;
                Method m = svc.getClass().getDeclaredMethod("toSetSessionMetadataDabBitmap",
                        Class.forName("com.android.car.radio.service.RadioDabStation"), Bitmap.class);
                m.setAccessible(true);
                Log.i(TAG, "diaporama DAB+ de plus de 5 min : image de la session remise à jour");
                m.invoke(svc, st, null);
            } catch (Throwable t) {
                Log.w(TAG, "fin du diaporama DAB+ : " + t);
            }
        }
    };

    // ── Choix de l'image ─────────────────────────────────────────────────────

    static Bitmap forPlayer(Context c, long sid) {
        if (sid <= 0) return null;
        Bitmap s = slide(c, sid);
        return s != null ? s : logo(c, sid);
    }

    /** Case de la liste : logo, sinon diaporama récent, sinon null (la case montre le nom). */
    static Bitmap forTile(Context c, long sid) {
        if (sid <= 0) return null;
        Bitmap l = logo(c, sid);
        return l != null ? l : slide(c, sid);
    }

    /** Ce que montre la case : change quand un logo arrive, qu'une image arrive ou qu'elle a plus de 5 minutes. */
    static String tileKey(Context c, long sid) {
        Object bean = logoBean(c, sid);
        if (bean != null) {
            byte[] buf = (byte[]) callQuiet(bean, "getmLogoBuffer");
            return "L" + (buf == null ? 0 : buf.length);
        }
        long m = slideTime(c, sid);
        return m > 0 ? "S" + m : "-";
    }

    /** Heure du fichier de la dernière image du diaporama si elle a moins de 5 minutes, sinon 0. */
    private static long slideTime(Context c, long sid) {
        synchronized (Art.class) {
            if (sid == liveSid && liveAt > 0) {
                // Station écoutée : l'heure d'arrivée en mémoire fait foi
                if (SystemClock.elapsedRealtime() - liveAt >= SLIDE_TTL) return 0;
                long m = file(c, sid).lastModified();
                return m > 0 ? m : 1;
            }
        }
        long m = file(c, sid).lastModified();
        if (m == 0) return 0;
        long age = System.currentTimeMillis() - m;
        return age >= 0 && age < SLIDE_TTL ? m : 0;
    }

    private static Bitmap slide(Context c, long sid) {
        synchronized (Art.class) {
            if (sid == liveSid && liveBitmap != null && !liveBitmap.isRecycled()
                    && SystemClock.elapsedRealtime() - liveAt < SLIDE_TTL) return liveBitmap;
        }
        long m = slideTime(c, sid);
        if (m <= 1) return null;
        synchronized (slides) {
            Object[] e = slides.get(sid);
            if (e != null && (Long) e[0] == m) return (Bitmap) e[1];
            Bitmap b = BitmapFactory.decodeFile(file(c, sid).getPath());
            if (b != null) slides.put(sid, new Object[]{m, b});
            return b;
        }
    }

    private static Bitmap logo(Context c, long sid) {
        Object bean = logoBean(c, sid);
        if (bean == null) return null;
        byte[] buf = (byte[]) callQuiet(bean, "getmLogoBuffer");
        if (buf == null || buf.length == 0) return null;
        synchronized (logos) {
            Object[] e = logos.get(sid);
            if (e != null && e[0] == buf) return (Bitmap) e[1];
            Bitmap b = BitmapFactory.decodeByteArray(buf, 0, buf.length);
            if (b == null) return null;
            Log.i(TAG, "logo DAB+ " + sid + " : " + b.getWidth() + "×" + b.getHeight());
            // Les grands logos SPI (jusqu'à 600 px) ramenés à 320 px : bien assez pour les cases et le lecteur
            int side = Math.max(b.getWidth(), b.getHeight());
            if (side > LOGO_MAX) b = Bitmap.createScaledBitmap(b, Math.max(1, b.getWidth() * LOGO_MAX / side),
                    Math.max(1, b.getHeight() * LOGO_MAX / side), true);
            logos.put(sid, new Object[]{buf, b});
            return b;
        }
    }

    /** Le plus grand logo que la radio a rangé pour la station (sa base, plus celui qu'elle vient de recevoir). */
    private static Object logoBean(Context c, long sid) {
        if (sid <= 0) return null;
        Map<Long, Object> idx = logoIndex(c);
        return idx == null ? null : idx.get(sid);
    }

    private static List<?> indexedList;
    private static Object indexedCurrent;
    private static int indexedSize = -1;
    private static Map<Long, Object> index;

    private static synchronized Map<Long, Object> logoIndex(Context c) {
        Object storage = storage(c);
        if (storage == null) return null;
        Object list = callQuiet(storage, "getDabLogoInfoList");
        Object cur = callQuiet(storage, "getRadioDabLogoBean");
        List<?> l = list instanceof List ? (List<?>) list : null;
        int size = l == null ? 0 : l.size();
        if (index != null && l == indexedList && size == indexedSize && cur == indexedCurrent) return index;
        Map<Long, Object> m = new HashMap<>();
        if (l != null) {
            try {
                for (Object b : l) add(m, b);
            } catch (Throwable t) {
                Log.w(TAG, "logos DAB+ : " + t);   // liste remplacée pendant la lecture : on reprend au prochain appel
                return index;
            }
        }
        add(m, cur);
        index = m;
        indexedList = l;
        indexedSize = size;
        indexedCurrent = cur;
        return m;
    }

    private static void add(Map<Long, Object> m, Object bean) {
        if (bean == null) return;
        Object id = callQuiet(bean, "getmLogoServiceId");
        Object buf = callQuiet(bean, "getmLogoBuffer");
        if (!(id instanceof Number) || !(buf instanceof byte[]) || ((byte[]) buf).length == 0) return;
        long sid = ((Number) id).longValue();
        Object prev = m.get(sid);
        if (prev == null || width(bean) > width(prev)) m.put(sid, bean);
    }

    private static int width(Object bean) {
        Object w = callQuiet(bean, "getmLogoWidth");
        return w instanceof Number ? ((Number) w).intValue() : 0;
    }

    private static final LruCache<Long, Object[]> slides = new LruCache<Long, Object[]>(8 * 1024 * 1024) {
        @Override protected int sizeOf(Long k, Object[] v) { return ((Bitmap) v[1]).getByteCount(); }
    };
    // Assez pour les logos de toutes les stations d'une région (liste Toutes les stations redessinée sans tout relire)
    private static final LruCache<Long, Object[]> logos = new LruCache<Long, Object[]>(24 * 1024 * 1024) {
        @Override protected int sizeOf(Long k, Object[] v) { return ((Bitmap) v[1]).getByteCount(); }
    };

    // ── Outils ───────────────────────────────────────────────────────────────

    private static File file(Context c, long sid) {
        return new File(c.getFilesDir(), "dab_" + sid + ".jpg");
    }

    private static long sid(Object station) {
        Object id = station == null ? null : callQuiet(station, "getServiceId");
        return id instanceof Number ? ((Number) id).longValue() : -1;
    }

    private static Object storage(Context c) {
        try {
            Class<?> cls = Class.forName("com.saicmotor.radio.model.RadioStorage");
            return cls.getMethod("getInstance", Context.class).invoke(null, c.getApplicationContext());
        } catch (Throwable t) {
            return null;
        }
    }

    private static Object callQuiet(Object target, String name) {
        try { return target.getClass().getMethod(name).invoke(target); } catch (Throwable t) { return null; }
    }
}
