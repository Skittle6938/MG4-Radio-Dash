package app.mg4dash.radiodash;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.Shader;
import android.view.MotionEvent;
import android.view.View;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Cadran FM moderne (remplace la règle d'origine) : piste fine, partie active en dégradé
 * cyan → bleu, curseur lumineux, repères des favoris, graduations discrètes.
 * Glisser le curseur pour choisir une fréquence ; l'accord se fait au relâchement.
 */
public final class FmDial extends View {
    public interface OnTune { void tune(int channelKHz); }

    private static final int MIN = 87500, MAX = 108000, STEP = 50;
    private int value = -1;          // fréquence en kHz
    private int dragValue = -1;
    private List<Integer> favorites = new ArrayList<>();
    private OnTune onTune;

    private final float d;
    private final Paint track = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint active = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint tick = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint label = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint fav = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint glow = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint thumb = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint bubble = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint bubbleText = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final RectF rect = new RectF();
    private final android.graphics.drawable.Drawable heart;

    public FmDial(Context c) {
        super(c);
        d = c.getResources().getDisplayMetrics().density;
        track.setColor(Palette.map(0xFF262D3D));
        tick.setColor(Palette.map(0xFF3A4356));
        label.setColor(0xFF8A94A6);
        label.setTextSize(14 * d);
        label.setTextAlign(Paint.Align.CENTER);
        fav.setColor(0xFFFF9100);
        glow.setColor(Palette.map(0x4000D2FF));
        thumb.setColor(0xFFFFFFFF);
        bubble.setColor(Palette.map(0xFF2979FF));
        bubbleText.setColor(0xFFFFFFFF);
        bubbleText.setTextSize(16 * d);
        bubbleText.setTextAlign(Paint.Align.CENTER);
        bubbleText.setFakeBoldText(true);
        int res = c.getResources().getIdentifier("icon_radio_item_collection", "mipmap", c.getPackageName());
        heart = res != 0 ? c.getResources().getDrawable(res, null).mutate() : null;   // étoile (mipmap remplacé)
    }

    public void setOnTune(OnTune t) { onTune = t; }

    public void setValue(int khz) {
        if (dragValue < 0 && khz != value) { value = khz; invalidate(); }
    }

    public void setFavorites(List<Integer> f) {
        if (!f.equals(favorites)) { favorites = f; invalidate(); }
    }

    private float pad() { return 28 * d; }

    private float xOf(int khz) {
        float w = getWidth() - 2 * pad();
        return pad() + w * (khz - MIN) / (float) (MAX - MIN);
    }

    private int valueAt(float x) {
        float w = getWidth() - 2 * pad();
        float f = Math.max(0f, Math.min(1f, (x - pad()) / w));
        int v = MIN + Math.round(f * (MAX - MIN) / STEP) * STEP;
        return Math.max(MIN, Math.min(MAX, v));
    }

    @Override protected void onDraw(Canvas c) {
        float cy = 30 * d;
        float th = 6 * d;
        // Graduations : petite marque tous les 1 MHz, libellé tous les 4 MHz
        for (int f = 88000; f <= 108000; f += 1000) {
            float x = xOf(f);
            boolean major = (f - 88000) % 4000 == 0;
            float h = major ? 10 * d : 5 * d;
            c.drawRect(x - 0.75f * d, cy + th + 6 * d, x + 0.75f * d, cy + th + 6 * d + h, tick);
            if (major && dragValue < 0) c.drawText(String.valueOf(f / 1000), x, cy + th + 28 * d, label);
        }
        // Piste
        rect.set(pad(), cy - th / 2, getWidth() - pad(), cy + th / 2);
        c.drawRoundRect(rect, th, th, track);
        int v = dragValue >= 0 ? dragValue : value;
        if (v >= MIN) {
            float x = xOf(v);
            active.setShader(new LinearGradient(pad(), 0, x, 0, Palette.map(0xFF00D2FF), Palette.map(0xFF2979FF), Shader.TileMode.CLAMP));
            rect.set(pad(), cy - th / 2, x, cy + th / 2);
            c.drawRoundRect(rect, th, th, active);
        }
        // Favoris
        if (heart != null) heart.setTint(Palette.starColor());
        if (heart != null) for (Integer f : favorites) {
            float hs = 16 * d, hx = xOf(f);
            heart.setBounds((int) (hx - hs / 2), (int) (cy - th - 4 * d - hs), (int) (hx + hs / 2), (int) (cy - th - 4 * d));
            heart.draw(c);
        }
        // Curseur
        if (v >= MIN) {
            float x = xOf(v);
            c.drawCircle(x, cy, 15 * d, glow);
            c.drawCircle(x, cy, 9 * d, thumb);
            if (dragValue >= 0) {
                String s = String.format(Locale.getDefault(), "%.1f", dragValue / 1000f);
                float bw = bubbleText.measureText(s) + 20 * d;
                rect.set(x - bw / 2, cy + 16 * d, x + bw / 2, cy + 44 * d);
                c.drawRoundRect(rect, 12 * d, 12 * d, bubble);
                c.drawText(s, x, cy + 36 * d, bubbleText);
            }
        }
    }

    @Override public boolean onTouchEvent(MotionEvent e) {
        switch (e.getActionMasked()) {
            case MotionEvent.ACTION_DOWN:
                getParent().requestDisallowInterceptTouchEvent(true);
                dragValue = valueAt(e.getX());
                invalidate();
                return true;
            case MotionEvent.ACTION_MOVE:
                dragValue = valueAt(e.getX());
                invalidate();
                return true;
            case MotionEvent.ACTION_UP:
                int v = valueAt(e.getX());
                dragValue = -1;
                value = v;
                invalidate();
                if (onTune != null) onTune.tune(v);
                return true;
            case MotionEvent.ACTION_CANCEL:
                dragValue = -1;
                invalidate();
                return true;
        }
        return super.onTouchEvent(e);
    }
}
