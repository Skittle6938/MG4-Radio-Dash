package app.mg4dash.radiodash;

import android.content.Context;
import android.content.Intent;
import android.media.Rating;
import android.media.session.MediaSession;
import android.net.Uri;
import android.os.Bundle;
import android.os.ResultReceiver;
import android.util.Log;

import java.lang.reflect.Method;
import java.util.List;

/**
 * Session média de la radio (RadioMBService) : action personnalisée {@code __ACTION_SET_BAND__} pour aller
 * directement sur une bande, avec l'extra {@code band} = "DAB", "FM" ou "AM". La radio d'origine ne connaît que
 * {@code __ACTION_NEXT_SOURCE__} (bande suivante) : MG4Dash devait avancer bande par bande en relisant la bande
 * affichée, et dépassait la bande voulue quand la radio tardait à la publier (surtout avec l'AM, sur SWI68).
 *
 * Les extras de la session portent {@code radiodash.set_band = true} : MG4Dash sait ainsi que cette action existe
 * (Radio Dash garde le numéro de version de la radio d'origine). Tout le reste est transmis à l'écouteur d'origine.
 */
public final class Bands {
    private static final String TAG = "RadioDash";
    public static final String ACTION_SET_BAND = "__ACTION_SET_BAND__";

    private Bands() {}

    /** Remplace {@code session.setCallback(original)} dans RadioMBService.onCreate. */
    public static void session(final Context service, MediaSession session, final MediaSession.Callback original) {
        if (original == null) { session.setCallback(null); return; }
        try {
            wrap(service, session, original);
        } catch (Throwable t) {
            // Jamais de session sans écouteur : volant et carte MG4Dash en dépendent
            Log.w(TAG, "session média non enveloppée : " + t);
            session.setCallback(original);
        }
    }

    private static void wrap(final Context service, MediaSession session, final MediaSession.Callback original) {
        session.setCallback(new MediaSession.Callback() {
            @Override public void onCommand(String command, Bundle args, ResultReceiver cb) { original.onCommand(command, args, cb); }
            // Écouteur d'origine d'abord ; s'il ne traite pas la touche (il n'est pas lui-même attaché à la session),
            // le traitement standard la convertit en onPlay / onPause / onSkipTo…, transmis ci-dessous.
            @Override public boolean onMediaButtonEvent(Intent intent) {
                return original.onMediaButtonEvent(intent) || super.onMediaButtonEvent(intent);
            }
            @Override public void onPrepare() { original.onPrepare(); }
            @Override public void onPrepareFromMediaId(String id, Bundle extras) { original.onPrepareFromMediaId(id, extras); }
            @Override public void onPrepareFromSearch(String query, Bundle extras) { original.onPrepareFromSearch(query, extras); }
            @Override public void onPrepareFromUri(Uri uri, Bundle extras) { original.onPrepareFromUri(uri, extras); }
            @Override public void onPlay() { original.onPlay(); }
            @Override public void onPlayFromSearch(String query, Bundle extras) { original.onPlayFromSearch(query, extras); }
            @Override public void onPlayFromMediaId(String id, Bundle extras) { original.onPlayFromMediaId(id, extras); }
            @Override public void onPlayFromUri(Uri uri, Bundle extras) { original.onPlayFromUri(uri, extras); }
            @Override public void onSkipToQueueItem(long id) { original.onSkipToQueueItem(id); }
            @Override public void onPause() { original.onPause(); }
            @Override public void onSkipToNext() { original.onSkipToNext(); }
            @Override public void onSkipToPrevious() { original.onSkipToPrevious(); }
            @Override public void onFastForward() { original.onFastForward(); }
            @Override public void onRewind() { original.onRewind(); }
            @Override public void onStop() { original.onStop(); }
            @Override public void onSeekTo(long pos) { original.onSeekTo(pos); }
            @Override public void onSetRating(Rating rating) { original.onSetRating(rating); }
            @Override public void onCustomAction(String action, Bundle extras) {
                if (ACTION_SET_BAND.equals(action)) { setBand(service, extras == null ? null : extras.getString("band")); return; }
                original.onCustomAction(action, extras);
            }
        });
        Bundle flags = new Bundle();
        flags.putBoolean("radiodash.set_band", true);
        session.setExtras(flags);
        Log.i(TAG, "session média : " + ACTION_SET_BAND + " disponible");
    }

    /**
     * Bandes de la radio, dans l'ordre où « bande suivante » les parcourt. La radio les lit dans la configuration de
     * la voiture (FeatureUtil.getRadioBands), vide sur SWI68 : la liste valait null, et changeSource ne faisait rien,
     * ni pour {@code __ACTION_SET_BAND__} ni pour {@code __ACTION_NEXT_SOURCE__} d'origine (MG4Dash #80). Dans ce
     * cas : DAB, FM, AM, l'ordre des onglets. Remplace l'appel d'origine dans RadioMBService.changeSource.
     */
    public static List<Integer> radioBands() {
        try {
            Object l = Class.forName("com.saicmotor.radio.utils.FeatureUtil").getMethod("getRadioBands").invoke(null);
            if (l instanceof List && !((List<?>) l).isEmpty()) {
                @SuppressWarnings("unchecked") List<Integer> bands = (List<Integer>) l;
                return bands;
            }
        } catch (Throwable t) {
            Log.w(TAG, "bandes de la radio : " + t);
        }
        if (!fallbackLogged) { fallbackLogged = true; Log.i(TAG, "bandes absentes de la configuration : DAB, FM, AM"); }
        return java.util.Arrays.asList(4, 1, 0);
    }
    private static boolean fallbackLogged;

    /** Bande demandée (DAB = 4, FM = 1, AM = 0) : ignorée si la radio ne l'a pas, rien à faire si elle y est déjà. */
    static void setBand(Context service, String name) {
        int target = "DAB".equalsIgnoreCase(name) ? 4 : "FM".equalsIgnoreCase(name) ? 1 : "AM".equalsIgnoreCase(name) ? 0 : -1;
        if (target < 0) { Log.w(TAG, "bande demandée inconnue : " + name); return; }
        try {
            List<?> bands = radioBands();
            if (!bands.contains(target)) { Log.i(TAG, "bande " + name + " absente de cette radio " + bands); return; }
            Object storage = Class.forName("com.saicmotor.radio.model.RadioStorage")
                    .getMethod("getInstance", Context.class).invoke(null, service.getApplicationContext());
            int current = ((Number) storage.getClass().getMethod("getStoredRadioBand").invoke(storage)).intValue();
            if (current == target) { Log.i(TAG, "bande " + name + " demandée : déjà dessus"); return; }
            // changeSource(bande, suivante) passe à la bande qui suit celle donnée : on lui donne celle d'avant
            int i = bands.indexOf(target), n = bands.size();
            int before = ((Number) bands.get((i - 1 + n) % n)).intValue();
            Method change = service.getClass().getDeclaredMethod("changeSource", int.class, boolean.class);
            change.setAccessible(true);
            change.invoke(service, before, true);
            Log.i(TAG, "bande " + name + " demandée : " + current + " → " + target);
        } catch (Throwable t) {
            Log.w(TAG, "bande " + name + " : " + t);
        }
    }
}
