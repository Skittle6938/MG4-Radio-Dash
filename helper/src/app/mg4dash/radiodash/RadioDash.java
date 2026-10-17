package app.mg4dash.radiodash;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Outline;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.media.MediaMetadata;
import android.media.browse.MediaBrowser;
import android.media.session.MediaController;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewOutlineProvider;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.File;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Habillage MG4Dash de l'appli radio SAIC (fork MG4-Radio-Dash).
 *
 * Appelé depuis RadioMainActivity (onCreate / onResume / onPause) par trois lignes smali.
 * - plein écran (barres SAIC masquées, glisser depuis le bord pour les revoir) ;
 * - dock MG4Dash en bas (heure + Accueil, Véhicule, Clim, Énergie, Android Auto, Paramètres) ;
 * - grande pochette : vues marquées android:tag="rd_art", alimentées par la session média
 *   de la radio (la même image que sur l'accueil), avec le cache DAB du patch en secours ;
 * - tuiles favoris : conteneurs android:tag="rd_favs_dab" / "rd_favs_fm".
 */
public final class RadioDash {
    private static final String TAG = "RadioDash";

    /** Libellés du dock et de l'aide, dans la langue de la voiture (anglais par défaut). */
    private static final String[][] I18N = {
            // en, fr, de, es, it, nl
            {"Home", "Accueil", "Start", "Inicio", "Home", "Start"},
            {"Vehicle", "Véhicule", "Fahrzeug", "Vehículo", "Veicolo", "Voertuig"},
            {"Climate", "Clim", "Klima", "Clima", "Clima", "Klimaat"},
            {"Energy", "Énergie", "Energie", "Energía", "Energia", "Energie"},
            {"Android Auto", "Android Auto", "Android Auto", "Android Auto", "Android Auto", "Android Auto"},
            {"Settings", "Paramètres", "Einstellungen", "Ajustes", "Impostazioni", "Instellingen"},
            {"Add favourites with ♥: the steering wheel and home screen will skip between them",
                    "Ajoutez des favoris avec ♥ : le volant et l'accueil passeront de l'un à l'autre",
                    "Favoriten mit ♥ hinzufügen: Lenkrad und Startbildschirm wechseln dann zwischen ihnen",
                    "Añada favoritos con ♥: el volante y la pantalla de inicio pasarán de uno a otro",
                    "Aggiungi preferiti con ♥: volante e schermata home passeranno dall'uno all'altro",
                    "Voeg favorieten toe met ♥: stuur en startscherm schakelen dan tussen deze zenders"},
    };

    private static String tr(int i) {
        int col = java.util.Arrays.asList("en", "fr", "de", "es", "it", "nl").indexOf(Locale.getDefault().getLanguage());
        return I18N[i][Math.max(col, 0)];
    }
    private static final String DASH = "app.mg4dash";

    // Charte MG4Dash
    private static final int PANEL = 0xD912161F, BORDER = 0xFF2A3142, BUTTON = 0xFF1C2231;
    private static final int TEXT = 0xFFFFFFFF, SUB = 0xFFA0AEC0, TITLE = 0xFF8A94A6;
    private static final int ACTION = 0xFF2979FF, COLD = 0xFF00D2FF;

    private static final Handler main = new Handler(Looper.getMainLooper());
    private static Activity current;
    private static MediaBrowser browser;
    private static MediaController controller;
    private static Bitmap art;
    private static Object radioManager;
    private static TextView clock, date;

    private RadioDash() {}

    // ── Cycle de vie ─────────────────────────────────────────────────────────

    public static void onCreate(Activity a) {
        try {
            current = a;
            Palette.load(a);
            fullscreen(a);
            installDock(a);
            connectSession(a);
            bindRadioService(a);
        } catch (Throwable t) {
            Log.w(TAG, "onCreate : " + t);
        }
    }

    public static void onResume(Activity a) {
        current = a;
        try {
            // Thème changé dans MG4Dash : on reconstruit l'écran avec les nouvelles couleurs
            if (Palette.load(a)) { a.recreate(); return; }
            fullscreen(a);
            main.removeCallbacks(tick);
            main.post(tick);
        } catch (Throwable t) {
            Log.w(TAG, "onResume : " + t);
        }
    }

    public static void onPause(Activity a) {
        main.removeCallbacks(tick);
    }

    /** Rafraîchissement : horloge, pochettes, tuiles favoris (toutes les 2 s). */
    private static final Runnable tick = new Runnable() {
        @Override public void run() {
            Activity a = current;
            if (a == null) return;
            try {
                // Thème auto : MG4Dash republie le thème quand les feux s'allument ou s'éteignent,
                // même si la radio reste affichée ; on le relit ici et on redessine l'écran.
                if (Palette.load(a)) { a.recreate(); return; }
                if (clock != null) {
                    Date now = new Date();
                    clock.setText(new SimpleDateFormat("HH:mm", Locale.getDefault()).format(now));
                    date.setText(new SimpleDateFormat("EEE d MMM", Locale.getDefault()).format(now).replace(".", ""));
                }
                fixLayout(a);
                applyArt(a);
                renderFavorites(a);
                updateFmDial(a);
                Palette.recolor(a.getWindow().getDecorView());
            } catch (Throwable t) {
                Log.w(TAG, "rafraîchissement : " + t);
            }
            main.postDelayed(this, 2000);
        }
    };

    // ── Plein écran ──────────────────────────────────────────────────────────

    @SuppressWarnings("deprecation")
    private static void fullscreen(final Activity a) {
        final View decor = a.getWindow().getDecorView();
        final int flags = View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_FULLSCREEN;
        decor.setSystemUiVisibility(flags);
        decor.setOnSystemUiVisibilityChangeListener(new View.OnSystemUiVisibilityChangeListener() {
            @Override public void onSystemUiVisibilityChange(int visibility) {
                if ((visibility & View.SYSTEM_UI_FLAG_FULLSCREEN) == 0) {
                    main.postDelayed(new Runnable() {
                        @Override public void run() { decor.setSystemUiVisibility(flags); }
                    }, 4000);
                }
            }
        });
    }

    // ── Dock ─────────────────────────────────────────────────────────────────

    private static void installDock(final Activity a) {
        ViewGroup content = a.findViewById(android.R.id.content);
        if (content == null || content.findViewWithTag("rd_dock") != null) return;
        View app = content.getChildAt(0);
        boolean vertical = Palette.verticalDock;
        // Le contenu d'origine laisse la place au dock : 84 dp en bas, ou 64 dp à gauche (barre verticale).
        if (app != null) {
            FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) app.getLayoutParams();
            if (vertical) lp.leftMargin = dp(a, 16 + 64 + 4);
            else lp.bottomMargin = dp(a, 108);
            app.setLayoutParams(lp);
            app.setBackgroundColor(Color.TRANSPARENT);
        }
        GradientDrawable bg = new GradientDrawable(GradientDrawable.Orientation.TL_BR,
                new int[]{0xFF141B29, 0xFF0B0F17, 0xFF0E1420});
        content.setBackground(bg);
        if (vertical) { installVerticalDock(a, content); return; }

        LinearLayout dock = new LinearLayout(a);
        dock.setTag("rd_dock");
        dock.setOrientation(LinearLayout.HORIZONTAL);
        dock.setBackground(panel(a, PANEL, 20));
        dock.setPadding(dp(a, 8), dp(a, 6), dp(a, 8), dp(a, 6));
        dock.setElevation(dp(a, 6));

        LinearLayout clockCell = new LinearLayout(a);
        clockCell.setOrientation(LinearLayout.VERTICAL);
        clockCell.setGravity(Gravity.CENTER);
        clockCell.setPadding(dp(a, 12), 0, dp(a, 20), 0);
        clock = text(a, "", 28, TEXT);
        clock.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
        clock.setIncludeFontPadding(false);
        date = text(a, "", 16, SUB);
        clockCell.addView(clock);
        clockCell.addView(date);
        dock.addView(clockCell, new LinearLayout.LayoutParams(-2, -1));

        String[][] items = {
                {"rd_ic_home", tr(0), "home"},
                {"rd_ic_car", tr(1), DASH + "/.pages.VehicleActivity"},
                {"rd_ic_snow", tr(2), DASH + "/.pages.ClimateActivity"},
                {"rd_ic_bolt", tr(3), DASH + "/.pages.EnergyActivity"},
                {"rd_ic_navigation", "Android Auto", "com.allgo.app.androidauto/.ProjectionActivity"},
                {"rd_ic_settings", tr(5), "com.saicmotor.settings/.ui.MainActivity"},
        };
        for (final String[] it : items) {
            LinearLayout cell = new LinearLayout(a);
            cell.setOrientation(LinearLayout.HORIZONTAL);
            cell.setGravity(Gravity.CENTER);
            cell.setClickable(true);
            cell.setFocusable(true);
            cell.setBackground(panel(a, Color.TRANSPARENT, 16));
            ImageView icon = new ImageView(a);
            int res = a.getResources().getIdentifier(it[0], "drawable", a.getPackageName());
            if (res != 0) icon.setImageResource(res);
            boolean accent = it[1].equals("Android Auto");
            icon.setColorFilter(Palette.map(accent ? ACTION : SUB));
            cell.addView(icon, new LinearLayout.LayoutParams(dp(a, 30), dp(a, 30)));
            TextView label = text(a, it[1], 19, accent ? TEXT : SUB);
            label.setPadding(dp(a, 12), 0, 0, 0);
            cell.addView(label);
            cell.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { open(a, it[2]); }
            });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, -1, 1f);
            lp.leftMargin = dp(a, 6);
            dock.addView(cell, lp);
        }
        FrameLayout.LayoutParams dlp = new FrameLayout.LayoutParams(-1, dp(a, 84), Gravity.BOTTOM);
        dlp.setMargins(dp(a, 16), 0, dp(a, 16), dp(a, 12));
        content.addView(dock, dlp);
    }

    /**
     * Barre verticale à gauche, comme dans MG4Dash quand l'option est choisie : icônes seules, la place
     * du bouton antibrouillards en haut. Réglages : toucher = réglages de la voiture, appui long =
     * réglages MG4Dash, double toucher = Wi-Fi.
     */
    private static void installVerticalDock(final Activity a, ViewGroup content) {
        LinearLayout bar = new LinearLayout(a);
        bar.setTag("rd_dock");
        bar.setOrientation(LinearLayout.VERTICAL);
        bar.setBackground(panel(a, PANEL, 20));
        bar.setPadding(dp(a, 4), dp(a, 4), dp(a, 4), dp(a, 6));
        bar.setElevation(dp(a, 6));
        bar.addView(new View(a), new LinearLayout.LayoutParams(-1, dp(a, 62)));
        clock = null; date = null;
        String[][] items = {
                {"rd_ic_settings", "com.saicmotor.settings/.ui.MainActivity"},
                {"rd_ic_navigation", "com.allgo.app.androidauto/.ProjectionActivity"},
                {"rd_ic_phone", DASH + "/.pages.PhoneActivity"},
                {"rd_ic_bolt", DASH + "/.pages.EnergyActivity"},
                {"rd_ic_car", DASH + "/.pages.VehicleActivity"},
                {"rd_ic_home", "home"},
        };
        for (final String[] it : items) {
            FrameLayout cell = new FrameLayout(a);
            cell.setClickable(true);
            cell.setFocusable(true);
            cell.setBackground(panel(a, Color.TRANSPARENT, 16));
            ImageView icon = new ImageView(a);
            int res = a.getResources().getIdentifier(it[0], "drawable", a.getPackageName());
            if (res != 0) icon.setImageResource(res);
            icon.setColorFilter(Palette.map(SUB));
            cell.addView(icon, new FrameLayout.LayoutParams(dp(a, 34), dp(a, 34), Gravity.CENTER));
            if (it[0].equals("rd_ic_settings")) {
                final android.view.GestureDetector gd = new android.view.GestureDetector(a, new android.view.GestureDetector.SimpleOnGestureListener() {
                    @Override public boolean onSingleTapConfirmed(android.view.MotionEvent e) { open(a, it[1]); return true; }
                    @Override public boolean onDoubleTap(android.view.MotionEvent e) { openAction(a, android.provider.Settings.ACTION_WIFI_SETTINGS); return true; }
                    @Override public void onLongPress(android.view.MotionEvent e) { open(a, DASH + "/.settings.SettingsActivity"); }
                    @Override public boolean onDown(android.view.MotionEvent e) { return true; }
                });
                cell.setOnTouchListener(new View.OnTouchListener() {
                    @Override public boolean onTouch(View v, android.view.MotionEvent ev) { return gd.onTouchEvent(ev); }
                });
            } else {
                cell.setOnClickListener(new View.OnClickListener() {
                    @Override public void onClick(View v) { open(a, it[1]); }
                });
            }
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, 0, 1f);
            lp.topMargin = dp(a, 4);
            bar.addView(cell, lp);
        }
        FrameLayout.LayoutParams blp = new FrameLayout.LayoutParams(dp(a, 64), -1, Gravity.START);
        blp.setMargins(dp(a, 16), dp(a, 12), 0, dp(a, 12));
        content.addView(bar, blp);
    }

    private static void openAction(Activity a, String action) {
        try {
            a.startActivity(new Intent(action).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
        } catch (Throwable t) {
            open(a, "com.saicmotor.settings/.ui.MainActivity");
        }
    }

    private static void open(Activity a, String target) {
        try {
            Intent i;
            if (target.equals("home")) {
                i = new Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME);
            } else {
                i = new Intent(Intent.ACTION_MAIN).setComponent(ComponentName.unflattenFromString(target));
            }
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            a.startActivity(i);
        } catch (Throwable t) {
            Log.w(TAG, "ouverture " + target + " : " + t);
        }
    }

    /**
     * Sur écran 1920, DabFragment décale la rangée de commandes (marge gauche de 144 px,
     * gravité « début ») : on la remet en pleine largeur pour la nouvelle mise en page.
     */
    private static void fixLayout(Activity a) {
        // Onglets : le code d'origine peint la barre avec des images ; on garde des puces MG4Dash.
        View bar = byName(a, "rl_menu_bar");
        if (bar != null && bar.getBackground() != null) bar.setBackground(null);
        int band = -1;
        try { band = ((Number) call(storage(a), "getStoredRadioBand")).intValue(); } catch (Throwable ignored) {}
        String[][] tabs = {{"layout_tab_dab", "4"}, {"layout_tab_fm", "1"}, {"layout_tab_am", "0"}};
        for (String[] t : tabs) {
            View tab = byName(a, t[0]);
            if (tab == null) continue;
            boolean sel = String.valueOf(band).equals(t[1]);
            int res = a.getResources().getIdentifier(sel ? "rd_bg_tab_sel" : "rd_bg_tab", "drawable", a.getPackageName());
            if (res != 0 && !Integer.valueOf(res).equals(tab.getTag())) {
                tab.setBackgroundResource(res);
                tab.setTag(res);
            }
        }
        int id = a.getResources().getIdentifier("ll_dab_base_function", "id", a.getPackageName());
        View v = id == 0 ? null : a.findViewById(id);
        if (v != null && v.getLayoutParams() instanceof LinearLayout.LayoutParams) {
            LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) v.getLayoutParams();
            if (lp.leftMargin != 0 || lp.topMargin != 0 || lp.width != ViewGroup.LayoutParams.MATCH_PARENT) {
                lp.setMargins(0, 0, 0, 0);
                lp.gravity = Gravity.NO_GRAVITY;
                lp.width = ViewGroup.LayoutParams.MATCH_PARENT;
                v.setLayoutParams(lp);
            }
        }
    }

    // ── Pochette : session média de la radio ────────────────────────────────

    private static void connectSession(final Activity a) {
        if (browser != null) return;
        browser = new MediaBrowser(a.getApplicationContext(),
                new ComponentName(a.getPackageName(), "com.saicmotor.radio.service.RadioMBService"),
                new MediaBrowser.ConnectionCallback() {
                    @Override public void onConnected() {
                        controller = new MediaController(a.getApplicationContext(), browser.getSessionToken());
                        controller.registerCallback(new MediaController.Callback() {
                            @Override public void onMetadataChanged(MediaMetadata md) { updateArt(md); }
                        }, main);
                        updateArt(controller.getMetadata());
                    }
                    @Override public void onConnectionSuspended() { controller = null; }
                }, null);
        browser.connect();
    }

    private static void updateArt(MediaMetadata md) {
        if (md == null) return;
        Bitmap b = md.getBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART);
        if (b == null) b = md.getBitmap(MediaMetadata.METADATA_KEY_ART);
        if (b == null) b = md.getBitmap(MediaMetadata.METADATA_KEY_DISPLAY_ICON);
        if (b != null) art = b;
        if (current != null) applyArt(current);
    }

    private static void applyArt(Activity a) {
        List<View> views = new ArrayList<>();
        findTagged(a.getWindow().getDecorView(), "rd_art", views);
        Bitmap b = art;
        if (b == null) b = cachedDabArt(a, currentDabServiceId(a));
        for (View v : views) {
            if (!(v instanceof ImageView)) continue;
            ImageView iv = (ImageView) v;
            round(iv, dp(a, 20));
            // Cadre carré : largeur = hauteur disponible (les images de station sont carrées).
            View frame = (View) iv.getParent();
            int h = frame.getHeight();
            if (h > 0 && frame.getWidth() != h) {
                ViewGroup.LayoutParams lp = frame.getLayoutParams();
                lp.width = h;
                frame.setLayoutParams(lp);
            }
            if (b != null) {
                iv.setScaleType(ImageView.ScaleType.CENTER_CROP);
                iv.setImageBitmap(b);
            } else {
                int res = a.getResources().getIdentifier("rd_ic_radio", "drawable", a.getPackageName());
                iv.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
                if (res != 0) iv.setImageResource(res);
            }
        }
    }

    // ── Favoris en tuiles ────────────────────────────────────────────────────

    private static void renderFavorites(final Activity a) throws Exception {
        Object storage = storage(a);
        if (storage == null) return;
        renderRow(a, "rd_favs_dab", (List<?>) call(storage, "getDabFavorite"), true, storage);
        Method forBand = storage.getClass().getMethod("getFavoriteForBand", int.class);
        renderRow(a, "rd_favs_fm", (List<?>) forBand.invoke(storage, 1), false, storage);
    }

    private static void renderRow(final Activity a, String tag, List<?> favs, final boolean dab, Object storage) throws Exception {
        View root = a.getWindow().getDecorView().findViewWithTag(tag);
        if (!(root instanceof LinearLayout)) return;
        LinearLayout row = (LinearLayout) root;
        long curDab = dab ? currentDabServiceId(a) : -1;
        int curFm = dab ? -1 : currentFmChannel(storage);
        String key = signature(favs, dab) + "|" + curDab + "|" + curFm;
        if (key.equals(row.getContentDescription())) return;   // rien n'a changé
        row.setContentDescription(key);
        row.removeAllViews();
        if (favs == null || favs.isEmpty()) {
            TextView empty = text(a, tr(6), 17, TITLE);
            row.addView(empty);
            return;
        }
        int n = Math.min(favs.size(), 8);
        for (int i = 0; i < n; i++) {
            final Object st = favs.get(i);
            boolean selected;
            LinearLayout tile = new LinearLayout(a);
            tile.setOrientation(LinearLayout.VERTICAL);
            tile.setGravity(Gravity.CENTER);
            tile.setPadding(dp(a, 6), dp(a, 6), dp(a, 6), dp(a, 6));
            ImageView logo = new ImageView(a);
            logo.setScaleType(ImageView.ScaleType.CENTER_CROP);
            round(logo, dp(a, 12));
            String label;
            if (dab) {
                long id = ((Number) call(st, "getServiceId")).longValue();
                selected = id == curDab;
                Bitmap b = cachedDabArt(a, id);
                if (b != null) logo.setImageBitmap(b);
                else logo.setImageResource(a.getResources().getIdentifier("rd_ic_radio", "drawable", a.getPackageName()));
                Object name = callQuiet(st, "getServiceName");
                if (name == null) name = callQuiet(st, "getEnsembleName");
                label = name != null ? name.toString().trim() : "DAB";
            } else {
                // FM : nom RDS (s'il existe) + fréquence, sans icône.
                int ch = ((Number) call(st, "getChannelNumber")).intValue();
                selected = ch == curFm;
                String freq = String.format(Locale.getDefault(), "%.1f MHz", ch / 1000f);
                Object rds = callQuiet(st, "getRds");
                Object ps = rds == null ? null : callQuiet(rds, "getProgramService");
                String name = ps == null ? "" : ps.toString().trim();
                tile.setBackground(panel(a, selected ? 0x262979FF : BUTTON, 16, selected ? ACTION : BORDER));
                TextView big = text(a, name.isEmpty() ? freq : name, 21, selected ? TEXT : 0xFFE6EAF0);
                big.setSingleLine(true);
                big.setEllipsize(android.text.TextUtils.TruncateAt.END);
                big.setGravity(Gravity.CENTER);
                tile.addView(big, new LinearLayout.LayoutParams(-1, -2));
                if (!name.isEmpty()) {
                    TextView small = text(a, freq, 15, SUB);
                    small.setGravity(Gravity.CENTER);
                    small.setPadding(0, dp(a, 4), 0, 0);
                    tile.addView(small, new LinearLayout.LayoutParams(-1, -2));
                }
                tile.setOnClickListener(new View.OnClickListener() {
                    @Override public void onClick(View v) { tune(st, false); }
                });
                LinearLayout.LayoutParams flp = new LinearLayout.LayoutParams(0, -1, 1f);
                if (i > 0) flp.leftMargin = dp(a, 8);
                row.addView(tile, flp);
                continue;
            }
            tile.setBackground(panel(a, selected ? 0x262979FF : BUTTON, 16, selected ? ACTION : BORDER));
            int side = row.getHeight() > 0 ? Math.min(dp(a, 76), row.getHeight() - dp(a, 40)) : dp(a, 76);
            side = Math.max(side, dp(a, 36));
            tile.addView(logo, new LinearLayout.LayoutParams(side, side));
            TextView t = text(a, label, 15, selected ? TEXT : SUB);
            t.setSingleLine(true);
            t.setEllipsize(android.text.TextUtils.TruncateAt.END);
            t.setGravity(Gravity.CENTER);
            t.setPadding(0, dp(a, 4), 0, 0);
            tile.addView(t, new LinearLayout.LayoutParams(-1, -2));
            tile.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { tune(st, dab); }
            });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, -1, 1f);
            if (i > 0) lp.leftMargin = dp(a, 8);
            row.addView(tile, lp);
        }
        for (int i = n; i < 6; i++) row.addView(new View(a), new LinearLayout.LayoutParams(0, -1, 1f));
    }

    // ── Cadran FM (remplace la règle d'origine, masquée dans la mise en page) ──

    private static void updateFmDial(Activity a) throws Exception {
        View root = a.getWindow().getDecorView().findViewWithTag("rd_fm_dial");
        if (!(root instanceof ViewGroup)) return;
        ViewGroup box = (ViewGroup) root;
        FmDial dial;
        if (box.getChildCount() > 0 && box.getChildAt(0) instanceof FmDial) {
            dial = (FmDial) box.getChildAt(0);
        } else {
            dial = new FmDial(a);
            dial.setOnTune(new FmDial.OnTune() {
                @Override public void tune(int khz) { tuneFm(khz); }
            });
            box.addView(dial, new ViewGroup.LayoutParams(-1, -1));
        }
        Object storage = storage(a);
        if (storage == null) return;
        dial.setValue(currentFmChannel(storage));
        List<Integer> chans = new ArrayList<>();
        Method forBand = storage.getClass().getMethod("getFavoriteForBand", int.class);
        List<?> favs = (List<?>) forBand.invoke(storage, 1);
        if (favs != null) for (Object f : favs) {
            Object ch = callQuiet(f, "getChannelNumber");
            if (ch instanceof Number) chans.add(((Number) ch).intValue());
        }
        dial.setFavorites(chans);
    }

    private static void tuneFm(int khz) {
        try {
            Class<?> rs = Class.forName("com.android.car.radio.service.RadioStation");
            Class<?> rds = Class.forName("com.android.car.radio.service.RadioRds");
            Object station = rs.getConstructor(int.class, int.class, int.class, rds).newInstance(khz, 0, 1, null);
            tune(station, false);
        } catch (Throwable t) {
            Log.w(TAG, "accord FM " + khz + " : " + t);
        }
    }

    private static String signature(List<?> favs, boolean dab) {
        if (favs == null) return "-";
        StringBuilder sb = new StringBuilder();
        for (Object o : favs) {
            Object id = callQuiet(o, dab ? "getServiceId" : "getChannelNumber");
            sb.append(id).append(',');
        }
        return sb.toString();
    }

    private static void tune(Object station, boolean dab) {
        try {
            Object rm = radioManager;
            if (rm == null) { Log.w(TAG, "service radio non lié"); return; }
            for (Method m : rm.getClass().getMethods()) {
                if (m.getName().equals(dab ? "dabTune" : "tune") && m.getParameterTypes().length == 1) {
                    m.invoke(rm, station);
                    Log.i(TAG, "favori accordé (" + (dab ? "DAB" : "FM") + ")");
                    break;
                }
            }
            if (current != null) main.postDelayed(tick, 400);
        } catch (Throwable t) {
            Log.w(TAG, "accord favori : " + t);
        }
    }

    /** Liaison au service radio (IRadioManager) pour accorder une station depuis une tuile. */
    private static void bindRadioService(Activity a) {
        if (radioManager != null) return;
        Intent i = new Intent("com.saicmotor.IRadioService").setPackage(a.getPackageName());
        a.getApplicationContext().bindService(i, new ServiceConnection() {
            @Override public void onServiceConnected(ComponentName name, IBinder binder) {
                try {
                    Class<?> stub = Class.forName("com.android.car.radio.service.IRadioManager$Stub");
                    radioManager = stub.getMethod("asInterface", IBinder.class).invoke(null, binder);
                } catch (Throwable t) {
                    Log.w(TAG, "IRadioManager : " + t);
                }
            }
            @Override public void onServiceDisconnected(ComponentName name) { radioManager = null; }
        }, Context.BIND_AUTO_CREATE);
    }

    // ── Données radio ────────────────────────────────────────────────────────

    private static Object storage(Context c) {
        try {
            Class<?> cls = Class.forName("com.saicmotor.radio.model.RadioStorage");
            return cls.getMethod("getInstance", Context.class).invoke(null, c.getApplicationContext());
        } catch (Throwable t) {
            return null;
        }
    }

    private static long currentDabServiceId(Context c) {
        try {
            Object st = call(storage(c), "getCurrentDabStation");
            return st == null ? -1 : ((Number) call(st, "getServiceId")).longValue();
        } catch (Throwable t) {
            return -1;
        }
    }

    private static int currentFmChannel(Object storage) {
        Object ch = callQuiet(storage, "getStoredRadioChannel");
        if (ch instanceof Number) return ((Number) ch).intValue();
        try {
            Method m = storage.getClass().getMethod("getStoredRadioChannel", int.class);
            return ((Number) m.invoke(storage, 1)).intValue();
        } catch (Throwable t) {
            return -1;
        }
    }

    /** Image mise en cache par le patch DAB+ : fichiers/dab_<serviceId>.jpg. */
    private static Bitmap cachedDabArt(Context c, long serviceId) {
        if (serviceId < 0) return null;
        File f = new File(c.getFilesDir(), "dab_" + serviceId + ".jpg");
        return f.canRead() ? BitmapFactory.decodeFile(f.getPath()) : null;
    }

    // ── Outils ───────────────────────────────────────────────────────────────

    private static void findTagged(View v, String tag, List<View> out) {
        if (tag.equals(v.getTag())) out.add(v);
        if (v instanceof ViewGroup) {
            ViewGroup g = (ViewGroup) v;
            for (int i = 0; i < g.getChildCount(); i++) findTagged(g.getChildAt(i), tag, out);
        }
    }

    private static View byName(Activity a, String name) {
        int id = a.getResources().getIdentifier(name, "id", a.getPackageName());
        return id == 0 ? null : a.findViewById(id);
    }

    private static Object call(Object target, String name) throws Exception {
        return target.getClass().getMethod(name).invoke(target);
    }

    private static Object callQuiet(Object target, String name) {
        try { return call(target, name); } catch (Throwable t) { return null; }
    }

    private static void round(View v, final int radius) {
        v.setOutlineProvider(new ViewOutlineProvider() {
            @Override public void getOutline(View view, Outline outline) {
                outline.setRoundRect(0, 0, view.getWidth(), view.getHeight(), radius);
            }
        });
        v.setClipToOutline(true);
    }

    private static GradientDrawable panel(Context c, int fill, int radiusDp) {
        return panel(c, fill, radiusDp, fill == Color.TRANSPARENT ? Color.TRANSPARENT : BORDER);
    }

    private static GradientDrawable panel(Context c, int fill, int radiusDp, int stroke) {
        GradientDrawable g = new GradientDrawable();
        g.setColor(fill);
        g.setCornerRadius(dp(c, radiusDp));
        if (stroke != Color.TRANSPARENT) g.setStroke(1, stroke);
        return g;
    }

    private static TextView text(Context c, String s, int sp, int color) {
        TextView t = new TextView(c);
        t.setText(s);
        t.setTextColor(color);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, sp);
        return t;
    }

    private static int dp(Context c, int v) {
        return Math.round(v * c.getResources().getDisplayMetrics().density);
    }
}
