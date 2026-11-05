package app.mg4dash.radiodash;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.Shader;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Cadran FM moderne (remplace la règle d'origine) : piste fine, partie active en dégradé
 * cyan → bleu, curseur lumineux, repères des favoris, graduations et fréquences en gros chiffres.
 * Glisser le curseur pour choisir une fréquence ; l'accord se fait au relâchement. Pendant le glissement,
 * la fréquence s'affiche dans une bulle au-dessus du doigt (calque de l'écran : elle déborde sur le lecteur).
 */
public final class FmDial extends View {
    public interface OnTune { void tune(int channelKHz); }

    private boolean am;              // AM : 522 à 1620 kHz par pas de 9 kHz, sinon FM 87,5 à 108 MHz
    private int MIN = 87500, MAX = 108000, STEP = 100;
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
        label.setColor(Palette.map(0xFFA0AEC0));
        label.setTextSize(24 * d);
        label.setTextAlign(Paint.Align.CENTER);
        fav.setColor(0xFFFF9100);
        glow.setColor(Palette.map(0x4000D2FF));
        thumb.setColor(0xFFFFFFFF);
        bubble.setColor(Palette.map(0xFF2979FF));
        bubbleText.setColor(0xFFFFFFFF);
        bubbleText.setTextSize(30 * d);
        bubbleText.setTextAlign(Paint.Align.CENTER);
        bubbleText.setFakeBoldText(true);
        int res = c.getResources().getIdentifier("icon_radio_item_collection", "mipmap", c.getPackageName());
        heart = res != 0 ? c.getResources().getDrawable(res, null).mutate() : null;   // étoile (mipmap remplacé)
    }

    public void setOnTune(OnTune t) { onTune = t; }

    public void setAm(boolean on) {
        if (on == am) return;
        am = on;
        MIN = am ? 522 : 87500; MAX = am ? 1620 : 108000; STEP = am ? 9 : 100;
        value = -1; dragValue = -1;
        invalidate();
    }

    private String format(int khz) {
        return am ? khz + " kHz" : String.format(Locale.getDefault(), "%.1f", khz / 1000f);
    }

    public void setValue(int khz) {
        if (dragValue < 0 && khz != value) { value = khz; invalidate(); }
    }

    public void setFavorites(List<Integer> f) {
        if (!f.equals(favorites)) { favorites = f; invalidate(); }
    }

    private float pad() { return 28 * d; }

    /** Hauteur de la piste : repères des favoris (26 dp au-dessus) et chiffres (56 dp en dessous) centrés dans le bandeau. */
    private float cy() { return Math.max(26 * d, (getHeight() - 30 * d) / 2f); }

    private float xOf(int khz) {
        float w = getWidth() - 2 * pad();
        return pad() + w * (khz - MIN) / (float) (MAX - MIN);
    }

    private int valueAt(float x) {
        float w = getWidth() - 2 * pad();
        float f = Math.max(0f, Math.min(1f, (x - pad()) / w));
        int v = MIN + Math.round(f * (MAX - MIN) / (float) STEP) * STEP;
        return Math.max(MIN, Math.min(MAX, v));
    }

    @Override protected void onDraw(Canvas c) {
        float cy = cy();
        float th = 6 * d;
        // Graduations : FM, petite marque tous les 1 MHz, libellé tous les 4 MHz ; AM, marque tous les
        // 100 kHz, libellé tous les 200 kHz. La bulle du glissement est au-dessus : les libellés restent visibles.
        int v0 = dragValue >= 0 ? dragValue : value;
        int first = am ? 600 : 88000, last = am ? 1600 : 108000, step = am ? 100 : 1000, major = am ? 200 : 4000;
        for (int f = first; f <= last; f += step) {
            float x = xOf(f);
            boolean big = (f - first) % major == 0;
            float h = big ? 10 * d : 5 * d;
            c.drawRect(x - 0.75f * d, cy + th + 6 * d, x + 0.75f * d, cy + th + 6 * d + h, tick);
            if (!big) continue;
            c.drawText(String.valueOf(am ? f : f / 1000), x, cy + th + 44 * d, label);
        }
        // Piste
        rect.set(pad(), cy - th / 2, getWidth() - pad(), cy + th / 2);
        c.drawRoundRect(rect, th, th, track);
        int v = v0;
        if (v >= MIN && v <= MAX) {
            float x = xOf(v);
            active.setShader(new LinearGradient(pad(), 0, x, 0, Palette.map(0xFF00D2FF), Palette.map(0xFF2979FF), Shader.TileMode.CLAMP));
            rect.set(pad(), cy - th / 2, x, cy + th / 2);
            c.drawRoundRect(rect, th, th, active);
        }
        // Favoris
        if (heart != null) heart.setTint(Palette.starColor());
        if (heart != null) for (Integer f : favorites) {
            if (f < MIN || f > MAX) continue;
            float hs = 16 * d, hx = xOf(f);
            heart.setBounds((int) (hx - hs / 2), (int) (cy - th - 4 * d - hs), (int) (hx + hs / 2), (int) (cy - th - 4 * d));
            heart.draw(c);
        }
        // Curseur
        if (v >= MIN && v <= MAX) {
            float x = xOf(v);
            c.drawCircle(x, cy, 15 * d, glow);
            c.drawCircle(x, cy, 9 * d, thumb);
        }
    }

    // ── Bulle au-dessus du doigt ──

    private final Bubble bubbleD = new Bubble();
    private ViewGroup bubbleHost;

    /** Bulle posée sur le calque du contenu de l'écran, au-dessus du curseur et du doigt. */
    private void showBubble() {
        if (dragValue < 0) return;
        if (bubbleHost == null) {
            View root = getRootView().findViewById(android.R.id.content);
            if (!(root instanceof ViewGroup)) return;
            bubbleHost = (ViewGroup) root;
            bubbleHost.getOverlay().add(bubbleD);
        }
        bubbleD.text = format(dragValue);
        int[] me = new int[2], host = new int[2];
        getLocationInWindow(me);
        bubbleHost.getLocationInWindow(host);
        float w = bubbleText.measureText(bubbleD.text) + 48 * d, h = 62 * d + Bubble.TIP * d;
        float cx = me[0] - host[0] + xOf(dragValue);
        float left = Math.max(8 * d, Math.min(bubbleHost.getWidth() - 8 * d - w, cx - w / 2));
        float bottom = me[1] - host[1] + cy() - 52 * d;   // pointe 52 dp au-dessus de la piste : hors du doigt
        bubbleD.tipX = cx - left;
        bubbleD.setBounds((int) left, (int) (bottom - h), (int) (left + w), (int) bottom);
        bubbleD.invalidateSelf();
    }

    private void hideBubble() {
        if (bubbleHost != null) bubbleHost.getOverlay().remove(bubbleD);
        bubbleHost = null;
    }

    @Override protected void onDetachedFromWindow() {
        hideBubble();
        super.onDetachedFromWindow();
    }

    private final class Bubble extends android.graphics.drawable.Drawable {
        static final int TIP = 12;
        String text = "";
        float tipX;
        private final RectF box = new RectF();
        private final android.graphics.Path tip = new android.graphics.Path();

        @Override public void draw(Canvas c) {
            android.graphics.Rect b = getBounds();
            float t = TIP * d;
            box.set(b.left, b.top, b.right, b.bottom - t);
            c.drawRoundRect(box, 18 * d, 18 * d, bubble);
            float x = b.left + Math.max(20 * d, Math.min(b.width() - 20 * d, tipX));
            tip.reset();
            tip.moveTo(x - t, b.bottom - t - 1);
            tip.lineTo(x, b.bottom);
            tip.lineTo(x + t, b.bottom - t - 1);
            tip.close();
            c.drawPath(tip, bubble);
            Paint.FontMetrics fm = bubbleText.getFontMetrics();
            c.drawText(text, b.exactCenterX(), (box.top + box.bottom) / 2 - (fm.ascent + fm.descent) / 2, bubbleText);
        }

        @Override public void setAlpha(int alpha) {}
        @Override public void setColorFilter(android.graphics.ColorFilter cf) {}
        @Override public int getOpacity() { return android.graphics.PixelFormat.TRANSLUCENT; }
    }

    @Override public boolean onTouchEvent(MotionEvent e) {
        switch (e.getActionMasked()) {
            case MotionEvent.ACTION_DOWN:
                getParent().requestDisallowInterceptTouchEvent(true);
                dragValue = valueAt(e.getX());
                invalidate();
                showBubble();
                return true;
            case MotionEvent.ACTION_MOVE:
                dragValue = valueAt(e.getX());
                invalidate();
                showBubble();
                return true;
            case MotionEvent.ACTION_UP:
                int v = valueAt(e.getX());
                dragValue = -1;
                value = v;
                hideBubble();
                invalidate();
                if (onTune != null) onTune.tune(v);
                return true;
            case MotionEvent.ACTION_CANCEL:
                dragValue = -1;
                hideBubble();
                invalidate();
                return true;
        }
        return super.onTouchEvent(e);
    }
}
