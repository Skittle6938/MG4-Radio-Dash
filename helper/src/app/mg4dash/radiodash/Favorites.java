package app.mg4dash.radiodash;

import android.content.Context;
import android.media.AudioManager;
import android.util.Log;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;

/**
 * Passage de station « suivant / précédent » limité aux favoris.
 *
 * Appelé uniquement depuis RadioService$6.onMediaSessionSkipToNext/Previous, c'est-à-dire
 * les commandes de la session média : boutons du volant et ◀ ▶ de l'écran d'accueil.
 * Les flèches de l'appli radio gardent leur comportement d'origine.
 * Sans favori sur la bande en cours, on retombe sur le comportement d'origine.
 *
 * Accès par réflexion aux classes de l'appli (RadioStorage, RadioService) pour rester
 * indépendant de leur compilation.
 */
public final class Favorites {
    private static final String TAG = "RadioDash";

    private Favorites() {}

    /**
     * Reprise auto : mémorise « en lecture » quand la lecture est lancée par la session média
     * (volant, accueil). Sans cela, seul le bouton lecture de l'appli radio mettait le drapeau à
     * jour, et le démarrage suivant ne reprenait pas la radio. Appelé seulement pour « lecture » :
     * une pause de la session peut venir de l'arrêt de la voiture et ne doit pas annuler la reprise.
     * @param listener l'instance RadioService$6 (écouteur du binder)
     */
    public static void wasPlaying(Object listener, boolean playing) {
        try {
            Object service = field(listener, "this$0");
            Class<?> prefs = Class.forName("com.saicmotor.radio.utils.RadioSharedPreference");
            Object p = prefs.getMethod("getInstance", android.content.Context.class).invoke(null, service);
            prefs.getMethod("putRadioWasPlaying", boolean.class).invoke(p, playing);
            Log.i(TAG, "reprise auto : " + (playing ? "en lecture" : "en pause"));
        } catch (Throwable t) {
            Log.w(TAG, "reprise auto indisponible : " + t);
        }
    }

    /** DAB : favori suivant/précédent, sinon station valide suivante/précédente (origine). */
    public static Object nextDab(Object storage, boolean forward) {
        try {
            List<?> favs = (List<?>) call(storage, "getDabFavorite");
            if (favs != null && !favs.isEmpty()) {
                Object current = call(storage, "getCurrentDabStation");
                int idx = indexOfService(favs, current);
                int n = favs.size();
                int next = idx < 0 ? (forward ? 0 : n - 1) : ((idx + (forward ? 1 : -1)) % n + n) % n;
                Object fav = favs.get(next);
                Object fresh = callArg(storage, "getDabStationForServiceId", fav);
                Log.i(TAG, "DAB favori " + (next + 1) + "/" + n + (forward ? " (suivant)" : " (précédent)"));
                return fresh != null ? fresh : fav;
            }
        } catch (Throwable t) {
            Log.w(TAG, "favoris DAB indisponibles : " + t);
        }
        try {
            return call(storage, forward ? "getDabNextValidStation" : "getDabPreValidStation");
        } catch (Throwable t) {
            Log.w(TAG, "station DAB suivante : " + t);
            return null;
        }
    }

    /**
     * FM/AM : accorde le favori suivant/précédent de la bande en cours.
     * @param listener l'instance RadioService$6 (écouteur du binder)
     * @return true si un favori a été accordé ; false = laisser la recherche d'origine
     */
    public static boolean skipFm(Object listener, boolean forward) {
        try {
            Object service = field(listener, "this$0");
            Object storage = field(service, "mRadioStorage");
            int band = ((Number) field(service, "mCurrentRadioBand")).intValue();
            Method forBand = storage.getClass().getMethod("getFavoriteForBand", int.class);
            List<?> favs = (List<?>) forBand.invoke(storage, band);
            if (favs == null || favs.isEmpty()) return false;
            Object current = call(listener, "getCurrentRadioStation");
            int curCh = current == null ? -1 : channel(current);
            int n = favs.size();
            int idx = -1;
            for (int i = 0; i < n; i++) if (channel(favs.get(i)) == curCh) { idx = i; break; }
            int next = idx < 0 ? (forward ? 0 : n - 1) : ((idx + (forward ? 1 : -1)) % n + n) % n;
            Object station = favs.get(next);
            for (Method m : service.getClass().getMethods()) {
                if (m.getName().equals("tuneRadioTune") && m.getParameterTypes().length == 1) {
                    m.invoke(service, station);
                    Log.i(TAG, "FM favori " + (next + 1) + "/" + n + " : " + channel(station));
                    return true;
                }
            }
        } catch (Throwable t) {
            Log.w(TAG, "favoris FM indisponibles : " + t);
        }
        return false;
    }

    /**
     * Suivant/précédent reçu alors qu'une autre source a le son (DiAuto, Android Auto, Bluetooth,
     * USB…) : le launcher d'origine, qui ne reconnaît pas les applis tierces, envoie quand même
     * les boutons du volant à la radio, qui reprenait alors le son. On ignore la commande.
     * Types de source SAIC : 1-3 radio, 5 Bluetooth, 6/7/14 USB, 50 CarPlay, 70 Android Auto.
     * @param listener l'instance RadioService$6 (écouteur du binder)
     */
    public static boolean otherSource(Object listener) {
        try {
            Object service = field(listener, "this$0");
            AudioManager am = (AudioManager) ((Context) service).getSystemService(Context.AUDIO_SERVICE);
            int source = ((Number) AudioManager.class.getMethod("getLastSource").invoke(am)).intValue();
            if (source >= 5) {
                Log.i(TAG, "suivant/précédent ignoré : la source " + source + " a le son");
                return true;
            }
        } catch (Throwable t) {
            Log.w(TAG, "source en cours inconnue : " + t);
        }
        return false;
    }

    // ── Réflexion ──

    private static int indexOfService(List<?> list, Object station) throws Exception {
        if (station == null) return -1;
        Object id = call(station, "getServiceId");
        for (int i = 0; i < list.size(); i++) {
            Object other = call(list.get(i), "getServiceId");
            if (id != null && id.equals(other)) return i;
        }
        return -1;
    }

    private static int channel(Object station) throws Exception {
        return ((Number) call(station, "getChannelNumber")).intValue();
    }

    private static Object call(Object target, String name) throws Exception {
        Method m = target.getClass().getMethod(name);
        return m.invoke(target);
    }

    private static Object callArg(Object target, String name, Object arg) {
        try {
            for (Method m : target.getClass().getMethods()) {
                if (m.getName().equals(name) && m.getParameterTypes().length == 1
                        && m.getParameterTypes()[0].isInstance(arg)) {
                    return m.invoke(target, arg);
                }
            }
        } catch (Throwable ignored) {
        }
        return null;
    }

    private static Object field(Object target, String name) throws Exception {
        Class<?> c = target.getClass();
        while (c != null) {
            try {
                Field f = c.getDeclaredField(name);
                f.setAccessible(true);
                return f.get(target);
            } catch (NoSuchFieldException e) {
                c = c.getSuperclass();
            }
        }
        throw new NoSuchFieldException(name);
    }
}
