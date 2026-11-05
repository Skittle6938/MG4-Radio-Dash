package app.mg4dash.radiodash;

import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;

/**
 * Roue dentée pleine, dans le style des icônes de MG4Dash : corps rond, huit dents aux coins arrondis, trou central.
 * Dessinée à la taille du bouton (l'icône d'origine de la radio gardait de larges marges et paraissait minuscule).
 */
final class Gear extends Drawable {
    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private Path path;
    private int builtFor = -1;

    Gear(int color) {
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(color);
    }

    void setColor(int color) { if (paint.getColor() != color) { paint.setColor(color); invalidateSelf(); } }

    @Override public void draw(Canvas c) {
        Rect b = getBounds();
        int size = Math.min(b.width(), b.height());
        if (size <= 0) return;
        if (path == null || builtFor != size) { path = build(size); builtFor = size; }
        c.save();
        c.translate(b.exactCenterX(), b.exactCenterY());
        c.drawPath(path, paint);
        c.restore();
    }

    /** Chemin centré sur 0,0 pour un carré de côté size. */
    private static Path build(int size) {
        float r = size / 2f;
        float body = r * 0.70f, tooth = r * 0.30f, hole = r * 0.30f;
        Path gear = new Path();
        gear.addCircle(0, 0, body, Path.Direction.CW);
        Matrix m = new Matrix();
        for (int i = 0; i < 8; i++) {
            Path t = new Path();
            // Dent : rectangle arrondi qui part du corps et s'arrête au bord
            t.addRoundRect(new RectF(-tooth / 2, -r, tooth / 2, -body + tooth * 0.4f), tooth * 0.28f, tooth * 0.28f, Path.Direction.CW);
            m.setRotate(i * 45f);
            t.transform(m);
            gear.op(t, Path.Op.UNION);
        }
        Path h = new Path();
        h.addCircle(0, 0, hole, Path.Direction.CW);
        gear.op(h, Path.Op.DIFFERENCE);
        return gear;
    }

    @Override public void setAlpha(int alpha) { paint.setAlpha(alpha); invalidateSelf(); }
    @Override public void setColorFilter(ColorFilter cf) { paint.setColorFilter(cf); invalidateSelf(); }
    @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
}
