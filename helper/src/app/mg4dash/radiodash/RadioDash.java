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
 * - barre de favoris à droite : conteneur android:tag="rd_favs_grid" (3 colonnes, images des stations).
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
            {"Add favourites with ★: the steering wheel and home screen will skip between them",
                    "Ajoutez des favoris avec ★ : le volant et l'accueil passeront de l'un à l'autre",
                    "Favoriten mit ★ hinzufügen: Lenkrad und Startbildschirm wechseln dann zwischen ihnen",
                    "Añada favoritos con ★: el volante y la pantalla de inicio pasarán de uno a otro",
                    "Aggiungi preferiti con ★: volante e schermata home passeranno dall'uno all'altro",
                    "Voeg favorieten toe met ★: stuur en startscherm schakelen dan tussen deze zenders"},
            {"Favourites", "Favoris", "Favoriten", "Favoritos", "Preferiti", "Favorieten"},
            {"DAB+ stations: tap to add or remove a favourite", "Stations DAB+ : touchez pour ajouter ou retirer un favori",
                    "DAB+-Sender: tippen zum Hinzufügen oder Entfernen", "Emisoras DAB+: toque para añadir o quitar un favorito",
                    "Stazioni DAB+: tocca per aggiungere o togliere un preferito", "DAB+-zenders: tik om een favoriet toe te voegen of te verwijderen"},
            {"Refresh", "Actualiser", "Aktualisieren", "Actualizar", "Aggiorna", "Vernieuwen"},
            {"Close", "Fermer", "Schließen", "Cerrar", "Chiudi", "Sluiten"},
            {"Searching for stations…", "Recherche des stations…", "Sendersuche…", "Buscando emisoras…", "Ricerca stazioni…", "Zenders zoeken…"},
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

    /** Rafraîchissement : horloge, pochettes, barre de favoris (toutes les 2 s). */
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
                Palette.tintStars(a.getWindow().getDecorView());
                immersive(a);
            } catch (Throwable t) {
                Log.w(TAG, "rafraîchissement : " + t);
            }
            main.removeCallbacks(this);   // une seule boucle, même si tune() ou la mise en page l'a relancée
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
            final boolean isSettings = it[0].equals("rd_ic_settings");
            cell.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { open(a, isSettings ? DASH + "/.settings.SettingsActivity" : it[2]); }
            });
            if (isSettings) cell.setOnLongClickListener(new View.OnLongClickListener() {
                @Override public boolean onLongClick(View v) { open(a, it[2]); return true; }
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
     * du bouton antibrouillards en haut. Réglages : toucher = réglages MG4Dash, appui long =
     * réglages de la voiture, double toucher = Wi-Fi.
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
                {"rd_ic_projection", "com.allgo.app.androidauto/.ProjectionActivity"},
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
                    @Override public boolean onSingleTapConfirmed(android.view.MotionEvent e) { open(a, DASH + "/.settings.SettingsActivity"); return true; }
                    @Override public boolean onDoubleTap(android.view.MotionEvent e) { openAction(a, android.provider.Settings.ACTION_WIFI_SETTINGS); return true; }
                    @Override public void onLongPress(android.view.MotionEvent e) { open(a, it[1]); }
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
    /**
     * DAB+ immersif : le panneau du lecteur devient carré (largeur = hauteur) et la carte des favoris
     * prend la place libérée, avec plus de colonnes. FM, ou présentation classique : carte de 640 dp.
     */
    private static void squarePlayer(Activity a, int band) {
        View cont = byName(a, "fragment_container");
        View card = byName(a, "fragment_container_card");
        if (cont == null || card == null || !(card.getParent() instanceof View)) return;
        int parentW = ((View) card.getParent()).getWidth();
        int h = cont.getHeight();
        int want = dp(a, 640);
        if (band == 4 && Palette.immersiveDab() && parentW > 0 && h > 0) {
            // Panneau = hauteur du conteneur moins sa marge du haut (12 dp) ; à sa largeur s'ajoutent la
            // marge de gauche (16), la marge de droite du panneau (12) et celle de la carte (16)
            int side = h - dp(a, 12);
            want = Math.max(dp(a, 640), parentW - side - dp(a, 44));
        }
        ViewGroup.LayoutParams lp = card.getLayoutParams();
        if (lp.width != want) { lp.width = want; card.setLayoutParams(lp); }
    }

    private static void fixLayout(Activity a) {
        // Onglets : puces MG4Dash (rd_bg_chip, selon l'état « sélectionné »). Le chargeur de thèmes
        // d'origine remet le fond de la mise en page au démarrage : un fond posé ici était perdu.
        int band = -1;
        try { band = ((Number) call(storage(a), "getStoredRadioBand")).intValue(); } catch (Throwable ignored) {}
        String[][] tabs = {{"layout_tab_dab", "4"}, {"layout_tab_fm", "1"}, {"layout_tab_am", "0"}};
        for (String[] t : tabs) {
            View tab = byName(a, t[0]);
            boolean sel = String.valueOf(band).equals(t[1]);
            if (tab != null && tab.isSelected() != sel) tab.setSelected(sel);
        }
        // La barre de favoris RadioDash remplace la liste d'origine : on garde ses vues cachées.
        String[] hidden = {"layout_icon", "btn_dab_favorite_list", "btn_favorite_list"};
        for (String n : hidden) {
            View h = byName(a, n);
            if (h != null && h.getVisibility() != View.GONE) h.setVisibility(View.GONE);
        }
        squarePlayer(a, band);
        favManagerButton(a);
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

    /** Lecteur Immersif (réglage de MG4Dash) : l'image de la station derrière tout le panneau. */
    private static void immersive(Activity a) {
        List<View> views = new ArrayList<>();
        findTagged(a.getWindow().getDecorView(), "rd_art", views);
        Bitmap b = art;
        if (b == null) b = cachedDabArt(a, currentDabServiceId(a));
        for (View v : views) {
            Immersive.apply(a, v, b);
        }
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

    // ── Gestion des favoris DAB+ : toutes les stations, une étoile par ligne ─

    /** Bouton « ★ Favoris » dans la ligne du haut du panneau DAB+ (à côté du réglage et de la liste). */
    private static void favManagerButton(final Activity a) {
        View rds = byName(a, "btn_dab_rds_setting");
        if (rds == null || !(rds.getParent() instanceof LinearLayout)) return;
        LinearLayout head = (LinearLayout) rds.getParent();
        // Bouton EPG caché par la radio sans programme : il gardait sa place et poussait la ligne
        View epg = byName(a, "btn_dab_program");
        if (epg != null && epg.getVisibility() == View.INVISIBLE) epg.setVisibility(View.GONE);
        if (head.findViewWithTag("rd_favmgr") != null) return;
        TextView b = text(a, "★  " + tr(7), 17, TEXT);
        b.setTag("rd_favmgr");
        b.setGravity(Gravity.CENTER);
        b.setPadding(dp(a, 18), 0, dp(a, 18), 0);
        b.setBackground(panel(a, BUTTON, 14, BORDER));
        b.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { showFavManager(a); }
        });
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, dp(a, 56));
        lp.setMarginStart(dp(a, 10));
        head.addView(b, head.indexOfChild(rds), lp);
    }

    /**
     * Fenêtre des stations DAB+ : la liste reçue par le tuner (actualisable) et les favoris déjà choisis,
     * même s'ils ne sont pas reçus en ce moment. Toucher une ligne ajoute ou retire le favori, aussitôt
     * enregistré par la radio (même base que l'étoile du lecteur).
     */
    private static void showFavManager(final Activity a) {
        final android.app.Dialog d = new android.app.Dialog(a, android.R.style.Theme_Black_NoTitleBar_Fullscreen);
        LinearLayout root = new LinearLayout(a);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xF20B0F17);
        root.setPadding(dp(a, 40), dp(a, 24), dp(a, 40), dp(a, 16));
        LinearLayout top = new LinearLayout(a);
        top.setGravity(Gravity.CENTER_VERTICAL);
        top.setPadding(dp(a, 70), 0, 0, 0);   // place du bouton antibrouillards de MG en haut à gauche
        top.addView(text(a, tr(8), 26, TEXT), new LinearLayout.LayoutParams(0, -2, 1f));
        final TextView status = text(a, "", 18, SUB);
        top.addView(status, new LinearLayout.LayoutParams(-2, -2));
        TextView refresh = text(a, tr(9), 20, TEXT);
        TextView close = text(a, tr(10), 20, COLD);
        for (TextView t : new TextView[]{refresh, close}) {
            t.setGravity(Gravity.CENTER);
            t.setPadding(dp(a, 26), 0, dp(a, 26), 0);
            t.setBackground(panel(a, BUTTON, 14, BORDER));
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, dp(a, 64));
            lp.setMarginStart(dp(a, 14));
            top.addView(t, lp);
        }
        root.addView(top, new LinearLayout.LayoutParams(-1, -2));
        android.widget.ScrollView scroll = new android.widget.ScrollView(a);
        final LinearLayout list = new LinearLayout(a);
        list.setOrientation(LinearLayout.VERTICAL);
        scroll.addView(list, new FrameLayout.LayoutParams(-1, -2));
        LinearLayout.LayoutParams slp = new LinearLayout.LayoutParams(-1, 0, 1f);
        slp.topMargin = dp(a, 16);
        root.addView(scroll, slp);
        final Runnable fill = new Runnable() {
            @Override public void run() { fillFavManager(a, list); }
        };
        refresh.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                // Demande au tuner sa liste de stations à jour, puis relit la base après quelques secondes
                status.setText(tr(11));
                try {
                    Object rm = radioManager;
                    if (rm != null) rm.getClass().getMethod("queryDabStationList").invoke(rm);
                } catch (Throwable t) { Log.w(TAG, "liste DAB : " + t); }
                main.postDelayed(new Runnable() {
                    @Override public void run() { status.setText(""); fill.run(); }
                }, 4000);
            }
        });
        close.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { d.dismiss(); }
        });
        d.setOnDismissListener(new android.content.DialogInterface.OnDismissListener() {
            @Override public void onDismiss(android.content.DialogInterface di) { main.post(tick); }
        });
        d.setContentView(root);
        fill.run();
        d.show();
        // Plein écran comme la radio : sans la barre SAIC à gauche
        if (d.getWindow() != null) d.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
    }

    private static void fillFavManager(final Activity a, final LinearLayout list) {
        list.removeAllViews();
        final Object storage = storage(a);
        if (storage == null) return;
        List<Object> all = new ArrayList<>();
        java.util.Set<Long> favIds = new java.util.HashSet<>();
        java.util.Set<Long> seen = new java.util.HashSet<>();
        try {
            List<?> favs = (List<?>) call(storage, "getDabFavorite");
            if (favs != null) for (Object f : favs) favIds.add(((Number) call(f, "getServiceId")).longValue());
            List<?> stations = (List<?>) call(storage, "getDabStationList");
            if (stations != null) for (Object st : stations) {
                if (seen.add(((Number) call(st, "getServiceId")).longValue())) all.add(st);
            }
            // Favoris d'avant, même hors de portée : on les garde dans la liste, cochés
            if (favs != null) for (Object f : favs) {
                if (seen.add(((Number) call(f, "getServiceId")).longValue())) all.add(f);
            }
        } catch (Throwable t) { Log.w(TAG, "stations DAB : " + t); return; }
        java.util.Collections.sort(all, new java.util.Comparator<Object>() {
            @Override public int compare(Object x, Object y) { return label(x).compareToIgnoreCase(label(y)); }
        });
        // Deux colonnes de lignes larges, faciles à toucher
        LinearLayout row = null;
        for (int i = 0; i < all.size(); i++) {
            final Object st = all.get(i);
            if (i % 2 == 0) {
                row = new LinearLayout(a);
                list.addView(row, new LinearLayout.LayoutParams(-1, -2));
            }
            long id;
            try { id = ((Number) call(st, "getServiceId")).longValue(); } catch (Throwable t) { continue; }
            final boolean[] on = {favIds.contains(id)};
            final LinearLayout line = new LinearLayout(a);
            line.setGravity(Gravity.CENTER_VERTICAL);
            line.setPadding(dp(a, 12), dp(a, 10), dp(a, 18), dp(a, 10));
            ImageView logo = new ImageView(a);
            logo.setScaleType(ImageView.ScaleType.CENTER_CROP);
            round(logo, dp(a, 10));
            Bitmap b = cachedDabArt(a, id);
            if (b != null) logo.setImageBitmap(b);
            else {
                logo.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
                logo.setImageResource(a.getResources().getIdentifier("rd_ic_radio", "drawable", a.getPackageName()));
            }
            line.addView(logo, new LinearLayout.LayoutParams(dp(a, 72), dp(a, 72)));
            LinearLayout col = new LinearLayout(a);
            col.setOrientation(LinearLayout.VERTICAL);
            TextView name = text(a, label(st), 24, TEXT);
            name.setSingleLine(true);
            name.setEllipsize(android.text.TextUtils.TruncateAt.END);
            col.addView(name);
            Object ens = callQuiet(st, "getEnsembleName");
            if (ens != null && !ens.toString().trim().isEmpty()) col.addView(text(a, ens.toString().trim(), 17, SUB));
            LinearLayout.LayoutParams clp = new LinearLayout.LayoutParams(0, -2, 1f);
            clp.setMarginStart(dp(a, 16));
            line.addView(col, clp);
            final TextView star = text(a, "★", 40, ACTION);
            line.addView(star, new LinearLayout.LayoutParams(-2, -2));
            final Runnable paint = new Runnable() {
                @Override public void run() {
                    star.setTextColor(on[0] ? Palette.starColor() : 0xFF3A4254);
                    line.setBackground(panel(a, on[0] ? 0x262979FF : BUTTON, 16, on[0] ? Palette.starColor() : BORDER));
                }
            };
            paint.run();
            line.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {
                    try {
                        Method m = null;
                        for (Method x : storage.getClass().getMethods())
                            if (x.getName().equals(on[0] ? "removeDabFavorite" : "storeDabFavorite") && x.getParameterTypes().length == 1) m = x;
                        if (m == null) return;
                        m.invoke(storage, st);
                        on[0] = !on[0];
                        paint.run();
                    } catch (Throwable t) { Log.w(TAG, "favori DAB : " + t); }
                }
            });
            LinearLayout.LayoutParams llp = new LinearLayout.LayoutParams(0, -2, 1f);
            llp.setMargins(dp(a, 6), dp(a, 6), dp(a, 6), dp(a, 6));
            row.addView(line, llp);
        }
        if (all.size() % 2 == 1 && row != null) row.addView(new View(a), new LinearLayout.LayoutParams(0, 1, 1f));
    }

    private static String label(Object st) {
        Object n = callQuiet(st, "getServiceName");
        if (n == null || n.toString().trim().isEmpty()) n = callQuiet(st, "getEnsembleName");
        return n == null ? "DAB" : n.toString().trim();
    }

    // ── Favoris : barre unique à droite, 3 colonnes ──────────────────────────

    /** Colonnes de favoris : 3 sur la carte de 640 dp, davantage quand elle s'élargit (DAB+ immersif). */
    private static int COLUMNS = 3;

    /**
     * Barre de favoris unique (conteneur android:tag="rd_favs_grid" de la carte de droite) :
     * les stations en favori de la bande en cours, avec leur image (DAB) ou leur fréquence (FM/AM).
     */
    private static void renderFavorites(final Activity a) throws Exception {
        View root = a.getWindow().getDecorView().findViewWithTag("rd_favs_grid");
        if (!(root instanceof LinearLayout)) return;
        LinearLayout grid = (LinearLayout) root;
        if (grid.getWidth() <= 0) { main.postDelayed(tick, 250); return; }   // pas encore mis en page
        Object storage = storage(a);
        if (storage == null) return;
        int band = 1;
        try { band = ((Number) call(storage, "getStoredRadioBand")).intValue(); } catch (Throwable ignored) {}
        boolean dab = band == 4;
        List<?> favs;
        if (dab) {
            favs = (List<?>) call(storage, "getDabFavorite");
        } else {
            favs = (List<?>) storage.getClass().getMethod("getFavoriteForBand", int.class).invoke(storage, band == 0 ? 0 : 1);
        }
        long curDab = dab ? currentDabServiceId(a) : -1;
        int curFm = dab ? -1 : currentFmChannel(storage);
        String key = band + "|" + signature(favs, dab) + "|" + curDab + "|" + curFm + "|" + grid.getWidth()
                + (dab ? "|" + artStamp(a, favs) : "|" + rdsStamp(favs));
        if (key.equals(grid.getContentDescription())) return;   // rien n'a changé
        grid.setContentDescription(key);
        grid.removeAllViews();
        if (favs == null || favs.isEmpty()) {
            TextView empty = text(a, tr(6), 17, TITLE);
            empty.setPadding(dp(a, 10), dp(a, 6), dp(a, 10), 0);
            grid.addView(empty);
            finishFavorites(a, grid);
            return;
        }
        int gap = dp(a, 5);
        COLUMNS = Math.max(3, Math.round(grid.getWidth() / (float) dp(a, 215)));
        int tileW = (grid.getWidth() - 2 * gap * COLUMNS) / COLUMNS;
        int logoSide = tileW - dp(a, 28);
        LinearLayout row = null;
        for (int i = 0; i < favs.size(); i++) {
            if (i % COLUMNS == 0) {
                row = new LinearLayout(a);
                row.setOrientation(LinearLayout.HORIZONTAL);
                grid.addView(row, new LinearLayout.LayoutParams(-1, -2));
            }
            final Object st = favs.get(i);
            boolean selected;
            String label;
            View face;
            if (dab) {
                long id = ((Number) call(st, "getServiceId")).longValue();
                selected = id == curDab;
                ImageView logo = new ImageView(a);
                logo.setScaleType(ImageView.ScaleType.CENTER_CROP);
                round(logo, dp(a, 12));
                Bitmap b = cachedDabArt(a, id);
                if (b != null) logo.setImageBitmap(b);
                else {
                    logo.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
                    logo.setPadding(dp(a, 24), dp(a, 24), dp(a, 24), dp(a, 24));
                    logo.setBackground(panel(a, BORDER, 12, Color.TRANSPARENT));
                    logo.setImageResource(a.getResources().getIdentifier("rd_ic_radio", "drawable", a.getPackageName()));
                }
                Object name = callQuiet(st, "getServiceName");
                if (name == null) name = callQuiet(st, "getEnsembleName");
                label = name != null ? name.toString().trim() : "DAB";
                face = logo;
            } else {
                int ch = ((Number) call(st, "getChannelNumber")).intValue();
                selected = ch == curFm;
                Object rds = callQuiet(st, "getRds");
                Object ps = rds == null ? null : callQuiet(rds, "getProgramService");
                label = ps == null ? "" : ps.toString().trim();
                // Pas d'image pour une station FM : carte sombre comme les logos DAB, nom RDS en grand
                // à la couleur du thème au-dessus de la fréquence (la fréquence seule si aucun nom n'est reçu).
                String f = ch < 1000 ? ch + " kHz" : String.format(Locale.getDefault(), "%.1f MHz", ch / 1000f);
                LinearLayout card = new LinearLayout(a);
                card.setOrientation(LinearLayout.VERTICAL);
                card.setGravity(Gravity.CENTER);
                card.setPadding(dp(a, 10), dp(a, 10), dp(a, 10), dp(a, 12));
                card.setBackground(panel(a, 0xFF0B0F17, 12, BORDER));
                TextView big = text(a, label.isEmpty() ? f : label, 28, selected ? COLD : ACTION);
                big.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
                big.setGravity(Gravity.CENTER);
                big.setMaxLines(2);
                big.setEllipsize(android.text.TextUtils.TruncateAt.END);
                big.setAutoSizeTextTypeUniformWithConfiguration(15, 30, 1, TypedValue.COMPLEX_UNIT_SP);
                card.addView(big, new LinearLayout.LayoutParams(-1, 0, 1f));
                if (!label.isEmpty()) {
                    TextView small = text(a, f, 17, SUB);
                    small.setGravity(Gravity.CENTER);
                    small.setPadding(0, dp(a, 6), 0, 0);
                    card.addView(small, new LinearLayout.LayoutParams(-1, -2));
                }
                face = card;
                label = null;   // tout est sur la carte : pas de légende dessous
            }
            LinearLayout tile = new LinearLayout(a);
            tile.setOrientation(LinearLayout.VERTICAL);
            tile.setGravity(Gravity.CENTER_HORIZONTAL);
            tile.setPadding(dp(a, 8), dp(a, 8), dp(a, 8), dp(a, 6));
            tile.setBackground(panel(a, selected ? 0x262979FF : BUTTON, 16, selected ? ACTION : BORDER));
            tile.addView(face, new LinearLayout.LayoutParams(logoSide, logoSide));
            if (label != null) {
                TextView t = text(a, label, 16, selected ? TEXT : SUB);
                t.setSingleLine(true);
                t.setEllipsize(android.text.TextUtils.TruncateAt.END);
                t.setGravity(Gravity.CENTER);
                t.setPadding(0, dp(a, 6), 0, 0);
                tile.addView(t, new LinearLayout.LayoutParams(-1, -2));
            }
            tile.setClickable(true);
            final boolean isDab = dab;
            tile.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { tune(st, isDab); }
            });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(tileW, -2);
            lp.setMargins(gap, gap, gap, gap);
            row.addView(tile, lp);
        }
        // Dernière rangée complétée par des cases vides pour garder la largeur des colonnes
        for (int k = favs.size(); k % COLUMNS != 0; k++) {
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(tileW, 1);
            lp.setMargins(gap, gap, gap, gap);
            row.addView(new View(a), lp);
        }
        finishFavorites(a, grid);
    }

    /** Les vues neuves reçoivent tout de suite les couleurs du thème : pas d'éclair sombre en mode clair. */
    private static void finishFavorites(Activity a, View grid) {
        Palette.recolor(grid);
        Palette.tintStars(a.getWindow().getDecorView());
    }

    /** Empreinte des images DAB en cache : redessine les tuiles quand une image arrive. */
    private static String artStamp(Context c, List<?> favs) {
        long sum = 0;
        if (favs != null) for (Object o : favs) {
            Object id = callQuiet(o, "getServiceId");
            if (id instanceof Number) sum += new File(c.getFilesDir(), "dab_" + ((Number) id).longValue() + ".jpg").lastModified();
        }
        return String.valueOf(sum);
    }

    /** Empreinte des noms RDS : redessine les tuiles FM quand un nom est reçu. */
    private static String rdsStamp(List<?> favs) {
        StringBuilder sb = new StringBuilder();
        if (favs != null) for (Object o : favs) {
            Object rds = callQuiet(o, "getRds");
            Object ps = rds == null ? null : callQuiet(rds, "getProgramService");
            sb.append(ps).append(',');
        }
        return sb.toString();
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
