package app.mg4dash.radiodash;

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
