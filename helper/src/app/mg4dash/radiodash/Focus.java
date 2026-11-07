package app.mg4dash.radiodash;

import android.content.Context;
import android.util.Log;

/**
 * Focus audio de la radio (RadioService.onAudioFocusChange). La radio d'origine reprend la lecture chaque fois que
 * le son lui revient, même après une perte définitive. Sur SWI69, le gestionnaire de sources de la voiture décide :
 * rien ne change. Sur les anciens firmwares (lanceur com.saicmotor.hmi.launcher, SWI165…), CarPlay rend et reprend
 * le son en cours de lecture, et la radio repartait par-dessus (MG4Dash #99). Là, après une perte définitive, le son
 * rendu ne relance plus la radio : elle attend une commande (source, lecture). Après une perte temporaire (appel,
 * guidage, Siri), elle reprend comme avant.
 */
public final class Focus {
    private static final String TAG = "RadioDash";
    private static volatile boolean lostForGood;
    private static Boolean legacy;

    private Focus() {}

    /** @return true pour ignorer ce changement de focus (le code d'origine n'est pas exécuté) */
    public static boolean skip(Context c, int change) {
        try {
            if (!legacy(c)) return false;
            switch (change) {
                case -1: lostForGood = true; Log.i(TAG, "focus audio perdu (définitif)"); return false;
                case -2: case -3: lostForGood = false; Log.i(TAG, "focus audio perdu (temporaire)"); return false;
                case 1:
                    if (!lostForGood) { Log.i(TAG, "focus audio rendu : reprise"); return false; }
                    lostForGood = false;
                    Log.i(TAG, "focus audio rendu après une perte définitive : pas de reprise");
                    return true;
                default: return false;
            }
        } catch (Throwable t) {
            Log.w(TAG, "focus audio : " + t);
            return false;
        }
    }

    /** Ancien firmware : lanceur hmi.launcher (SWI68 / SWI165…) au lieu de celui de SWI69. */
    private static boolean legacy(Context c) {
        if (legacy == null) {
            boolean l;
            try { c.getPackageManager().getPackageInfo("com.saicmotor.hmi.launcher", 0); l = true; }
            catch (Throwable t) { l = false; }
            legacy = l;
            Log.i(TAG, "focus audio : " + (l ? "ancien firmware, pas de reprise après une perte définitive" : "comportement d'origine"));
        }
        return legacy;
    }
}
