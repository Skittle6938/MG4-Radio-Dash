package app.mg4dash.radiodash;

import android.app.Activity;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Outline;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewOutlineProvider;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Lecteur « Immersif » (réglage « Lecteur de l'accueil » de MG4Dash, partagé avec l'accueil) : comme
 * le lecteur d'Android Auto, l'image de la station couvre tout le panneau, prolongée par la couleur de
 * son bord ; textes en blanc par-dessus, bouton lecture en pilule et icônes précédent / suivant
 * blanches, à la couleur vive de l'image. Les vues d'origine (et leurs identifiants) restent en place :
 * on pose seulement l'image derrière le panneau et on change leurs fonds.
 */
final class Immersive {
    private static final String TAG_HOLDER = "rd_imm";
    private static Bitmap lastArt;
    private static int accent = 0xFF2979FF, edge = 0xFF1C2230;

    private Immersive() {}

    /** Appelé à chaque rafraîchissement, après la recoloration du thème. */
    static void apply(Activity a, View artView, Bitmap art) {
        if (Palette.mediaStyle != 0 || artView == null) return;
        View frame = (View) artView.getParent();
        if (!(frame.getParent() instanceof ViewGroup)) return;
        ViewGroup row = (ViewGroup) frame.getParent();
        if (!(row.getParent() instanceof ViewGroup)) return;
        ViewGroup panel = (ViewGroup) row.getParent();
        if (!(panel.getParent() instanceof RelativeLayout)) return;
        RelativeLayout container = (RelativeLayout) panel.getParent();
        frame.setVisibility(View.GONE);
        panel.setBackground(null);
        FrameLayout holder = (FrameLayout) container.findViewWithTag(TAG_HOLDER);
        if (holder == null) {
            holder = new FrameLayout(a);
            holder.setTag(TAG_HOLDER);
            final int r = dp(a, 20);
            holder.setOutlineProvider(new ViewOutlineProvider() {
                @Override public void getOutline(View v, Outline o) { o.setRoundRect(0, 0, v.getWidth(), v.getHeight(), r); }
            });
            holder.setClipToOutline(true);
            ImageView pic = new ImageView(a);
            pic.setScaleType(ImageView.ScaleType.FIT_END);
            holder.addView(pic, new FrameLayout.LayoutParams(-1, -1));
            View fade = new View(a);
            holder.addView(fade, new FrameLayout.LayoutParams(0, -1, Gravity.START));
            View shade = new View(a);
            shade.setBackground(new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM,
                    new int[]{0x55000000, 0x66000000, 0xC8000000}));
            holder.addView(shade, new FrameLayout.LayoutParams(-1, -1));
            final FrameLayout h = holder;
            holder.addOnLayoutChangeListener((v, l, t, rr, b, ol, ot, orr, ob) -> placeFade(h));
            container.addView(holder, 0, new RelativeLayout.LayoutParams(-1, -1));
            lastArt = null;
        }
        if (art != lastArt) {
            lastArt = art;
            ImageView pic = (ImageView) holder.getChildAt(0);
            if (art != null) {
                pic.setImageBitmap(art);
                edge = edgeColor(art);
                Integer v = vividColor(art);
                accent = v != null ? v : Palette.accent();
            } else {
                pic.setImageDrawable(null);
                edge = 0xFF1C2230;
                accent = Palette.accent();
            }
            holder.setBackgroundColor(edge);
            holder.getChildAt(1).setBackground(new GradientDrawable(GradientDrawable.Orientation.LEFT_RIGHT,
                    new int[]{edge, edge & 0x00FFFFFF}));
            placeFade(holder);
        }
        whiteTexts(panel);
        styleButtons(a, panel);
    }

    /** Fondu posé sur le bord gauche de l'image (calée à droite). */
    private static void placeFade(FrameLayout holder) {
        View fade = holder.getChildAt(1);
        Bitmap art = lastArt;
        int w = holder.getWidth(), h = holder.getHeight();
        if (art == null || w == 0 || h == 0 || art.getHeight() == 0) { fade.setVisibility(View.GONE); return; }
        int imgW = Math.min(w, h * art.getWidth() / art.getHeight());
        FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) fade.getLayoutParams();
        int fw = imgW * 2 / 5;
        fade.setVisibility(imgW < w ? View.VISIBLE : View.GONE);
        if (lp.leftMargin != w - imgW || lp.width != fw) {
            lp.leftMargin = w - imgW; lp.width = fw;
            fade.post(() -> fade.setLayoutParams(lp));
        }
    }

    private static void whiteTexts(View v) {
        if (v instanceof TextView && !(v instanceof android.widget.Button)) {
            TextView t = (TextView) v;
            if (t.getCurrentTextColor() != Color.WHITE && !isAccentText(t)) t.setTextColor(0xFFF2F2F2);
            t.setShadowLayer(6f, 0f, 2f, 0x99000000);
        }
        if (v instanceof ViewGroup) {
            ViewGroup g = (ViewGroup) v;
            for (int i = 0; i < g.getChildCount(); i++) whiteTexts(g.getChildAt(i));
        }
    }

    /** Texte « en cours de diffusion » (couleur du thème) : il prend la couleur vive de l'image. */
    private static boolean isAccentText(TextView t) {
        String n = name(t);
        if (n.equals("tv_dab_frequency_name") || n.equals("tv_radio_channel_nowplaying_text")) { t.setTextColor(accent); return true; }
        return false;
    }

    private static void styleButtons(Activity a, View root) {
        for (String n : new String[]{"btn_dab_previous", "btn_previous"}) icon(a, root, n, "rd_ic_prev");
        for (String n : new String[]{"btn_dab_next", "btn_next"}) icon(a, root, n, "rd_ic_next");
        for (String n : new String[]{"ib_dab_play_pause", "btn_play_pause"}) {
            View p = find(root, n);
            if (!(p instanceof ImageView)) continue;
            GradientDrawable pill = new GradientDrawable();
            pill.setCornerRadius(dp(a, 50));
            pill.setColor(accent);
            p.setBackground(pill);
            ((ImageView) p).setImageTintList(ColorStateList.valueOf(0xFF1A1A1A));
            ViewGroup.LayoutParams lp = p.getLayoutParams();
            if (lp.width != dp(a, 200)) { lp.width = dp(a, 200); lp.height = dp(a, 100); p.setLayoutParams(lp); }
        }
    }

    /** Précédent / suivant : l'icône seule, en blanc, sans pavé. */
    private static void icon(Activity a, View root, String name, String iconRes) {
        View b = find(root, name);
        if (b == null || "rd_imm_icon".equals(b.getTag())) return;
        int res = a.getResources().getIdentifier(iconRes, "drawable", a.getPackageName());
        if (res == 0) return;
        Drawable ic = a.getDrawable(res).mutate();
        ic.setTint(Color.WHITE);
        LayerDrawable ld = new LayerDrawable(new Drawable[]{ic});
        ld.setLayerGravity(0, Gravity.CENTER);
        ld.setLayerSize(0, dp(a, 56), dp(a, 56));
        b.setBackground(ld);
        b.setTag("rd_imm_icon");
    }

    private static View find(View v, String n) {
        if (n.equals(name(v))) return v;
        if (v instanceof ViewGroup) {
            ViewGroup g = (ViewGroup) v;
            for (int i = 0; i < g.getChildCount(); i++) { View r = find(g.getChildAt(i), n); if (r != null) return r; }
        }
        return null;
    }

    private static String name(View v) {
        if (v.getId() == View.NO_ID) return "";
        try { return v.getResources().getResourceEntryName(v.getId()); } catch (Exception e) { return ""; }
    }

    /** Couleur moyenne de la bande gauche de l'image (prolongement quand elle n'a pas le format du panneau). */
    static int edgeColor(Bitmap b) {
        long r = 0, g = 0, bl = 0, n = 0;
        int w = Math.max(1, b.getWidth() / 12);
        for (int x = 0; x < w; x += 2) for (int y = 0; y < b.getHeight(); y += 3) {
            int c = b.getPixel(x, y); r += Color.red(c); g += Color.green(c); bl += Color.blue(c); n++;
        }
        if (n == 0) return 0xFF1C2230;
        return Color.rgb((int) (r / n), (int) (g / n), (int) (bl / n));
    }

    /** Couleur vive dominante : la teinte (par tranches de 30°) qui pèse le plus en saturation × luminosité. */
    static Integer vividColor(Bitmap b) {
        float[] w = new float[12], hsv = new float[3];
        float[][] sum = new float[12][3];
        int step = Math.max(1, b.getWidth() / 80);
        for (int x = 0; x < b.getWidth(); x += step) for (int y = 0; y < b.getHeight(); y += step) {
            Color.colorToHSV(b.getPixel(x, y), hsv);
            if (hsv[1] < 0.35f || hsv[2] < 0.45f) continue;
            int k = ((int) (hsv[0] / 30f)) % 12; float wt = hsv[1] * hsv[2];
            w[k] += wt; sum[k][0] += hsv[0] * wt; sum[k][1] += hsv[1] * wt; sum[k][2] += hsv[2] * wt;
        }
        int best = 0;
        for (int k = 1; k < 12; k++) if (w[k] > w[best]) best = k;
        if (w[best] == 0f) return null;
        return Color.HSVToColor(new float[]{sum[best][0] / w[best], Math.max(0.65f, sum[best][1] / w[best]), Math.max(0.85f, sum[best][2] / w[best])});
    }

    private static int dp(Activity a, int v) { return (int) (v * a.getResources().getDisplayMetrics().density); }
}
