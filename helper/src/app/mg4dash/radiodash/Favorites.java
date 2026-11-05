package app.mg4dash.radiodash;

import android.util.Log;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Passage de station « suivant / précédent » par la session média : boutons du volant, ◀ ▶ de l'écran
 * d'accueil et widget de MG4Dash (RadioService$6.onMediaSessionSkipToNext/Previous). Même liste que les
 * ◀ ▶ et le glissé du lecteur (Stations) : les favoris, ou toutes les stations quand ★ Favoris est éteint.
 * Liste vide : comportement d'origine.
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

    /** DAB : station suivante/précédente de la liste (favoris ou toutes), sinon station valide suivante (origine). */
    public static Object nextDab(Object storage, boolean forward) {
        Object st = Stations.next(Stations.app(), storage, 4, forward);
        if (st != null) return st;
        try {
            return call(storage, forward ? "getDabNextValidStation" : "getDabPreValidStation");
        } catch (Throwable t) {
            Log.w(TAG, "station DAB suivante : " + t);
            return null;
        }
    }

    /**
     * FM/AM : accorde la station suivante/précédente de la liste (favoris ou toutes) de la bande en cours.
     * @param listener l'instance RadioService$6 (écouteur du binder)
     * @return true si une station a été accordée ; false = laisser la recherche d'origine
     */
    public static boolean skipFm(Object listener, boolean forward) {
        try {
            Object service = field(listener, "this$0");
            Object storage = field(service, "mRadioStorage");
            int band = ((Number) field(service, "mCurrentRadioBand")).intValue();
            Object station = Stations.next((android.content.Context) service, storage, band, forward);
            if (station == null) return false;
            for (Method m : service.getClass().getMethods()) {
                if (m.getName().equals("tuneRadioTune") && m.getParameterTypes().length == 1) {
                    m.invoke(service, station);
                    return true;
                }
            }
        } catch (Throwable t) {
            Log.w(TAG, "station FM suivante : " + t);
        }
        return false;
    }

    // ── Réflexion ──

    private static Object call(Object target, String name) throws Exception {
        Method m = target.getClass().getMethod(name);
        return m.invoke(target);
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
