package app.mg4dash.radiodash;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.DrawableContainer;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.lang.reflect.Field;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.WeakHashMap;

/**
 * Thème de MG4Dash appliqué à la radio : MG4Dash publie son choix dans Settings.Global
 * ("mg4dash_theme" = "fond,boutons"). Les couleurs de Radio Dash sont celles du thème d'origine
 * (bleu nuit + bleu) ; on remplace chacune par son équivalent du thème choisi, en parcourant les
 * vues (fonds, contours, textes, teintes). Mêmes tables que i18n/theme_gen.py de MG4Dash.
 */
public final class Palette {
    private static final String TAG = "RadioDash";

    // Fonds : haut, bas, fin du dégradé, panneau, bordure, bouton au repos, bouton appuyé, jauge éteinte
    private static final int[][] BG = {
            {0x0B0F17, 0x141B29, 0x0E1420, 0x12161F, 0x2A3142, 0x1C2231, 0x283048, 0x262D3D},
            {0x050506, 0x0E0E10, 0x08080A, 0x121214, 0x2A2A2F, 0x1B1B1F, 0x2A2A31, 0x26262B},
            {0x15171A, 0x22252A, 0x191B1E, 0x21242A, 0x3A3F46, 0x2B2F35, 0x3A3F47, 0x33383F},
            {0x07110E, 0x0F2019, 0x0A1712, 0x0F1B16, 0x243A30, 0x16271F, 0x22392D, 0x1F2E27},
            {0x13090C, 0x231117, 0x190C10, 0x1C1015, 0x3B2229, 0x29161C, 0x3B2129, 0x2E1C22},
    };
    // Boutons : action, sélection
    private static final int[][] ACC = {
            {0x2979FF, 0x00D2FF}, {0x8E99A8, 0xCFD6DF}, {0xE53935, 0xFF8A80}, {0x00C853, 0x69F0AE}, {0xFF8F00, 0xFFC46B},
    };

    // Mode clair (mêmes tables que MG4Dash) : fonds clairs, boutons plus soutenus, textes foncés
    private static final int[][] BG_LIGHT = {
            {0xE9EEF6, 0xF6F8FC, 0xEDF1F8, 0xFFFFFF, 0xCBD3E1, 0xE3E8F0, 0xD3DAE6, 0xD5DBE5},
            {0xEDEDED, 0xF8F8F8, 0xF1F1F1, 0xFFFFFF, 0xCFCFD4, 0xE6E6EA, 0xD6D6DC, 0xD9D9DE},
            {0xE4E6E9, 0xF2F3F5, 0xE9EBEE, 0xFCFCFD, 0xC7CBD1, 0xDDE0E4, 0xCDD1D7, 0xD2D6DB},
            {0xE6F0EB, 0xF4F9F6, 0xEAF3EE, 0xFFFFFF, 0xC4D6CC, 0xDCE8E1, 0xCCDDD3, 0xD2E0D8},
            {0xF2E8EA, 0xFAF4F5, 0xF5ECEE, 0xFFFFFF, 0xDCC7CC, 0xEDE0E3, 0xE2D0D4, 0xE4D5D8},
    };
    private static final int[][] ACC_LIGHT = {
            {0x1E63D6, 0x0088AD}, {0x5E6878, 0x46505E}, {0xD32F2F, 0xB71C1C}, {0x00A142, 0x007F35}, {0xE67E00, 0xB86200},
    };
    private static final int TEXT_DARK = 0x141922;

    private static final Map<Integer, Integer> MAP = new HashMap<>();
    private static boolean lightMode = false;
    /** Barre verticale à gauche choisie dans MG4Dash (4e champ de mg4dash_theme). */
    public static boolean verticalDock = false;
    private static String loaded = null;
    private static boolean identity = true;
    private static final Map<TextView, ColorStateList> textDone = new WeakHashMap<>();
    private static final Set<Object> done = Collections.newSetFromMap(new WeakHashMap<Object, Boolean>());

    private Palette() {}

    /** Relit le thème choisi dans MG4Dash ; renvoie true s'il a changé. */
    public static boolean load(Context c) {
        String v = null;
        try { v = Settings.Global.getString(c.getContentResolver(), "mg4dash_theme"); } catch (Throwable ignored) {}
        if (v == null) v = "0,0";
        if (v.equals(loaded)) return false;
        loaded = v;
        int b = 0, a = 0;
        boolean lm = false;
        try {
            String[] p = v.split(",");
            b = Math.max(0, Math.min(BG.length - 1, Integer.parseInt(p[0].trim())));
            a = Math.max(0, Math.min(ACC.length - 1, Integer.parseInt(p[1].trim())));
            if (p.length > 2) lm = "1".equals(p[2].trim());
            verticalDock = p.length > 3 && "1".equals(p[3].trim());
        } catch (Throwable ignored) {}
        lightMode = lm;
        identity = b == 0 && a == 0 && !lm;
        MAP.clear();
        done.clear();
        textDone.clear();
        int[] o = BG[0], n = (lm ? BG_LIGHT : BG)[b];
        for (int i = 0; i < o.length; i++) MAP.put(o[i], n[i]);
        MAP.put(0x141925, n[1]);                       // fond propre à la radio
        MAP.put(0x3A4356, light(n[4], 0.10f));          // graduations du cadran FM
        int act = (lm ? ACC_LIGHT : ACC)[a][0], sel = (lm ? ACC_LIGHT : ACC)[a][1];
        if (lm) {
            // Textes : blanc → foncé, gris → gris foncé
            MAP.put(0xFFFFFF, TEXT_DARK);
            MAP.put(0xE6EAF0, TEXT_DARK);
            MAP.put(0xA0AEC0, 0x4A5466);
            MAP.put(0x8A94A6, 0x5A6475);
        }
        MAP.put(0x2979FF, act);
        MAP.put(0x00D2FF, sel);
        MAP.put(0x1A5CCC, shade(act, 0.70f));
        MAP.put(0x1A4FB0, shade(act, 0.70f));
        MAP.put(0x123A8C, shade(act, 0.45f));
        MAP.put(0x0D2A66, shade(act, 0.32f));
        MAP.put(0x4A8CFF, light(act, 0.18f));
        Log.i(TAG, "thème " + v);
        return true;
    }

    /** Couleur du thème choisi correspondant à une couleur d'origine (alpha conservé). */
    public static int map(int color) {
        if (identity) return color;
        Integer n = MAP.get(color & 0xFFFFFF);
        return n == null ? color : (color & 0xFF000000) | n;
    }

    /** Couleur des étoiles de favoris : le bouton d'action du thème MG4Dash choisi. */
    public static int starColor() {
        return map(0xFF2979FF);
    }

    /**
     * Teinte les étoiles de favoris à la couleur du thème : le bouton étoile de la radio (ib_favorite,
     * ib_dab_favorite) et l'étoile des listes de stations (fond de img_radio_list_item_favorite).
     * Ne dépend pas du mode clair : appelé à chaque rafraîchissement.
     */
    public static void tintStars(View v) {
        if (v == null) return;
        try {
            if (v instanceof ImageView && v.getId() != View.NO_ID) {
                String name = v.getResources().getResourceEntryName(v.getId());
                ColorStateList tint = ColorStateList.valueOf(starColor());
                if (name.equals("ib_favorite") || name.equals("ib_dab_favorite")) {
                    ((ImageView) v).setImageTintList(tint);
                } else if (name.equals("img_radio_list_item_favorite")) {
                    v.setBackgroundTintList(tint);
                    ((ImageView) v).setImageTintList(tint);
                }
            }
            if (v instanceof ViewGroup) {
                ViewGroup g = (ViewGroup) v;
                for (int i = 0; i < g.getChildCount(); i++) tintStars(g.getChildAt(i));
            }
        } catch (Throwable t) {
            Log.w(TAG, "tintStars : " + t);
        }
    }

    /** Recolore une vue et ses enfants (déjà traités : ignorés). */
    public static void recolor(View v) {
        if (identity || v == null) return;
        try {
            Drawable bg = v.getBackground();
            if (bg != null && !done.contains(bg)) {
                Drawable m = bg.mutate();
                recolor(m);
                done.add(m);
                if (m != bg) v.setBackground(m);
            }
            if (v instanceof TextView) {
                TextView t = (TextView) v;
                // L'appli rebranche la couleur d'origine quand la station change : on la recolore alors aussi.
                if (textDone.get(t) != t.getTextColors()) {
                    ColorStateList mapped = map(t.getTextColors());
                    t.setTextColor(mapped);
                    textDone.put(t, t.getTextColors());
                }
            }
            if (lightMode && v instanceof ImageView && !done.contains("icon" + System.identityHashCode(v))) {
                ImageView iv = (ImageView) v;
                Drawable d = iv.getDrawable();
                String name = "";
                try { if (v.getId() != View.NO_ID) name = v.getResources().getResourceEntryName(v.getId()); } catch (Throwable ignored) {}
                boolean vector = d instanceof android.graphics.drawable.VectorDrawable
                        || (d instanceof DrawableContainer && !(d.getCurrent() instanceof android.graphics.drawable.BitmapDrawable));
                // Icônes blanches sur fond clair → foncées ; pas le bouton lecture (sur fond coloré) ni le cœur des favoris
                if (vector && iv.getColorFilter() == null && iv.getImageTintList() == null
                        && !name.equals("btn_play_pause") && !name.equals("ib_favorite") && !name.equals("ib_dab_favorite") && !"rd_art".equals(v.getTag())) {
                    iv.setColorFilter(0xFF000000 | TEXT_DARK, android.graphics.PorterDuff.Mode.SRC_IN);
                }
                done.add("icon" + System.identityHashCode(v));
            }
            if (v instanceof ImageView) {
                ImageView iv = (ImageView) v;
                ColorStateList tint = iv.getImageTintList();
                if (tint != null && !done.contains(v)) { iv.setImageTintList(map(tint)); done.add(v); }
            }
            if (v instanceof ViewGroup) {
                ViewGroup g = (ViewGroup) v;
                for (int i = 0; i < g.getChildCount(); i++) recolor(g.getChildAt(i));
            }
        } catch (Throwable t) {
            Log.w(TAG, "recolor : " + t);
        }
    }

    private static void recolor(Drawable d) throws Exception {
        if (d instanceof GradientDrawable) {
            GradientDrawable g = (GradientDrawable) d;
            int[] colors = g.getColors();
            if (colors != null) {
                int[] c2 = new int[colors.length];
                for (int i = 0; i < colors.length; i++) c2[i] = map(colors[i]);
                g.setColors(c2);
            } else if (g.getColor() != null) {
                g.setColor(map(g.getColor()));
            }
            Object st = field(g, "mGradientState");
            if (st != null) {
                Object w = field(st, "mStrokeWidth");
                Object sc = field(st, "mStrokeColors");
                if (w instanceof Integer && (Integer) w > 0 && sc instanceof ColorStateList) {
                    g.setStroke((Integer) w, map((ColorStateList) sc));
                }
            }
        } else if (d instanceof DrawableContainer) {
            Drawable.ConstantState cs = d.getConstantState();
            if (cs instanceof DrawableContainer.DrawableContainerState) {
                for (Drawable child : ((DrawableContainer.DrawableContainerState) cs).getChildren()) {
                    if (child != null) recolor(child);
                }
            }
        } else if (d instanceof LayerDrawable) {
            LayerDrawable l = (LayerDrawable) d;
            for (int i = 0; i < l.getNumberOfLayers(); i++) recolor(l.getDrawable(i));
        } else if (d instanceof ColorDrawable) {
            ColorDrawable c = (ColorDrawable) d;
            c.setColor(map(c.getColor()));
        }
    }

    private static ColorStateList map(ColorStateList csl) {
        if (csl == null) return null;
        try {
            int[][] states = (int[][]) field(csl, "mStateSpecs");
            int[] colors = (int[]) field(csl, "mColors");
            if (states != null && colors != null) {
                int[] c2 = new int[colors.length];
                for (int i = 0; i < colors.length; i++) c2[i] = map(colors[i]);
                return new ColorStateList(states, c2);
            }
        } catch (Throwable ignored) {}
        return ColorStateList.valueOf(map(csl.getDefaultColor()));
    }

    private static Object field(Object o, String name) {
        for (Class<?> c = o.getClass(); c != null; c = c.getSuperclass()) {
            try {
                Field f = c.getDeclaredField(name);
                f.setAccessible(true);
                return f.get(o);
            } catch (NoSuchFieldException ignored) {
            } catch (Throwable t) {
                return null;
            }
        }
        return null;
    }

    private static int shade(int rgb, float f) {
        int r = (int) (((rgb >> 16) & 0xFF) * f), g = (int) (((rgb >> 8) & 0xFF) * f), b = (int) ((rgb & 0xFF) * f);
        return (r << 16) | (g << 8) | b;
    }

    private static int light(int rgb, float f) {
        int r = (rgb >> 16) & 0xFF, g = (rgb >> 8) & 0xFF, b = rgb & 0xFF;
        r = (int) (r + (255 - r) * f); g = (int) (g + (255 - g) * f); b = (int) (b + (255 - b) * f);
        return (r << 16) | (g << 8) | b;
    }
}
