package app.mg4dash.radiodash;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import java.io.File;

/**
 * Image DAB+ de la session média au changement de station : celle mise en cache par le patch DAB+
 * (fichiers/dab_<serviceId>.jpg), sans attendre que la station renvoie son diaporama. Sans cela, MG4Dash
 * gardait un fond vide jusqu'à l'image suivante, alors que la radio l'affichait déjà. Appelé depuis
 * RadioMBService.toSetSessionMetadataDabTitle quand aucune image n'est connue pour la station.
 */
public final class Art {
    private static final String TAG = "RadioDash";
    private static long lastId = -1;
    private static Bitmap last;

    private Art() {}

    /** @param station la RadioDabStation en cours (null : rien) */
    public static Bitmap cached(Context c, Object station) {
        if (c == null || station == null) return null;
        try {
            long id = ((Number) station.getClass().getMethod("getServiceId").invoke(station)).longValue();
            if (id <= 0) return null;
            if (id == lastId && last != null && !last.isRecycled()) return last;
            File f = new File(c.getFilesDir(), "dab_" + id + ".jpg");
            Bitmap b = f.canRead() ? BitmapFactory.decodeFile(f.getPath()) : null;
            if (b != null) { lastId = id; last = b; Log.i(TAG, "image DAB+ en cache pour la session : " + id); }
            return b;
        } catch (Throwable t) {
            Log.w(TAG, "image DAB+ en cache : " + t);
            return null;
        }
    }
}
