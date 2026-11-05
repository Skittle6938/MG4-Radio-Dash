package app.mg4dash.radiodash;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

/**
 * Liste des stations affichée dans la case de droite et parcourue par toutes les commandes de changement de
 * station : volant, accueil et widget MG4Dash (session média), ◀ ▶ et glissé sur le lecteur.
 *
 * Mode Favoris (réglage « ★ Favoris », par défaut) : les favoris de la bande, dans leur ordre.
 * Sinon toutes les stations connues : la liste DAB+ du tuner (par nom), ou en FM / AM la liste de la radio et
 * celle des scans de Radio Dash (par fréquence), sans les stations que le dernier scan complet n'a pas retrouvées.
 * Les favoris y figurent toujours, même hors de portée.
 *
 * Appelé depuis l'activité et depuis le service radio (même processus) : accès par réflexion aux classes de l'appli.
 * Bandes : 4 = DAB+, 1 = FM, 0 = AM.
 */
final class Stations {
    private static final String TAG = "RadioDash";
    static final String PREFS = "radio_dash";
    private static final String FAV_ONLY = "rd_fav_only";
    static final String NAME_KEY = "rd_fm_name_";
    static final int FM_MIN = 87500, FM_MAX = 108000, AM_MIN = 522, AM_MAX = 1710;

    private Stations() {}

    static SharedPreferences prefs(Context c) { return c.getSharedPreferences(PREFS, Context.MODE_PRIVATE); }

    /** Contexte de l'appli quand l'appelant n'en a pas (service : seulement RadioStorage sous la main). */
    static Context app() {
        try {
            return (Context) Class.forName("android.app.ActivityThread").getMethod("currentApplication").invoke(null);
        } catch (Throwable t) {
            return null;
        }
    }

    // ── Mode ────────────────────────────────────────────────────────────────

    static boolean favOnly(Context c) { return c == null || prefs(c).getBoolean(FAV_ONLY, true); }

    static void setFavOnly(Context c, boolean on) {
        prefs(c).edit().putBoolean(FAV_ONLY, on).apply();
        Log.i(TAG, on ? "mode favoris" : "mode toutes les stations");
    }

    // ── Listes ──────────────────────────────────────────────────────────────

    /** Favoris de la bande. */
    static List<?> favorites(Object storage, int band) {
        if (storage == null) return null;
        try {
            if (band == 4) return (List<?>) call(storage, "getDabFavorite");
            return (List<?>) storage.getClass().getMethod("getFavoriteForBand", int.class).invoke(storage, band == 0 ? 0 : 1);
        } catch (Throwable t) {
            return null;
        }
    }

    /** Liste parcourue par les commandes : les favoris en mode Favoris, sinon toutes les stations. */
    static List<Object> cycle(Context c, Object storage, int band) {
        if (!favOnly(c)) return all(c, storage, band);
        List<?> f = favorites(storage, band);
        return f == null ? new ArrayList<Object>() : new ArrayList<Object>(f);
    }

    /** Toutes les stations connues de la bande, favoris compris. */
    static List<Object> all(Context c, Object storage, int band) {
        List<Object> out = new ArrayList<>();
        if (storage == null) return out;
        try {
            if (band == 4) {
                Set<Long> seen = new HashSet<>();
                List<?> list = (List<?>) call(storage, "getDabStationList");
                if (list != null) for (Object o : list) if (seen.add(serviceId(o))) out.add(o);
                List<?> f = favorites(storage, 4);
                if (f != null) for (Object o : f) if (seen.add(serviceId(o))) out.add(o);
                Collections.sort(out, new Comparator<Object>() {
                    @Override public int compare(Object x, Object y) { return dabLabel(x).compareToIgnoreCase(dabLabel(y)); }
                });
                return out;
            }
            int key = band == 0 ? 0 : 1;
            Set<Integer> hidden = c == null ? Collections.<Integer>emptySet() : channels(c, hiddenKey(key));
            TreeMap<Integer, Object> map = new TreeMap<>();
            List<?> pre = (List<?>) storage.getClass().getMethod("getPreScannedStationsForBand", int.class).invoke(storage, key);
            if (pre != null) for (Object o : pre) {
                int ch = channel(o);
                if (inBand(ch, key) && !hidden.contains(ch)) map.put(ch, o);
            }
            if (c != null) for (int ch : channels(c, foundKey(key))) {
                if (!map.containsKey(ch) && !hidden.contains(ch)) map.put(ch, station(c, ch, key));
            }
            List<?> f = favorites(storage, key);
            if (f != null) for (Object o : f) map.put(channel(o), o);
            out.addAll(map.values());
        } catch (Throwable t) {
            Log.w(TAG, "liste des stations : " + t);
        }
        return out;
    }

    /**
     * Station suivante ou précédente de la liste parcourue, ou null si elle est vide (l'appelant garde alors le
     * comportement d'origine : recherche FM / AM, station DAB+ valide suivante).
     */
    static Object next(Context c, Object storage, int band, boolean forward) {
        if (storage == null) return null;
        List<Object> list = cycle(c, storage, band);
        int n = list.size();
        if (n == 0) return null;
        try {
            int idx = -1;
            if (band == 4) {
                Object cur = call(storage, "getCurrentDabStation");
                long id = cur == null ? -1 : serviceId(cur);
                for (int i = 0; i < n; i++) if (serviceId(list.get(i)) == id) { idx = i; break; }
                int next = idx < 0 ? (forward ? 0 : n - 1) : ((idx + (forward ? 1 : -1)) % n + n) % n;
                Object st = list.get(next);
                Object fresh = callArg(storage, "getDabStationForServiceId", st);
                Log.i(TAG, "DAB " + (next + 1) + "/" + n + (favOnly(c) ? " (favoris)" : " (toutes)"));
                return fresh != null ? fresh : st;
            }
            int cur = currentChannel(storage, band);
            for (int i = 0; i < n; i++) if (channel(list.get(i)) == cur) { idx = i; break; }
            int next;
            if (idx >= 0) next = ((idx + (forward ? 1 : -1)) % n + n) % n;
            else if (favOnly(c)) next = forward ? 0 : n - 1;
            else {
                // Fréquence hors de la liste (triée) : la plus proche dans le sens demandé
                next = forward ? 0 : n - 1;
                for (int i = 0; i < n; i++) {
                    int ch = channel(list.get(i));
                    if (forward && ch > cur) { next = i; break; }
                    if (!forward && ch < cur) next = i;
                }
            }
            Object st = list.get(next);
            Log.i(TAG, (band == 0 ? "AM " : "FM ") + (next + 1) + "/" + n + " : " + channel(st) + (favOnly(c) ? " (favoris)" : " (toutes)"));
            return st;
        } catch (Throwable t) {
            Log.w(TAG, "station suivante : " + t);
            return null;
        }
    }

    // ── Favoris ─────────────────────────────────────────────────────────────

    /** Favori de la liste correspondant à cette station (même service DAB+ ou même fréquence), ou null. */
    static Object favoriteOf(Object storage, Object st, int band) {
        List<?> f = favorites(storage, band);
        if (f == null || st == null) return null;
        try {
            for (Object o : f) {
                if (band == 4 ? serviceId(o) == serviceId(st) : channel(o) == channel(st)) return o;
            }
        } catch (Throwable ignored) {}
        return null;
    }

    /** Ajoute ou retire le favori, enregistré par la radio (même base que l'étoile du lecteur). */
    static void setFavorite(Object storage, Object st, int band, boolean on) {
        try {
            Object target = st;
            if (!on) { Object fav = favoriteOf(storage, st, band); if (fav != null) target = fav; }
            String name = band == 4 ? (on ? "storeDabFavorite" : "removeDabFavorite") : (on ? "storeFavorite" : "removeFavorite");
            for (Method m : storage.getClass().getMethods()) {
                if (m.getName().equals(name) && m.getParameterTypes().length == 1 && m.getParameterTypes()[0].isInstance(target)) {
                    m.invoke(storage, target);
                    Log.i(TAG, (on ? "favori ajouté" : "favori retiré") + (band == 4 ? " (DAB)" : " : " + channel(target)));
                    return;
                }
            }
        } catch (Throwable t) {
            Log.w(TAG, "favori : " + t);
        }
    }

    // ── Scan FM / AM ─────────────────────────────────────────────────────────

    /** Station trouvée pendant un scan : ajoutée à la liste (et plus cachée). */
    static void found(Context c, int band, int ch) {
        int key = band == 0 ? 0 : 1;
        TreeSet<Integer> f = channels(c, foundKey(key)), h = channels(c, hiddenKey(key));
        boolean changed = f.add(ch) | h.remove(ch);
        if (!changed) return;
        SharedPreferences.Editor e = prefs(c).edit();
        e.putString(foundKey(key), join(f));
        e.putString(hiddenKey(key), join(h));
        e.apply();
    }

    /**
     * Scan complet : la liste devient ce qui a été trouvé. Les stations connues mais pas retrouvées sont cachées
     * (la liste de la radio les garde), sauf les favoris, toujours affichés.
     */
    static void scanComplete(Context c, Object storage, int band, Set<Integer> seen) {
        int key = band == 0 ? 0 : 1;
        TreeSet<Integer> h = channels(c, hiddenKey(key));
        h.addAll(channels(c, foundKey(key)));
        try {
            List<?> pre = (List<?>) storage.getClass().getMethod("getPreScannedStationsForBand", int.class).invoke(storage, key);
            if (pre != null) for (Object o : pre) h.add(channel(o));
        } catch (Throwable ignored) {}
        h.removeAll(seen);
        SharedPreferences.Editor e = prefs(c).edit();
        e.putString(foundKey(key), join(seen));
        e.putString(hiddenKey(key), join(h));
        e.apply();
        Log.i(TAG, "scan " + (key == 0 ? "AM" : "FM") + " : " + seen.size() + " stations, " + h.size() + " retirées");
    }

    // ── Noms ────────────────────────────────────────────────────────────────

    /** Nom RDS de la station FM, ou le dernier reçu sur cette fréquence (vide en AM sans nom). */
    static String name(Context c, Object st) {
        Object rds = callQuiet(st, "getRds");
        Object ps = rds == null ? null : callQuiet(rds, "getProgramService");
        String n = ps == null ? "" : ps.toString().trim();
        if (n.length() >= 2 || c == null) return n;
        Object ch = callQuiet(st, "getChannelNumber");
        return ch instanceof Number ? prefs(c).getString(NAME_KEY + ((Number) ch).intValue(), "").trim() : n;
    }

    static void rememberName(Context c, int ch, String ps) {
        if (ps == null || ps.trim().length() < 2) return;
        if (ps.trim().equals(prefs(c).getString(NAME_KEY + ch, ""))) return;
        prefs(c).edit().putString(NAME_KEY + ch, ps.trim()).apply();
    }

    static String dabLabel(Object st) {
        Object n = callQuiet(st, "getServiceName");
        if (n == null || n.toString().trim().isEmpty()) n = callQuiet(st, "getEnsembleName");
        return n == null ? "DAB" : n.toString().trim();
    }

    // ── Outils ──────────────────────────────────────────────────────────────

    private static String foundKey(int key) { return key == 0 ? "rd_am_found" : "rd_fm_found"; }
    private static String hiddenKey(int key) { return key == 0 ? "rd_am_hidden" : "rd_fm_hidden"; }

    private static boolean inBand(int ch, int key) {
        return key == 0 ? ch >= AM_MIN && ch <= AM_MAX : ch >= FM_MIN && ch <= FM_MAX;
    }

    /** Station FM / AM construite pour une fréquence trouvée par Radio Dash, avec son dernier nom connu. */
    private static Object station(Context c, int ch, int key) throws Exception {
        Class<?> rs = Class.forName("com.android.car.radio.service.RadioStation");
        Class<?> rdsCls = Class.forName("com.android.car.radio.service.RadioRds");
        String kept = key == 1 ? prefs(c).getString(NAME_KEY + ch, "").trim() : "";
        Object rds = kept.length() >= 2 ? rdsCls.getConstructor(String.class, String.class, String.class).newInstance(kept, null, null) : null;
        return rs.getConstructor(int.class, int.class, int.class, rdsCls).newInstance(ch, 0, key, rds);
    }

    static TreeSet<Integer> channels(Context c, String key) {
        TreeSet<Integer> s = new TreeSet<>();
        for (String v : prefs(c).getString(key, "").split(",")) {
            try { if (!v.trim().isEmpty()) s.add(Integer.parseInt(v.trim())); } catch (NumberFormatException ignored) {}
        }
        return s;
    }

    private static String join(Set<Integer> s) {
        StringBuilder b = new StringBuilder();
        for (int ch : s) { if (b.length() > 0) b.append(','); b.append(ch); }
        return b.toString();
    }

    static int currentChannel(Object storage, int band) {
        try {
            return ((Number) storage.getClass().getMethod("getStoredRadioChannel", int.class).invoke(storage, band == 0 ? 0 : 1)).intValue();
        } catch (Throwable t) {
            return -1;
        }
    }

    static int channel(Object station) throws Exception {
        return ((Number) call(station, "getChannelNumber")).intValue();
    }

    static long serviceId(Object station) throws Exception {
        return ((Number) call(station, "getServiceId")).longValue();
    }

    private static Object call(Object target, String name) throws Exception {
        return target.getClass().getMethod(name).invoke(target);
    }

    private static Object callQuiet(Object target, String name) {
        try { return call(target, name); } catch (Throwable t) { return null; }
    }

    private static Object callArg(Object target, String name, Object arg) {
        try {
            for (Method m : target.getClass().getMethods()) {
                if (m.getName().equals(name) && m.getParameterTypes().length == 1 && m.getParameterTypes()[0].isInstance(arg)) {
                    return m.invoke(target, arg);
                }
            }
        } catch (Throwable ignored) {}
        return null;
    }
}
