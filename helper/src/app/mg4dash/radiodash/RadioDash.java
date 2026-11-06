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
import android.graphics.Paint;
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
            {"No favourites yet: choose All stations above, then tap a star",
                    "Pas encore de favori : choisissez Toutes les stations ci-dessus, puis touchez une étoile",
                    "Noch keine Favoriten: oben Alle Sender wählen, dann einen Stern antippen",
                    "Aún no hay favoritos: elija Todas las emisoras arriba y toque una estrella",
                    "Nessun preferito: scegli Tutte le stazioni qui sopra, poi tocca una stella",
                    "Nog geen favorieten: kies hierboven Alle zenders en tik op een ster"},
            {"Favourites", "Favoris", "Favoriten", "Favoritos", "Preferiti", "Favorieten"},
            {"All stations", "Toutes les stations", "Alle Sender", "Todas las emisoras", "Tutte le stazioni", "Alle zenders"},
            {"Scan", "Scan", "Suchlauf", "Buscar", "Scansione", "Scannen"},
            {"Stop", "Arrêter", "Stopp", "Detener", "Ferma", "Stoppen"},
            {"Searching for stations…", "Recherche des stations…", "Sendersuche…", "Buscando emisoras…", "Ricerca stazioni…", "Zenders zoeken…"},
            {"%d found", "%d trouvées", "%d gefunden", "%d encontradas", "%d trovate", "%d gevonden"},
            {"Listen", "Écoute", "Hören", "Escucha", "Ascolto", "Luisteren"},
            {"No stations known yet: press Scan to search for them",
                    "Aucune station connue pour l'instant : touchez Scan pour les chercher",
                    "Noch keine Sender bekannt: Suchlauf antippen, um danach zu suchen",
                    "Aún no hay emisoras conocidas: toque Buscar para encontrarlas",
                    "Nessuna stazione ancora nota: tocca Scansione per cercarle",
                    "Nog geen zenders bekend: tik op Scannen om ze te zoeken"},
            {"No stations known yet: choose All stations above, then press Scan",
                    "Aucune station connue pour l'instant : choisissez Toutes les stations ci-dessus, puis touchez Scan",
                    "Noch keine Sender bekannt: oben Alle Sender wählen, dann Suchlauf antippen",
                    "Aún no hay emisoras conocidas: elija Todas las emisoras arriba y toque Buscar",
                    "Nessuna stazione ancora nota: scegli Tutte le stazioni qui sopra, poi tocca Scansione",
                    "Nog geen zenders bekend: kies hierboven Alle zenders en tik op Scannen"},
            {"Scan done: %d stations", "Scan terminé : %d stations", "Suchlauf beendet: %d Sender",
                    "Búsqueda terminada: %d emisoras", "Scansione finita: %d stazioni", "Scan klaar: %d zenders"},
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
            createdAt = android.os.SystemClock.uptimeMillis();
            Palette.load(a);
            watchTheme(a);
            fullscreen(a);
            installDock(a);
            watchSquare(a);
            watchSwipe(a);
            connectSession(a);
            bindRadioService(a);
        } catch (Throwable t) {
            Log.w(TAG, "onCreate : " + t);
        }
    }

    /**
     * Thème publié par MG4Dash (Settings.Global « mg4dash_theme ») : l'écran est recréé dès le changement, et non au
     * rafraîchissement suivant (jusqu'à 2 s plus tard, pendant lesquelles le fond avait déjà changé).
     */
    private static void watchTheme(Context c) {
        if (themeWatched) return;
        themeWatched = true;
        try {
            c.getApplicationContext().getContentResolver().registerContentObserver(
                    android.provider.Settings.Global.getUriFor("mg4dash_theme"), false, new android.database.ContentObserver(main) {
                        @Override public void onChange(boolean selfChange) {
                            Activity a = current;
                            if (a != null && !a.isFinishing() && Palette.load(a)) a.recreate();
                        }
                    });
        } catch (Throwable t) {
            Log.w(TAG, "suivi du thème : " + t);
        }
    }
    private static boolean themeWatched;

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
        if (scan != null) scan.stop(true, "radio en arrière-plan");
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
                rdsFavoriteName(a);
                renderFavorites(a);
                scanUi(a);
                dabInfo(a);
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
    /**
     * Le lecteur carré est posé avant la première image (à l'ouverture et après un changement de thème),
     * sinon la carte des favoris s'affichait un instant sur 3 colonnes avant de passer à 5.
     */
    private static void watchSquare(final Activity a) {
        final View root = a.getWindow().getDecorView();
        if (root.getTag(SQUARE_TAG) != null) return;
        android.view.ViewTreeObserver.OnPreDrawListener l = new android.view.ViewTreeObserver.OnPreDrawListener() {
            @Override public boolean onPreDraw() {
                // Ouverture (et changement de thème, qui recrée l'écran) : chaque vue prend les couleurs du thème
                // avant d'être dessinée. Sinon le fond, les panneaux et les cases changeaient l'un après l'autre,
                // au gré de leur arrivée et du rafraîchissement de fond. Les vues déjà traitées sont ignorées.
                if (android.os.SystemClock.uptimeMillis() - createdAt < 4000) Palette.recolor(root);
                int band = -1;
                band = shownBand(a);
                // Changement de bande : le rafraîchissement de fond n'a lieu que toutes les 2 s, d'où un écran
                // redimensionné puis rempli bien plus tard. On le lance aussitôt.
                if (band != drawnBand) {
                    if (band != 4 && drawnBand == 4) rdsText(a, "");   // carte musique de MG4Dash : plus de texte DAB+
                    drawnBand = band; favsDirty = true; main.post(tick);
                }
                staleText(a, band);
                // Nouveau lecteur (la radio change de fragment avec la bande) : boutons, couleurs et image
                // sont posés avant sa première image, pas au rafraîchissement suivant
                View player = byName(a, "fragment_container");
                if (player instanceof ViewGroup) {
                    ViewGroup g = (ViewGroup) player;
                    boolean fresh = false;
                    for (int i = 0; i < g.getChildCount(); i++) {
                        View page = g.getChildAt(i);
                        if (page.getTag(STYLED_TAG) == null) { page.setTag(STYLED_TAG, Boolean.TRUE); fresh = true; }
                    }
                    if (fresh) { tick.run(); return false; }
                }
                boolean moved = squarePlayer(a, band);
                moved |= fmStrip(a, band);
                moved |= alignTabs(a);
                moved |= gearButton(a);
                moved |= centerControls(a);
                moved |= alignWait(a);
                if (band == 4) dabInfo(a);   // canal posé dès que la radio écrit le multiplex, pas au rafraîchissement suivant
                if (moved) return false;   // dimensions changées : on saute cette image, la suivante est juste
                // Carte à sa nouvelle taille : les favoris de la nouvelle bande sont posés avant cette image,
                // sans attendre le rafraîchissement de fond (sinon l'ancienne grille s'affichait étirée)
                if (favsDirty) {
                    favsDirty = false;
                    try { renderFavorites(a); } catch (Throwable t) { Log.w(TAG, "favoris : " + t); }
                    return false;
                }
                return true;
            }
        };
        root.getViewTreeObserver().addOnPreDrawListener(l);
        root.setTag(SQUARE_TAG, l);
    }
    private static final int SQUARE_TAG = 0x7f7a0002;

    /**
     * Texte DAB+ (DLS) resté sur la page FM / AM : la radio y remet le dernier texte reçu, quelle que soit la bande,
     * jusqu'au premier texte RDS. Il est effacé tant qu'il est identique au dernier texte de la page DAB+.
     */
    private static void staleText(Activity a, int band) {
        if (band == 4) {
            View dls = byName(a, "tv_dab_frequency_name");
            if (dls instanceof TextView && dls.isShown()) {
                CharSequence t = ((TextView) dls).getText();
                if (t != null && t.toString().trim().length() > 0) lastDls = t.toString().trim();
            }
            return;
        }
        if (lastDls == null) return;
        View np = byName(a, "tv_radio_channel_nowplaying_text");
        if (!(np instanceof TextView)) return;
        CharSequence t = ((TextView) np).getText();
        if (t != null && t.toString().trim().equals(lastDls)) ((TextView) np).setText("");
    }
    private static String lastDls;

    // ── DAB+ : canal (bloc de la bande III) après le nom du multiplex, s'il n'y figure pas déjà ──

    private static final String[] BLOCKS = {"5A", "5B", "5C", "5D", "6A", "6B", "6C", "6D", "7A", "7B", "7C", "7D",
            "8A", "8B", "8C", "8D", "9A", "9B", "9C", "9D", "10A", "10N", "10B", "10C", "10D", "11A", "11N", "11B", "11C", "11D",
            "12A", "12N", "12B", "12C", "12D", "13A", "13B", "13C", "13D", "13E", "13F"};
    private static final int[] BLOCK_KHZ = {174928, 176640, 178352, 180064, 181936, 183648, 185360, 187072, 188928, 190640,
            192352, 194064, 195936, 197648, 199360, 201072, 202928, 204640, 206352, 208064, 209936, 210096, 211648, 213360,
            215072, 216928, 217088, 218640, 220352, 222064, 223936, 224096, 225648, 227360, 229072, 230784, 232496, 234208,
            235776, 237488, 239200};

    /** Les mêmes blocs sans 10N, 11N et 12N (table habituelle des tuners, 5A = 0 … 13F = 37). */
    private static final String[] BLOCKS_STD;
    static {
        java.util.List<String> std = new java.util.ArrayList<>();
        for (String b : BLOCKS) if (!b.endsWith("N")) std.add(b);
        BLOCKS_STD = std.toArray(new String[0]);
    }
    private static final java.util.regex.Pattern BLOCK_IN_NAME = java.util.regex.Pattern.compile("\\b(5|6|7|8|9|10|11|12|13)([A-F]|N)\\b");

    /**
     * Table de getFrequencyIndex : -1 pas encore vérifiée, 0 sans les blocs N, 1 avec, -2 aucune ne colle.
     * Vérifiée sur les multiplex dont le nom contient le bloc (PARIS 6D…) ; la radio renvoie une fréquence nulle.
     */
    private static int blockTable = -1;

    private static String ensembleOf(Object st) {
        Object e = callQuiet(st, "getEnsembleName");
        if (e == null) e = callQuiet(st, "getEnsembleLabel");
        return e == null ? "" : e.toString().trim();
    }

    private static void checkBlockTable(Activity a) {
        if (blockTable != -1) return;
        List<Object> list;
        try { list = Stations.all(a, storage(a), 4); } catch (Throwable t) { return; }
        if (list == null || list.isEmpty()) return;
        int std = 0, withN = 0;
        int named = 0;
        StringBuilder log = new StringBuilder();
        for (Object st : list) {
            String ens = ensembleOf(st);
            Object i = callQuiet(st, "getFrequencyIndex");
            if (log.length() < 3000) log.append(" | ").append(Stations.dabLabel(st)).append(" / ").append(ens).append(" ").append(i);
            if (!(i instanceof Number)) continue;
            // Entrée qui porte le nom du multiplex (« PARIS 6D / PARIS 6D 1 ») : la radio lui donne un index
            // sans rapport avec le bloc, elle faisait rejeter la table
            if (ens.equalsIgnoreCase(Stations.dabLabel(st).trim())) continue;
            java.util.regex.Matcher m = BLOCK_IN_NAME.matcher(ens.toUpperCase(Locale.ROOT));
            if (!m.find()) continue;
            int idx = ((Number) i).intValue();
            String token = m.group();
            named++;
            if (idx >= 0 && idx < BLOCKS_STD.length && BLOCKS_STD[idx].equals(token)) std++;
            if (idx >= 0 && idx < BLOCKS.length && BLOCKS[idx].equals(token)) withN++;
        }
        // Majorité des multiplex nommés (au moins les deux tiers) : une entrée isolée ne fait plus tout rejeter
        blockTable = named == 0 ? 0 : std * 3 >= named * 2 && std >= withN ? 0 : withN * 3 >= named * 2 ? 1 : -2;
        Log.i(TAG, "DAB : table des blocs " + blockTable + " (" + named + " multiplex nommés)" + log);
    }

    /** Bloc DAB (11C…) d'après la fréquence (kHz, Hz ou MHz selon la radio), sinon d'après l'index ; null si inconnu. */
    static String dabBlock(Object st) {
        Object f = callQuiet(st, "getFrequencyChannel");
        if (!(f instanceof Number)) f = callQuiet(st, "getFrequency");
        if (f instanceof Number && ((Number) f).doubleValue() > 0) {
            double v = ((Number) f).doubleValue();
            double[] tries = {v, v / 1000, v * 1000};
            for (double khz : tries)
                for (int i = 0; i < BLOCK_KHZ.length; i++)
                    if (Math.abs(khz - BLOCK_KHZ[i]) < 20) return BLOCKS[i];
        }
        Object i = callQuiet(st, "getFrequencyIndex");
        if (!(i instanceof Number) || blockTable < 0) return null;
        int idx = ((Number) i).intValue();
        String[] table = blockTable == 1 ? BLOCKS : BLOCKS_STD;
        return idx >= 0 && idx < table.length ? table[idx] : null;
    }

    private static String dabInfoSet;
    private static long dabInfoLogged = -1;

    private static void dabInfo(Activity a) {
        if (shownBand(a) != 4) return;
        View v = byName(a, "tv_dab_radio_ensemble_name");
        if (!(v instanceof TextView)) return;
        TextView tv = (TextView) v;
        String shown = tv.getText() == null ? "" : tv.getText().toString();
        if (shown.equals(dabInfoSet)) return;   // déjà complété, la radio n'a rien réécrit
        Object st = callQuiet(storage(a), "getCurrentDabStation");
        if (st == null) return;
        String base = shown;
        int k = base.indexOf("  ·  ");   // ajout précédent encore affiché (écran recréé)
        if (k >= 0) base = base.substring(0, k);
        base = base.trim();
        if (base.isEmpty() || base.equals("_")) return;   // nom du multiplex pas encore reçu
        checkBlockTable(a);
        String block = dabBlock(st);
        Object sid = callQuiet(st, "getServiceId");
        long id = sid instanceof Number ? ((Number) sid).longValue() : 0;
        if (id != dabInfoLogged) {
            dabInfoLogged = id;
            Log.i(TAG, "DAB : " + base + " fréquence " + callQuiet(st, "getFrequencyChannel") + " index " + callQuiet(st, "getFrequencyIndex")
                    + " ensemble " + callQuiet(st, "getEnsembleId") + " service " + Long.toHexString(id) + " → " + block);
        }
        StringBuilder b = new StringBuilder(base);
        if (block != null && !base.toUpperCase(Locale.ROOT).matches(".*\\b" + block + "\\b.*")) b.append(b.length() > 0 ? "  ·  " : "").append(block);
        dabInfoSet = b.toString();
        if (!dabInfoSet.equals(shown)) tv.setText(dabInfoSet);
    }
    private static long createdAt;
    private static int drawnBand = -2;
    private static boolean favsDirty;

    /**
     * Bande affichée. La radio n'enregistre la nouvelle bande qu'une fois le tuner calé, une à deux secondes
     * après l'appui sur l'onglet : la mise en page suivait avec ce retard. L'onglet touché fait foi en attendant.
     */
    private static int shownBand(Activity a) {
        int band = -1;
        try { band = ((Number) call(storage(a), "getStoredRadioBand")).intValue(); } catch (Throwable ignored) {}
        if (pendingBand >= 0) {
            if (band != pendingBand && android.os.SystemClock.uptimeMillis() - pendingAt < 5000) return pendingBand;
            pendingBand = -1;
        }
        return band;
    }
    private static int pendingBand = -1;
    private static long pendingAt;

    /** Onglets de bande : un appui annonce la nouvelle bande tout de suite (sans gêner le clic d'origine). */
    private static void watchTabs(final Activity a, String[][] tabs) {
        for (String[] t : tabs) {
            View tab = byName(a, t[0]);
            if (tab == null || tab.getTag(TAB_TAG) != null) continue;
            final int b = Integer.parseInt(t[1]);
            tab.setTag(TAB_TAG, Boolean.TRUE);
            tab.setOnTouchListener(new View.OnTouchListener() {
                @Override public boolean onTouch(View v, android.view.MotionEvent e) {
                    if (e.getActionMasked() == android.view.MotionEvent.ACTION_UP
                            && e.getX() >= 0 && e.getY() >= 0 && e.getX() <= v.getWidth() && e.getY() <= v.getHeight()) {
                        pendingBand = b;
                        pendingAt = android.os.SystemClock.uptimeMillis();
                        a.getWindow().getDecorView().invalidate();   // l'écouteur d'image pose la mise en page
                    }
                    return false;
                }
            });
        }
    }
    private static final int TAB_TAG = 0x7f7a0003;
    private static final int STYLED_TAG = 0x7f7a0004;

    /** Hauteur prise sous le lecteur et les favoris en FM / AM : 12 dp au-dessus, le bandeau, 12 dp au bord de l'écran. */
    private static final int STRIP_DP = 116;
    private static final int STRIP_GAP_DP = 12;
    private static final String STRIP_TAG = "rd_fm_dial";

    /**
     * FM / AM : bandeau du curseur sur toute la largeur, sous le lecteur et les favoris. Le contenu de l'activité
     * accueille ce bandeau : il se place d'après les deux panneaux et se cache en DAB et sur les listes SAIC.
     */
    private static boolean fmStrip(Activity a, int band) {
        View cont = byName(a, "fragment_container");
        View card = byName(a, "fragment_container_card");
        View content = a.findViewById(android.R.id.content);
        if (cont == null || card == null || !(content instanceof android.widget.FrameLayout)) return false;
        boolean fm = band != 4;
        boolean moved = false;
        int reserve = fm ? dp(a, STRIP_DP) : 0;
        if (cont.getPaddingBottom() != reserve) { cont.setPadding(cont.getPaddingLeft(), cont.getPaddingTop(), cont.getPaddingRight(), reserve); moved = true; }
        ViewGroup.MarginLayoutParams lp = (ViewGroup.MarginLayoutParams) card.getLayoutParams();
        int margin = fm ? reserve : dabCardMargin(a, cont, card, lp.bottomMargin);
        if (lp.bottomMargin != margin) { lp.bottomMargin = margin; card.setLayoutParams(lp); moved = true; }
        android.widget.FrameLayout root = (android.widget.FrameLayout) content;
        View old = root.findViewWithTag(STRIP_TAG);
        android.widget.FrameLayout strip;
        if (old instanceof android.widget.FrameLayout) strip = (android.widget.FrameLayout) old;
        else {
            strip = new android.widget.FrameLayout(a);
            strip.setTag(STRIP_TAG);
            strip.setBackground(panel(a, PANEL, 20, BORDER));
            strip.setPadding(dp(a, 16), 0, dp(a, 16), 0);
            root.addView(strip, new android.widget.FrameLayout.LayoutParams(1, 1));
        }
        View fmList = byName(a, "fl_fm_am_list");
        View dabList = byName(a, "fl_dab_list");
        boolean show = fm && (fmList == null || fmList.getVisibility() != View.VISIBLE) && (dabList == null || dabList.getVisibility() != View.VISIBLE);
        if (strip.getVisibility() != (show ? View.VISIBLE : View.GONE)) { strip.setVisibility(show ? View.VISIBLE : View.GONE); moved = true; }
        if (!show || cont.getWidth() <= 0 || card.getWidth() <= 0) return moved;
        int[] c = new int[2], k = new int[2], r = new int[2];
        cont.getLocationInWindow(c);
        card.getLocationInWindow(k);
        root.getLocationInWindow(r);
        // Bord gauche du bandeau = bord gauche du panneau du lecteur (le conteneur n'a pas de marge à gauche),
        // bord droit = bord droit des favoris. Lecteur à droite : l'inverse, moins la marge de droite du lecteur (12 dp).
        int left = c[0] - r[0];
        int right = k[0] + card.getWidth() - r[0];
        if (c[0] > k[0]) { left = k[0] - r[0]; right = c[0] + cont.getWidth() - dp(a, 12) - r[0]; }
        int top = k[1] + card.getHeight() + dp(a, STRIP_GAP_DP) - r[1];
        android.widget.FrameLayout.LayoutParams s = (android.widget.FrameLayout.LayoutParams) strip.getLayoutParams();
        int w = right - left, hh = dp(a, STRIP_DP - 2 * STRIP_GAP_DP);
        // Barre MG4Dash en bas : le bandeau descend jusqu'à 12 dp de la barre, comme les autres écarts entre cadres
        View dock = root.findViewWithTag("rd_dock");
        if (!Palette.verticalDock && dock != null && dock.isShown() && dock.getHeight() > 0) {
            int[] d = new int[2];
            dock.getLocationInWindow(d);
            hh = Math.max(hh, d[1] - r[1] - dp(a, STRIP_GAP_DP) - top);
        }
        if (s.leftMargin != left || s.topMargin != top || s.width != w || s.height != hh) {
            s.leftMargin = left; s.topMargin = top; s.width = w; s.height = hh;
            strip.setLayoutParams(s);
            moved = true;
        }
        return moved;
    }

    /**
     * DAB : marge du bas des favoris pour que leur fond s'arrête au même niveau que le lecteur de gauche
     * (le panneau de l'image, sinon le bas du conteneur moins 12 dp). Mesuré à l'écran : la carte et le lecteur
     * n'ont pas le même parent.
     */
    private static int dabCardMargin(Activity a, View cont, View card, int current) {
        if (cont.getHeight() <= 0 || card.getHeight() <= 0) return dp(a, 12);
        int[] p = new int[2], k = new int[2];
        View player = cont instanceof ViewGroup ? ((ViewGroup) cont).findViewWithTag("rd_imm") : null;
        int want;
        if (player != null && player.isShown() && player.getHeight() > 0) {
            player.getLocationInWindow(p);
            want = p[1] + player.getHeight();
        } else {
            cont.getLocationInWindow(p);
            want = p[1] + cont.getHeight() - cont.getPaddingBottom() - dp(a, 12);
        }
        card.getLocationInWindow(k);
        return Math.max(0, current + k[1] + card.getHeight() - want);
    }

    /** Texte RDS de la station FM : envoyé à MG4Dash, la session média de la radio ne le contient pas. */
    public static void rdsText(Context c, String text) {
        try {
            c.sendBroadcast(new android.content.Intent("app.mg4dash.RDS_TEXT").setPackage("app.mg4dash").putExtra("text", text == null ? "" : text.trim()));
        } catch (Throwable t) { Log.w(TAG, "texte RDS : " + t); }
    }

    private static boolean squarePlayer(Activity a, int band) {
        View cont = byName(a, "fragment_container");
        View card = byName(a, "fragment_container_card");
        if (cont == null || card == null || !(card.getParent() instanceof View)) return false;
        int parentW = ((View) card.getParent()).getWidth();
        int h = cont.getHeight();
        int want = dp(a, 640);
        // FM / AM : même partage que le DAB, le curseur passe sur toute la largeur en dessous (fmStrip)
        if ((band != 4 || Palette.immersiveDab()) && parentW > 0 && h > 0) {
            // Panneau = hauteur du conteneur moins sa marge du haut (12 dp) ; à sa largeur s'ajoutent la
            // marge de gauche (16), la marge de droite du panneau (12) et celle de la carte (16)
            int side = h - dp(a, 24);   // marge du haut (12) et du bas (12, alignée sur la barre de gauche)
            want = Math.max(dp(a, 640), parentW - side - dp(a, 44));
        }
        ViewGroup.LayoutParams lp = card.getLayoutParams();
        if (lp.width != want) { lp.width = want; card.setLayoutParams(lp); return true; }
        return false;
    }

    /**
     * Onglets de bande (DAB / FM, et AM sur SWI68) centrés dans l'espace libre au-dessus du lecteur : au milieu de la
     * largeur du panneau, et à mi-hauteur entre le haut de l'écran et le haut du panneau. La rangée d'onglets grandit
     * pour cela (64 dp à l'origine) ; sa largeur suit le nombre d'onglets.
     * @return true si la mise en page a changé
     */
    private static boolean tabsLogged;

    private static final int TAB_DP = 180;   // largeur des onglets dans radio_tab_layout.xml

    private static boolean alignTabs(Activity a) {
        View bar = byName(a, "rl_menu_bar");
        View cont = byName(a, "fragment_container");
        if (bar == null || cont == null || !(bar.getLayoutParams() instanceof ViewGroup.MarginLayoutParams)
                || !(bar.getParent() instanceof View) || cont.getWidth() <= 0 || bar.getWidth() <= 0) return false;
        View row = (View) bar.getParent();
        int[] c = new int[2], p = new int[2];
        cont.getLocationInWindow(c);
        row.getLocationInWindow(p);
        // Panneau du lecteur : bord gauche du conteneur, marge de droite de 12 dp, marge du haut de 12 dp
        int panelLeft = c[0], panelRight = c[0] + cont.getWidth() - dp(a, 12), panelTop = c[1] + dp(a, 12);
        boolean moved = false;
        int space = panelTop - p[1];
        // La rangée grandit seulement si ses voisines ne sont pas empilées dessous (sinon elle les pousserait) :
        // on décale alors les onglets sans la grandir
        boolean stacked = row.getParent() instanceof LinearLayout && ((LinearLayout) row.getParent()).getOrientation() == LinearLayout.VERTICAL;
        if (!tabsLogged) { tabsLogged = true; Log.i(TAG, "onglets dans " + row.getParent().getClass().getSimpleName() + (stacked ? " (empilés)" : "")); }
        int rowH = row.getHeight();
        ViewGroup.LayoutParams rlp = row.getLayoutParams();
        if (!stacked && rlp != null && space > bar.getHeight() && rlp.height != space) { rlp.height = space; row.setLayoutParams(rlp); rowH = space; moved = true; }
        ViewGroup.MarginLayoutParams lp = (ViewGroup.MarginLayoutParams) bar.getLayoutParams();
        // Centre des onglets visibles (la rangée garde à droite les séparateurs de 10 dp de FM et de l'AM caché)
        int minL = Integer.MAX_VALUE, maxR = 0;
        if (bar instanceof ViewGroup) {
            ViewGroup g = (ViewGroup) bar;
            for (int i = 0; i < g.getChildCount(); i++) {
                View t = g.getChildAt(i);
                if (t.getVisibility() != View.VISIBLE || t.getId() == View.NO_ID || t.getWidth() <= 0) continue;
                String n = "";
                try { n = a.getResources().getResourceEntryName(t.getId()); } catch (Throwable ignored) {}
                if (!n.startsWith("layout_tab_")) continue;
                minL = Math.min(minL, t.getLeft());
                maxR = Math.max(maxR, t.getRight());
            }
        }
        // Trois onglets (AM sur SWI68) : ils rétrécissent pour tenir entre le bord gauche du lecteur et la roue dentée
        int room = panelRight - dp(a, GEAR_DP) - dp(a, 12) - panelLeft;
        if (minL < maxR && bar instanceof ViewGroup) {
            ViewGroup g = (ViewGroup) bar;
            List<View> tabs = new ArrayList<>();
            int tabsW = 0;
            for (int i = 0; i < g.getChildCount(); i++) {
                View t = g.getChildAt(i);
                if (t.getVisibility() != View.VISIBLE || t.getId() == View.NO_ID || t.getWidth() <= 0) continue;
                String n = "";
                try { n = a.getResources().getResourceEntryName(t.getId()); } catch (Throwable ignored) {}
                if (!n.startsWith("layout_tab_")) continue;
                tabs.add(t);
                tabsW += t.getWidth();
            }
            int gaps = (maxR - minL) - tabsW;
            int want = tabs.isEmpty() ? 0 : Math.max(dp(a, 120), Math.min(dp(a, TAB_DP), (room - gaps) / tabs.size()));
            boolean resized = false;
            for (View t : tabs) {
                // L'onglet suit sa largeur de contenu : c'est le libellé (180 dp dans la mise en page) qui change
                View label = t instanceof ViewGroup && ((ViewGroup) t).getChildCount() > 0 ? ((ViewGroup) t).getChildAt(0) : t;
                ViewGroup.LayoutParams tl = label.getLayoutParams();
                if (tl != null && tl.width > 0 && tl.width != want) { tl.width = want; label.setLayoutParams(tl); resized = true; }
            }
            if (resized) return true;   // nouvelles largeurs : centrage à l'image suivante
        }
        int mid = minL < maxR ? (minL + maxR) / 2 : bar.getWidth() / 2;
        int start = Math.max(0, (panelLeft + panelRight) / 2 - mid - p[0]);
        // La roue dentée occupe le bout droit de la rangée : les onglets s'arrêtent 12 dp avant elle
        int clear = panelRight - dp(a, GEAR_DP) - dp(a, 12) - p[0];
        if (minL < maxR && start + maxR > clear) start = Math.max(0, clear - maxR);
        int top = Math.max(0, (Math.min(space, rowH) - bar.getHeight()) / 2);
        if (lp.getMarginStart() != start || lp.topMargin != top) {
            lp.setMarginStart(start);
            lp.topMargin = top;
            bar.setLayoutParams(lp);
            moved = true;
        }
        float shift = stacked ? Math.max(0, (space - bar.getHeight()) / 2f - top) : 0;
        if (bar.getTranslationY() != shift) {
            if (row instanceof ViewGroup) ((ViewGroup) row).setClipChildren(false);
            if (row.getParent() instanceof ViewGroup) ((ViewGroup) row.getParent()).setClipChildren(false);
            bar.setTranslationY(shift);
        }
        return moved;
    }

    private static void fixLayout(Activity a) {
        // Onglets : puces MG4Dash (rd_bg_chip, selon l'état « sélectionné »). Le chargeur de thèmes
        // d'origine remet le fond de la mise en page au démarrage : un fond posé ici était perdu.
        int band = shownBand(a);
        String[][] tabs = {{"layout_tab_dab", "4"}, {"layout_tab_fm", "1"}, {"layout_tab_am", "0"}};
        watchTabs(a, tabs);
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
        fmStrip(a, band);
        alignTabs(a);
        gearButton(a);
        // AM : la radio écrit « KHz », les cartes et le cadran disent « kHz »
        View hz = byName(a, "tx_radio_hz_type");
        if (hz instanceof TextView && "KHz".contentEquals(((TextView) hz).getText())) ((TextView) hz).setText("kHz");
        // Ici et pas avant chaque image : changer un fond redemande une image, l'écran se redessinerait sans fin
        View player = byName(a, "fragment_container");
        if (band != 4 && player != null) Immersive.styleFmButtons(a, player);
        modeButtons(a);
        hookSkipButtons(a);
        centerControls(a);
    }

    /**
     * Lecteur Immersive (pochette cachée) : la colonne d'infos garde sa marge de 28 dp à gauche, et ◀ ▶ / lecture
     * étaient centrés sur elle, 14 dp à droite du centre du lecteur. La rangée la reprend. Appelé avant chaque image.
     * @return true si la mise en page a changé
     */
    private static boolean centerControls(Activity a) {
        int id = a.getResources().getIdentifier("ll_dab_base_function", "id", a.getPackageName());
        View v = id == 0 ? null : a.findViewById(id);
        if (v != null && v.getLayoutParams() instanceof LinearLayout.LayoutParams) {
            LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) v.getLayoutParams();
            int start = 0;
            View info = byName(a, "ll_dab_info");
            if (info != null && info.getParent() instanceof ViewGroup && info.getLayoutParams() instanceof ViewGroup.MarginLayoutParams) {
                ViewGroup row = (ViewGroup) info.getParent();
                View art = row.getChildCount() > 0 ? row.getChildAt(0) : null;
                if (art != null && art != info && art.getVisibility() == View.GONE)
                    start = -((ViewGroup.MarginLayoutParams) info.getLayoutParams()).getMarginStart();
            }
            if (lp.leftMargin != start || lp.topMargin != 0 || lp.width != ViewGroup.LayoutParams.MATCH_PARENT) {
                lp.setMargins(start, 0, 0, 0);
                lp.setMarginStart(start);
                lp.gravity = Gravity.NO_GRAVITY;
                lp.width = ViewGroup.LayoutParams.MATCH_PARENT;
                v.setLayoutParams(lp);
                return true;
            }
        }
        return false;
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
        // Station sans image : on oublie celle de la station précédente (cache de la station, sinon fond uni)
        art = b;
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

    // ── Mode Favoris / toutes les stations, scan ─────────────────────────────

    /**
     * Haut du lecteur : l'étoile seule dans le coin (déplacée là par la mise en page). La roue dentée d'origine reste
     * dans la page (la radio la cherche) mais sans place ni taille : un bouton jumeau dans la rangée des onglets
     * la déclenche (gearButton). Son état visible / caché reste celui que la radio lui donne.
     */
    private static void modeButtons(final Activity a) {
        // Bouton EPG caché par la radio sans programme : il gardait sa place et poussait la ligne
        View epg = byName(a, "btn_dab_program");
        if (epg != null && epg.getVisibility() == View.INVISIBLE) epg.setVisibility(View.GONE);
        View rds = byName(a, "btn_dab_rds_setting");
        if (rds != null && rds.getLayoutParams() instanceof ViewGroup.MarginLayoutParams) {
            ViewGroup.MarginLayoutParams lp = (ViewGroup.MarginLayoutParams) rds.getLayoutParams();
            if (lp.width != 0 || lp.height != 0 || lp.getMarginStart() != 0) {
                lp.width = 0; lp.height = 0; lp.setMarginStart(0); lp.setMarginEnd(0);
                rds.setLayoutParams(lp);
            }
        }
        paintModeButtons(a);
    }

    /** Bascule « ★ Favoris | Toutes les stations » du bandeau de droite, et Scan caché en mode Favoris. */
    private static void paintModeButtons(Activity a) {
        View root = a.getWindow().getDecorView();
        boolean on = Stations.favOnly(a);
        View seg = root.findViewWithTag("rd_mode_seg");
        View f = root.findViewWithTag("rd_seg_fav"), all = root.findViewWithTag("rd_seg_all");
        if (seg != null && f instanceof TextView && all instanceof TextView) {
            String state = on + "|" + Palette.isLight() + "|" + Palette.starColor();
            if (!state.equals(seg.getTag(MODE_TAG))) {
                seg.setTag(MODE_TAG, state);
                android.text.SpannableString sp = new android.text.SpannableString("★  " + tr(7));
                sp.setSpan(new android.text.style.ForegroundColorSpan(on ? Palette.starColor() : Palette.map(SUB)), 0, 1, 0);
                ((TextView) f).setText(sp);
                ((TextView) all).setText(tr(8));
                ((TextView) f).setTextColor(on ? TEXT : SUB);
                ((TextView) all).setTextColor(on ? SUB : TEXT);
                f.setBackground(on ? panel(a, 0x262979FF, 10, ACTION) : null);
                all.setBackground(on ? null : panel(a, 0x262979FF, 10, ACTION));
                seg.setBackground(panel(a, BUTTON, 12, BORDER));
                Palette.recolor(seg);
            }
        }
        View s = root.findViewWithTag("rd_scan");
        if (s != null) {
            int vis = on ? View.GONE : View.VISIBLE;
            if (s.getVisibility() != vis) s.setVisibility(vis);
            if (s.getTag(MODE_TAG) == null) {
                s.setTag(MODE_TAG, Boolean.TRUE);
                s.setBackground(panel(a, BUTTON, 12, BORDER));
                Palette.recolor(s);
            }
        }
    }

    /** Bascule des deux modes : chaque moitié choisit le sien. */
    private static View modeSwitch(final Activity a) {
        LinearLayout seg = new LinearLayout(a);
        seg.setTag("rd_mode_seg");
        seg.setOrientation(LinearLayout.HORIZONTAL);
        seg.setPadding(dp(a, 3), dp(a, 3), dp(a, 3), dp(a, 3));
        for (int i = 0; i < 2; i++) {
            final boolean fav = i == 0;
            TextView t = text(a, "", 18, TEXT);
            t.setTag(fav ? "rd_seg_fav" : "rd_seg_all");
            t.setGravity(Gravity.CENTER);
            t.setSingleLine(true);
            t.setPadding(dp(a, 18), 0, dp(a, 18), 0);
            t.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { if (Stations.favOnly(a) != fav) toggleMode(a); }
            });
            seg.addView(t, new LinearLayout.LayoutParams(-2, -1));
        }
        return seg;
    }

    // ── Roue dentée dans la rangée des onglets, alignée sur le bord droit du lecteur ──

    private static final String GEAR_TAG = "rd_gear";
    private static final int GEAR_DP = 64;

    /** Bouton jumeau de la roue dentée de la page (réglages RDS / DAB+) : même effet, posé à côté des onglets. */
    private static boolean gearButton(final Activity a) {
        View content = a.findViewById(android.R.id.content);
        View cont = byName(a, "fragment_container");
        View bar = byName(a, "rl_menu_bar");
        if (!(content instanceof FrameLayout) || cont == null || bar == null) return false;
        FrameLayout root = (FrameLayout) content;
        View old = root.findViewWithTag(GEAR_TAG);
        FrameLayout gear;
        if (old instanceof FrameLayout) gear = (FrameLayout) old;
        else {
            gear = new FrameLayout(a);
            gear.setTag(GEAR_TAG);
            gear.setBackground(panel(a, BUTTON, 16, BORDER));
            ImageView icon = new ImageView(a);
            icon.setImageDrawable(new Gear(Palette.map(0xFFFFFFFF)));
            icon.setScaleType(ImageView.ScaleType.FIT_XY);
            icon.setPadding(dp(a, 14), dp(a, 14), dp(a, 14), dp(a, 14));
            gear.addView(icon, new FrameLayout.LayoutParams(-1, -1));
            gear.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {
                    View rds = byName(a, "btn_dab_rds_setting");
                    if (rds != null) rds.performClick();
                }
            });
            root.addView(gear, new FrameLayout.LayoutParams(dp(a, GEAR_DP), dp(a, GEAR_DP)));
            Palette.recolor(gear);
        }
        View icon = gear.getChildAt(0);
        int color = Palette.map(0xFFFFFFFF);
        if (icon instanceof ImageView && !Integer.valueOf(color).equals(icon.getTag(ICON_TAG))) {
            android.graphics.drawable.Drawable d = ((ImageView) icon).getDrawable();
            if (d instanceof Gear) ((Gear) d).setColor(color);
            ((ImageView) icon).setImageTintList(null);
            icon.setTag(ICON_TAG, color);
        }
        View rds = byName(a, "btn_dab_rds_setting");
        View fmList = byName(a, "fl_fm_am_list"), dabList = byName(a, "fl_dab_list");
        boolean show = rds != null && rds.getVisibility() == View.VISIBLE && cont.isShown()
                && (fmList == null || fmList.getVisibility() != View.VISIBLE) && (dabList == null || dabList.getVisibility() != View.VISIBLE);
        boolean moved = false;
        int vis = show ? View.VISIBLE : View.GONE;
        if (gear.getVisibility() != vis) { gear.setVisibility(vis); moved = true; }
        if (!show || cont.getWidth() <= 0 || bar.getHeight() <= 0) return moved;
        int[] c = new int[2], b = new int[2], r = new int[2];
        cont.getLocationInWindow(c);
        bar.getLocationInWindow(b);
        root.getLocationInWindow(r);
        int size = dp(a, GEAR_DP);
        int left = c[0] + cont.getWidth() - dp(a, 12) - size - r[0];
        int top = b[1] + Math.round(bar.getTranslationY()) + (bar.getHeight() - size) / 2 - r[1];
        FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) gear.getLayoutParams();
        if (lp.leftMargin != left || lp.topMargin != top) { lp.leftMargin = left; lp.topMargin = top; gear.setLayoutParams(lp); moved = true; }
        return moved;
    }
    private static final int ICON_TAG = 0x7f7a0009;

    private static final int MODE_TAG = 0x7f7a0005;

    private static void toggleMode(Activity a) {
        boolean on = !Stations.favOnly(a);
        Stations.setFavOnly(a, on);
        if (on && scan != null) scan.stop(true, "mode favoris");
        paintModeButtons(a);
        refreshGrid(a);
        scanUi(a);
    }

    /** Redessine la case de droite tout de suite (favori ajouté ou retiré, mode changé, station trouvée). */
    private static void refreshGrid(Activity a) {
        View g = a.getWindow().getDecorView().findViewWithTag("rd_favs_grid");
        if (g != null) g.setContentDescription(null);
        try { renderFavorites(a); } catch (Throwable t) { Log.w(TAG, "stations : " + t); }
    }

    private static void scanPressed(final Activity a) {
        if (scan != null) { scan.stop(true, "bouton Arrêter"); return; }
        scanResultUntil = 0;
        int band = shownBand(a);
        if (band == 4) { dabRefresh(a); return; }
        if (band != 0 && band != 1) return;
        scan = new FmAmScan(a, band);
        scan.start();
    }

    /** DAB+ : la liste vient du tuner. Scan lui redemande sa liste à jour, puis relit la base après quelques secondes. */
    private static void dabRefresh(final Activity a) {
        try {
            Object rm = radioManager;
            if (rm != null) rm.getClass().getMethod("queryDabStationList").invoke(rm);
        } catch (Throwable t) { Log.w(TAG, "liste DAB : " + t); }
        dabRefreshUntil = android.os.SystemClock.uptimeMillis() + 4000;
        scanUi(a);
        main.postDelayed(new Runnable() {
            @Override public void run() { showScanResult(a, 4, 0); refreshGrid(a); }
        }, 4100);
    }
    private static long dabRefreshUntil;

    /** Résultat affiché quelques secondes dans l'en-tête après un scan (DAB+ : compté en direct, la liste se remplit encore). */
    private static String scanResult = "";
    private static int scanResultBand = -1;
    private static long scanResultUntil;
    private static final long SCAN_RESULT_MS = 10000;

    private static void showScanResult(final Activity a, int band, int count) {
        scanResultBand = band;
        scanResult = String.format(Locale.getDefault(), tr(16), count);
        scanResultUntil = android.os.SystemClock.uptimeMillis() + SCAN_RESULT_MS;
        scanUi(a);
        main.postDelayed(new Runnable() {
            @Override public void run() { scanUi(a); }
        }, SCAN_RESULT_MS + 100);
    }

    private static String scanResultText(Activity a) {
        if (android.os.SystemClock.uptimeMillis() >= scanResultUntil || shownBand(a) != scanResultBand) return "";
        if (scanResultBand != 4) return scanResult;
        try {
            return String.format(Locale.getDefault(), tr(16), Stations.all(a, storage(a), 4).size());
        } catch (Throwable t) { return scanResult; }
    }

    /**
     * En-tête de la case de droite : titre (Favoris ou Toutes les stations), progression du scan et temps d'écoute
     * réglable. Même hauteur que le titre seul d'origine : les cases gardent leur taille d'un mode à l'autre.
     */
    private static void favsHeader(Activity a, int band, boolean favOnly) {
        View decor = a.getWindow().getDecorView();
        View t = decor.findViewWithTag("rd_favs_title");
        if (!(t instanceof TextView) || !(t.getParent() instanceof ViewGroup)) return;
        TextView title = (TextView) t;
        ViewGroup parent = (ViewGroup) t.getParent();
        if (!"rd_favs_row".equals(parent.getTag())) {
            if (!(parent instanceof LinearLayout)) return;
            if (favsTitle == null) favsTitle = title.getText();
            int index = parent.indexOfChild(title);
            parent.removeView(title);
            FrameLayout box = new FrameLayout(a);
            box.setTag("rd_favs_head");
            LinearLayout row = new LinearLayout(a);
            row.setTag("rd_favs_row");
            row.setOrientation(LinearLayout.HORIZONTAL);
            row.setGravity(Gravity.CENTER_VERTICAL);
            // Bord droit = celui de la dernière colonne de cases (marge de la liste 12 dp + écart des cases 5 dp)
            row.setPadding(dp(a, 17), 0, dp(a, 12 + 5), 0);
            // Le titre d'origine reste dans la page (caché) : la bascule des deux modes prend sa place
            title.setVisibility(View.GONE);
            row.addView(title, new LinearLayout.LayoutParams(0, -2));
            row.addView(modeSwitch(a), new LinearLayout.LayoutParams(-2, -1));
            TextView scanB = text(a, tr(9), 18, TEXT);
            scanB.setTag("rd_scan");
            scanB.setGravity(Gravity.CENTER);
            scanB.setSingleLine(true);
            scanB.setPadding(dp(a, 18), 0, dp(a, 18), 0);
            scanB.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { scanPressed(a); }
            });
            LinearLayout.LayoutParams slp = new LinearLayout.LayoutParams(-2, -1);
            slp.setMarginStart(dp(a, 10));
            row.addView(scanB, slp);
            TextView status = text(a, "", 20, TEXT);
            status.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
            status.setTag("rd_scan_status");
            status.setSingleLine(true);
            status.setEllipsize(android.text.TextUtils.TruncateAt.END);
            status.setPadding(dp(a, 12), 0, 0, 0);
            row.addView(status, new LinearLayout.LayoutParams(-2, -2));
            row.addView(new View(a), new LinearLayout.LayoutParams(0, 1, 1f));
            row.addView(seekWaitControl(a));
            box.addView(row, new FrameLayout.LayoutParams(-1, -1));
            LinearLayout.LayoutParams hlp = new LinearLayout.LayoutParams(-1, dp(a, 44));
            hlp.topMargin = dp(a, 8);
            hlp.bottomMargin = dp(a, 2);
            parent.addView(box, index, hlp);
            Palette.recolor(box);
        }
        if (title.getVisibility() != View.GONE) title.setVisibility(View.GONE);
        paintModeButtons(a);
        scanUi(a);
        View wait = decor.findViewWithTag("rd_scan_wait");
        int vis = !favOnly && band != 4 ? View.VISIBLE : View.GONE;
        if (wait != null && wait.getVisibility() != vis) wait.setVisibility(vis);
    }
    private static CharSequence favsTitle;

    /**
     * Réglage « Écoute » calé sur la dernière colonne de cases en dessous, d'après leur position réelle (la largeur
     * des cases est arrondie et la rangée garde quelques pixels à droite).
     * @return true si la mise en page a changé
     */
    private static boolean alignWait(Activity a) {
        View decor = a.getWindow().getDecorView();
        View wait = decor.findViewWithTag("rd_scan_wait");
        View grid = decor.findViewWithTag("rd_favs_grid");
        if (wait == null || wait.getVisibility() != View.VISIBLE || !(wait.getParent() instanceof View)
                || !(grid instanceof ViewGroup) || ((ViewGroup) grid).getChildCount() == 0) return false;
        View first = ((ViewGroup) grid).getChildAt(0);
        if (!(first instanceof ViewGroup) || ((ViewGroup) first).getChildCount() < COLUMNS) return false;
        View last = ((ViewGroup) first).getChildAt(COLUMNS - 1);
        View row = (View) wait.getParent();
        if (last.getWidth() <= 0 || row.getWidth() <= 0) return false;
        int[] l = new int[2], r = new int[2];
        last.getLocationInWindow(l);
        row.getLocationInWindow(r);
        int end = r[0] + row.getWidth() - (l[0] + last.getWidth());
        boolean moved = false;
        if (end >= 0 && row.getPaddingEnd() != end) { row.setPaddingRelative(row.getPaddingStart(), 0, end, 0); moved = true; }
        ViewGroup.LayoutParams lp = wait.getLayoutParams();
        if (lp.width != last.getWidth()) { lp.width = last.getWidth(); wait.setLayoutParams(lp); moved = true; }
        return moved;
    }

    /** Libellé du bouton Scan, fréquence et nombre de stations trouvées (le cadran du bas suit la fréquence). */
    private static void scanUi(Activity a) {
        View decor = a.getWindow().getDecorView();
        boolean dabBusy = android.os.SystemClock.uptimeMillis() < dabRefreshUntil;
        View b = decor.findViewWithTag("rd_scan");
        if (b instanceof TextView) {
            String want = scan != null ? tr(10) : tr(9);
            if (!want.contentEquals(((TextView) b).getText())) ((TextView) b).setText(want);
        }
        View st = decor.findViewWithTag("rd_scan_status");
        if (st instanceof TextView) {
            String s = scan != null ? scan.status : dabBusy ? tr(11) : scanResultText(a);
            if (!s.contentEquals(((TextView) st).getText())) ((TextView) st).setText(s);
            int vis = s.isEmpty() ? View.GONE : View.VISIBLE;
            if (st.getVisibility() != vis) st.setVisibility(vis);
        }
    }

    private static final String SEEK_WAIT_KEY = "rd_seek_wait_s";
    private static final int SEEK_WAIT_MIN = 1, SEEK_WAIT_MAX = 15, SEEK_WAIT_DEFAULT = 5;

    private static int seekWaitSeconds(Context c) {
        return c.getSharedPreferences("radio_dash", Context.MODE_PRIVATE).getInt(SEEK_WAIT_KEY, SEEK_WAIT_DEFAULT);
    }

    /** Temps d'écoute maximal de chaque station pendant le scan : « Écoute ◀ 5 s ▶ », de 1 à 15 s. */
    private static View seekWaitControl(final Activity a) {
        LinearLayout box = new LinearLayout(a);
        box.setTag("rd_scan_wait");
        box.setGravity(Gravity.CENTER_VERTICAL);
        box.setBackground(panel(a, BUTTON, 12, BORDER));
        box.setPadding(dp(a, 12), 0, 0, 0);
        LinearLayout.LayoutParams boxLp = new LinearLayout.LayoutParams(-2, dp(a, 40));
        boxLp.setMarginStart(dp(a, 12));
        box.setLayoutParams(boxLp);
        TextView label = text(a, tr(13), 15, SUB);
        label.setSingleLine(true);
        box.addView(label, new LinearLayout.LayoutParams(0, -2, 1f));
        final TextView value = text(a, seekWaitSeconds(a) + " s", 17, TEXT);
        value.setGravity(Gravity.CENTER);
        for (final int step : new int[]{-1, 1}) {
            TextView arrow = text(a, step < 0 ? "◀" : "▶", 17, TEXT);
            arrow.setGravity(Gravity.CENTER);
            arrow.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {
                    int w = Math.max(SEEK_WAIT_MIN, Math.min(SEEK_WAIT_MAX, seekWaitSeconds(a) + step));
                    a.getSharedPreferences("radio_dash", Context.MODE_PRIVATE).edit().putInt(SEEK_WAIT_KEY, w).apply();
                    value.setText(w + " s");
                }
            });
            if (step > 0) box.addView(value, new LinearLayout.LayoutParams(dp(a, 44), -1));
            box.addView(arrow, new LinearLayout.LayoutParams(dp(a, 42), -1));
        }
        return box;
    }

    /** Scan en cours (FM / AM), ou null. */
    private static FmAmScan scan;

    /**
     * Scan de la bande FM / AM. Le scan de la radio passe par startBackgroundScan, refusé par le tuner (« scan ret ->
     * false » sur SWI69), et ne remplissait pas la liste AM sur SWI68 : on enchaîne donc les recherches de la station
     * suivante depuis le bas de la bande. Chaque station où la recherche s'arrête est ajoutée à la liste ; en FM on
     * passe à la suivante dès que son nom RDS est connu, sinon après le temps d'écoute réglé. Scan complet (revenu en
     * bas de bande) : les stations connues qui n'ont pas été retrouvées sont retirées, sauf les favoris. À la fin, ou
     * sur « Arrêter », retour à la station d'avant ; une station choisie pendant le scan l'arrête sans y revenir.
     */
    private static final class FmAmScan {
        private static final int FM_MIN = 87500, FM_MAX = 108000, AM_MIN = 522, AM_MAX = 1620;
        private static final int STILL_MS = 10_000, MAX_MS = 900_000, POLL_MS = 500, MIN_LISTEN_MS = 1_000;
        private final Activity a; final int band;
        private boolean running; private int origin, last, highest, otherBand; private long lastMove, lastSeek, started;
        private final java.util.TreeSet<Integer> seen = new java.util.TreeSet<>();
        String status = "";

        FmAmScan(Activity a, int band) { this.a = a; this.band = band; }

        private final Runnable poll = new Runnable() {
            @Override public void run() {
                if (!running) return;
                // Autre bande choisie : onglet touché, ou bande enregistrée différente pendant 1,5 s (pendant une
                // recherche, la radio peut la donner autre un instant)
                if (pendingBand >= 0 && pendingBand != band) { stop(false, "onglet " + pendingBand); return; }
                otherBand = shownBand(a) != band ? otherBand + 1 : 0;
                if (otherBand >= 3) { stop(false, "bande " + shownBand(a)); return; }
                long now = android.os.SystemClock.uptimeMillis();
                Object storage = storage(a);
                int ch = currentFmChannel(storage);
                if (ch != last) { last = ch; lastMove = now; }
                int min = band == 0 ? AM_MIN : FM_MIN, max = band == 0 ? AM_MAX : FM_MAX;
                String f = ch < 0 ? tr(11) : band == 0 ? ch + " kHz" : String.format(Locale.getDefault(), "%.1f MHz", ch / 1000f);
                status = f + "  ·  " + String.format(Locale.getDefault(), tr(12), seen.size());
                // Revenu en bas de bande après être monté : tout est parcouru
                boolean wrapped = band == 0 ? highest > AM_MIN + 100 && ch >= 0 && ch < highest - 100
                        : highest > FM_MIN + 1000 && ch >= 0 && ch < highest - 1000;
                if (ch > highest) highest = ch;
                int waitMs = seekWaitSeconds(a) * 1000;
                // Départ : bas de bande accordé, la recherche part tout de suite (pas d'écoute sur la butée)
                if (lastSeek == started) { seek(); lastSeek = now; scanUi(a); main.postDelayed(this, POLL_MS); return; }
                if (wrapped) { finish(true, true); return; }
                if (now - lastMove > STILL_MS + waitMs || now - started > MAX_MS) { finish(false, true); return; }
                // FM : le temps réglé est un maximum pour capter le nom RDS : une fois le nom connu, station suivante
                String ps = band == 0 ? null : rdsName(storage, ch);
                boolean named = ps != null && now - lastMove > MIN_LISTEN_MS && now - lastSeek > MIN_LISTEN_MS;
                if (named || now - lastMove > waitMs && now - lastSeek > waitMs) {
                    // La recherche s'est arrêtée ici (pas le point de départ) : une station
                    if (lastMove > lastSeek && lastSeek > started && ch >= min && ch <= max && seen.add(ch)) {
                        Stations.found(a, band, ch);
                        if (ps != null) Stations.rememberName(a, ch, ps);
                        refreshGrid(a);
                    }
                    seek(); lastSeek = now;
                }
                scanUi(a);
                main.postDelayed(this, POLL_MS);
            }
        };

        /** Nom RDS que la radio a enregistré pour cette fréquence, ou null. */
        private String rdsName(Object storage, int ch) {
            try {
                List<?> l = (List<?>) storage.getClass().getMethod("getPreScannedStationsForBand", int.class).invoke(storage, 1);
                if (l != null) for (Object o : l) {
                    if (((Number) call(o, "getChannelNumber")).intValue() != ch) continue;
                    Object rds = callQuiet(o, "getRds");
                    Object ps = rds == null ? null : callQuiet(rds, "getProgramService");
                    return ps != null && ps.toString().trim().length() >= 2 ? ps.toString().trim() : null;
                }
            } catch (Throwable ignored) {}
            return null;
        }

        private boolean command(String name) {
            Object rm = radioManager;
            if (rm == null) { Log.w(TAG, "service radio non lié"); return false; }
            try { rm.getClass().getMethod(name).invoke(rm); return true; }
            catch (Throwable t) { Log.w(TAG, name + " : " + t); return false; }
        }

        private void seek() { command("seekForward"); }

        void start() {
            origin = currentFmChannel(storage(a));
            tuneAmFm(band == 0 ? AM_MIN : FM_MIN, band == 0);
            running = true;
            started = lastMove = lastSeek = android.os.SystemClock.uptimeMillis();
            last = origin;
            highest = -1;
            status = tr(11);
            Log.i(TAG, "scan " + (band == 0 ? "AM" : "FM") + " lancé");
            scanUi(a);
            main.postDelayed(poll, POLL_MS);
        }

        /** @param restore revenir à la station d'avant le scan */
        void stop(boolean restore, String why) {
            if (!running) return;
            Log.i(TAG, "scan arrêté : " + why);
            command("cancelSeekingOrScanning");
            finish(false, restore);
        }

        private void finish(boolean complete, boolean restore) {
            running = false;
            main.removeCallbacks(poll);
            if (scan == this) scan = null;
            if (complete && !seen.isEmpty()) Stations.scanComplete(a, storage(a), band, seen);
            if (restore && origin > 0) tuneAmFm(origin, band == 0);
            Log.i(TAG, "scan " + (band == 0 ? "AM" : "FM") + (complete ? " terminé : " : " arrêté : ") + seen.size() + " stations");
            if (complete) {
                int n = seen.size();
                try { n = Stations.all(a, storage(a), band).size(); } catch (Throwable ignored) {}
                showScanResult(a, band, n);
            } else scanUi(a);
            refreshGrid(a);
        }
    }

    // ── Changement de station dans l'appli : ◀ ▶ et glissé sur le lecteur ────

    /**
     * ◀ ▶ du lecteur : même liste que le volant (favoris ou toutes les stations). Appui long : recherche de la
     * station reçue suivante, comme les boutons d'origine. Remplace l'écouteur de la radio (recherche à l'appui court).
     */
    private static void hookSkipButtons(final Activity a) {
        String[][] names = {{"btn_previous", "0"}, {"btn_next", "1"}, {"btn_dab_previous", "0"}, {"btn_dab_next", "1"}};
        for (String[] n : names) {
            final View v = byName(a, n[0]);
            if (v == null || v.getTag(SKIP_TAG) != null) continue;
            v.setTag(SKIP_TAG, Boolean.TRUE);
            final boolean forward = n[1].equals("1");
            final boolean[] held = {false};
            final Runnable longPress = new Runnable() {
                @Override public void run() { held[0] = true; seekNext(a, shownBand(a), forward); }
            };
            v.setOnTouchListener(new View.OnTouchListener() {
                @Override public boolean onTouch(View view, android.view.MotionEvent e) {
                    switch (e.getActionMasked()) {
                        case android.view.MotionEvent.ACTION_DOWN:
                            held[0] = false;
                            view.setPressed(true);
                            main.postDelayed(longPress, 600);
                            break;
                        case android.view.MotionEvent.ACTION_UP:
                            view.setPressed(false);
                            main.removeCallbacks(longPress);
                            if (!held[0] && e.getX() >= 0 && e.getY() >= 0 && e.getX() <= view.getWidth() && e.getY() <= view.getHeight())
                                skip(a, forward);
                            break;
                        case android.view.MotionEvent.ACTION_CANCEL:
                            view.setPressed(false);
                            main.removeCallbacks(longPress);
                            break;
                        default:
                            break;
                    }
                    return true;
                }
            });
        }
    }
    private static final int SKIP_TAG = 0x7f7a0006;

    /** Station suivante de la liste (favoris ou toutes) ; liste vide : recherche d'origine. */
    private static void skip(Activity a, boolean forward) {
        if (scan != null) scan.stop(false, "station suivante");
        Object storage = storage(a);
        int band = shownBand(a);
        if (storage == null || band < 0) return;
        Object st = Stations.next(a, storage, band, forward);
        if (st != null) tune(st, band == 4);
        else seekNext(a, band, forward);
    }

    /** Recherche d'origine : station reçue suivante (FM / AM), station DAB+ valide suivante. */
    private static void seekNext(Activity a, int band, boolean forward) {
        if (scan != null) scan.stop(false, "recherche");
        try {
            if (band == 4) {
                Object st = call(storage(a), forward ? "getDabNextValidStation" : "getDabPreValidStation");
                if (st != null) tune(st, true);
                return;
            }
            Object rm = radioManager;
            if (rm != null) rm.getClass().getMethod(forward ? "seekForward" : "seekBackward").invoke(rm);
            main.postDelayed(tick, 1500);
        } catch (Throwable t) {
            Log.w(TAG, "recherche : " + t);
        }
    }

    /**
     * Glissé horizontal sur le lecteur (image DAB+ ou fréquence FM / AM) : vers la gauche, station suivante ; vers la
     * droite, précédente. Les touchers passent par la fenêtre : on les observe sans gêner les vues, et un glissé
     * reconnu est annulé pour elles (pas de clic sur un bouton où le doigt s'est posé).
     */
    private static void watchSwipe(final Activity a) {
        final android.view.Window w = a.getWindow();
        final android.view.Window.Callback orig = w.getCallback();
        if (orig == null || java.lang.reflect.Proxy.isProxyClass(orig.getClass())) return;
        final float[] down = new float[2];
        final long[] downAt = {0};
        final boolean[] tracking = {false};
        Object proxy = java.lang.reflect.Proxy.newProxyInstance(RadioDash.class.getClassLoader(),
                new Class<?>[]{android.view.Window.Callback.class}, new java.lang.reflect.InvocationHandler() {
                    @Override public Object invoke(Object p, Method m, Object[] args) throws Throwable {
                        if ("dispatchTouchEvent".equals(m.getName()) && args != null && args.length == 1
                                && args[0] instanceof android.view.MotionEvent) {
                            android.view.MotionEvent e = (android.view.MotionEvent) args[0];
                            boolean swiped = false;
                            try { swiped = swipe(a, e, down, downAt, tracking); } catch (Throwable t) { Log.w(TAG, "glissé : " + t); }
                            if (swiped) {
                                android.view.MotionEvent c = android.view.MotionEvent.obtain(e);
                                c.setAction(android.view.MotionEvent.ACTION_CANCEL);
                                try { orig.dispatchTouchEvent(c); } finally { c.recycle(); }
                                return true;
                            }
                        }
                        try { return m.invoke(orig, args); }
                        catch (java.lang.reflect.InvocationTargetException ex) { throw ex.getCause(); }
                    }
                });
        w.setCallback((android.view.Window.Callback) proxy);
    }

    private static boolean swipe(Activity a, android.view.MotionEvent e, float[] down, long[] downAt, boolean[] tracking) {
        switch (e.getActionMasked()) {
            case android.view.MotionEvent.ACTION_DOWN:
                View decor = a.getWindow().getDecorView();
                tracking[0] = inside(byName(a, "fragment_container"), e) && !inside(byName(a, "fragment_container_card"), e)
                        && !inside(decor.findViewWithTag(STRIP_TAG), e);
                down[0] = e.getRawX(); down[1] = e.getRawY();
                downAt[0] = e.getEventTime();
                return false;
            case android.view.MotionEvent.ACTION_POINTER_DOWN:
            case android.view.MotionEvent.ACTION_CANCEL:
                tracking[0] = false;
                return false;
            case android.view.MotionEvent.ACTION_UP:
                if (!tracking[0]) return false;
                tracking[0] = false;
                float dx = e.getRawX() - down[0], dy = e.getRawY() - down[1];
                if (Math.abs(dx) < dp(a, 120) || Math.abs(dx) < 2 * Math.abs(dy) || e.getEventTime() - downAt[0] > 1200) return false;
                Log.i(TAG, "glissé : station " + (dx < 0 ? "suivante" : "précédente"));
                skip(a, dx < 0);
                return true;
            default:
                return false;
        }
    }

    private static boolean inside(View v, android.view.MotionEvent e) {
        if (v == null || !v.isShown() || v.getWidth() == 0) return false;
        int[] p = new int[2];
        v.getLocationOnScreen(p);
        float x = e.getRawX(), y = e.getRawY();
        return x >= p[0] && y >= p[1] && x < p[0] + v.getWidth() && y < p[1] + v.getHeight();
    }

    // ── Case de droite : favoris ou toutes les stations ──────────────────────

    /** Colonnes de cases : 3 sur la carte de 640 dp, davantage quand elle s'élargit (DAB+ immersif). */
    private static int COLUMNS = 3;
    private static String scrolledFor = "";

    /**
     * Case de droite (conteneur android:tag="rd_favs_grid") : les favoris de la bande en cours, ou toutes ses stations
     * quand ★ Favoris est éteint, avec leur image (DAB+) ou leur nom et fréquence (FM / AM). Toucher une case accorde
     * la station ; toucher son étoile ajoute ou retire le favori.
     */
    private static void renderFavorites(final Activity a) throws Exception {
        View root = a.getWindow().getDecorView().findViewWithTag("rd_favs_grid");
        if (!(root instanceof LinearLayout)) return;
        LinearLayout grid = (LinearLayout) root;
        if (grid.getWidth() <= 0) { main.postDelayed(tick, 250); return; }   // pas encore mis en page
        // Carte en train de s'élargir (lecteur carré) : on attend sa largeur finale, sinon 3 colonnes un instant
        View favCard = byName(a, "fragment_container_card");
        if (favCard != null && favCard.getLayoutParams() != null && favCard.getLayoutParams().width > 0
                && favCard.getWidth() != favCard.getLayoutParams().width) { main.postDelayed(tick, 50); return; }
        final Object storage = storage(a);
        if (storage == null) return;
        int shown = shownBand(a);
        final int band = shown < 0 ? 1 : shown;
        final boolean dab = band == 4;
        final boolean favOnly = Stations.favOnly(a);
        favsHeader(a, band, favOnly);
        // Réglage « Écoute » de l'en-tête : largeur d'une case, au-dessus de la dernière colonne
        View wait = a.getWindow().getDecorView().findViewWithTag("rd_scan_wait");
        if (wait != null && wait.getLayoutParams() != null) {
            int cols = Math.max(3, Math.round(grid.getWidth() / (float) dp(a, 215)));
            int w = (grid.getWidth() - 2 * dp(a, 5) * cols) / cols;
            if (wait.getLayoutParams().width != w) { wait.getLayoutParams().width = w; wait.requestLayout(); }
        }
        List<?> favs = Stations.favorites(storage, band);
        List<Object> list = favOnly ? (favs == null ? new ArrayList<Object>() : new ArrayList<Object>(favs)) : Stations.all(a, storage, band);
        long curDab = dab ? currentDabServiceId(a) : -1;
        int curFm = dab ? -1 : currentFmChannel(storage, band == 0 ? 0 : 1);
        boolean noStations = list.isEmpty() && (!favOnly || Stations.all(a, storage, band).isEmpty());
        String key = band + "|" + favOnly + "|" + noStations + "|" + signature(list, dab) + "|" + signature(favs, dab) + "|" + curDab + "|" + curFm
                + "|" + grid.getWidth() + "x" + ((View) grid.getParent()).getHeight() + (dab ? "|" + artStamp(a, list) : "|" + rdsStamp(a, list));
        if (key.equals(grid.getContentDescription())) return;   // rien n'a changé
        grid.setContentDescription(key);
        grid.removeAllViews();
        if (list.isEmpty()) {
            // Premier démarrage : la radio ne connaît encore aucune station, on dit où les chercher
            TextView empty = text(a, favOnly ? tr(noStations ? 15 : 6) : tr(14), 17, TITLE);
            empty.setPadding(dp(a, 10), dp(a, 6), dp(a, 10), 0);
            grid.addView(empty);
            finishFavorites(a, grid);
            return;
        }
        java.util.Set<String> favKeys = new java.util.HashSet<>();
        if (favs != null) for (Object f : favs) favKeys.add(String.valueOf(callQuiet(f, dab ? "getServiceId" : "getChannelNumber")));
        int gap = dp(a, 5);
        COLUMNS = Math.max(3, Math.round(grid.getWidth() / (float) dp(a, 215)));
        int tileW = (grid.getWidth() - 2 * gap * COLUMNS) / COLUMNS;
        // Exactement 3 rangées visibles avant de faire défiler : la case rapetisse si la hauteur manque
        // (marges, bords de la case, légende du nom en DAB)
        int logoSide = tileW - dp(a, 28);
        View scroll = (View) grid.getParent();
        int visible = scroll.getHeight() - scroll.getPaddingTop() - scroll.getPaddingBottom();
        if (visible > 0) {
            int label = 0;
            if (dab) {
                android.text.TextPaint tp = new android.text.TextPaint();
                tp.setTextSize(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 16, a.getResources().getDisplayMetrics()));
                Paint.FontMetricsInt fm = tp.getFontMetricsInt();
                label = fm.bottom - fm.top + dp(a, 6);
            }
            int fit = visible / 3 - 2 * gap - dp(a, 14) - label - 2;
            logoSide = Math.min(logoSide, fit);
        }
        LinearLayout row = null;
        View selectedRow = null;
        for (int i = 0; i < list.size(); i++) {
            if (i % COLUMNS == 0) {
                row = new LinearLayout(a);
                row.setOrientation(LinearLayout.HORIZONTAL);
                grid.addView(row, new LinearLayout.LayoutParams(-1, -2));
            }
            final Object st = list.get(i);
            boolean selected;
            String label;
            View face;
            if (dab) {
                long id = ((Number) call(st, "getServiceId")).longValue();
                selected = id == curDab;
                ImageView logo = new ImageView(a);
                logo.setScaleType(ImageView.ScaleType.CENTER_CROP);
                round(logo, dp(a, 12));
                Bitmap b = thumbDabArt(a, id);
                if (b != null) logo.setImageBitmap(b);
                else {
                    logo.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
                    logo.setPadding(dp(a, 24), dp(a, 24), dp(a, 24), dp(a, 24));
                    logo.setBackground(panel(a, BORDER, 12, Color.TRANSPARENT));
                    logo.setImageResource(a.getResources().getIdentifier("rd_ic_radio", "drawable", a.getPackageName()));
                }
                label = Stations.dabLabel(st);
                face = logo;
            } else {
                int ch = ((Number) call(st, "getChannelNumber")).intValue();
                selected = ch == curFm;
                label = Stations.name(a, st);
                // Pas d'image pour une station FM : vignette moins haute, nom RDS en grand et en blanc
                // au-dessus de la fréquence (la fréquence seule si aucun nom n'est reçu).
                String f = ch < 30000 ? ch + " kHz" : String.format(Locale.getDefault(), "%.1f MHz", ch / 1000f);
                LinearLayout card = new LinearLayout(a);
                card.setOrientation(LinearLayout.VERTICAL);
                card.setGravity(Gravity.CENTER);
                card.setPadding(dp(a, 10), dp(a, label.isEmpty() ? 44 : 12), dp(a, 10), dp(a, 12));   // haut : place de l'étoile
                if (!label.isEmpty()) {
                    // Fréquence en haut à gauche, à côté de l'étoile : le nom garde toute la hauteur, donc la même
                    // taille que la fréquence seule d'une station sans nom (réduite seulement s'il ne tient pas)
                    TextView small = text(a, f, 17, SUB);
                    small.setGravity(Gravity.CENTER_VERTICAL | Gravity.START);
                    small.setSingleLine(true);
                    small.setPadding(dp(a, 4), 0, dp(a, 40), 0);
                    card.addView(small, new LinearLayout.LayoutParams(-1, dp(a, 32)));
                }
                TextView big = text(a, label.isEmpty() ? f : label, 28, TEXT);
                big.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
                big.setGravity(Gravity.CENTER);
                big.setMaxLines(2);
                big.setEllipsize(android.text.TextUtils.TruncateAt.END);
                big.setAutoSizeTextTypeUniformWithConfiguration(15, 30, 1, TypedValue.COMPLEX_UNIT_SP);
                card.addView(big, new LinearLayout.LayoutParams(-1, 0, 1f));
                face = card;
                label = null;   // tout est sur la carte : pas de légende dessous
            }
            LinearLayout tile = new LinearLayout(a);
            tile.setOrientation(LinearLayout.VERTICAL);
            tile.setGravity(Gravity.CENTER_HORIZONTAL);
            tile.setPadding(dp(a, 8), dp(a, 8), dp(a, 8), dp(a, 6));
            tile.setBackground(panel(a, selected ? 0x262979FF : BUTTON, 16, selected ? ACTION : BORDER));
            tile.addView(face, new LinearLayout.LayoutParams(dab ? logoSide : tileW - dp(a, 16), logoSide));
            if (label != null) {
                TextView t = text(a, label, 16, selected ? TEXT : SUB);
                t.setTypeface(Typeface.create("sans-serif", Typeface.BOLD));   // DAB+ : nom en gras, plus lisible
                t.setSingleLine(true);
                t.setEllipsize(android.text.TextUtils.TruncateAt.END);
                t.setGravity(Gravity.CENTER);
                t.setPadding(0, dp(a, 6), 0, 0);
                tile.addView(t, new LinearLayout.LayoutParams(-1, -2));
            }
            tile.setClickable(true);
            tile.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {
                    if (scan != null) scan.stop(false, "station choisie");
                    tune(st, dab);
                }
            });
            // Étoile dans le coin haut droit, sur un rond sombre : la même en DAB+ (sur l'image), en FM et en AM
            final boolean on = favKeys.contains(String.valueOf(callQuiet(st, dab ? "getServiceId" : "getChannelNumber")));
            TextView star = text(a, "★", 24, on ? Palette.starColor() : 0xCCF2F2F2);
            star.setGravity(Gravity.CENTER);
            star.setIncludeFontPadding(false);
            star.setBackground(panel(a, 0x8C000000, 22, Color.TRANSPARENT));
            star.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {
                    Stations.setFavorite(storage, st, band, !on);
                    refreshGrid(a);
                    main.postDelayed(tick, 600);   // la radio enregistre le favori en tâche de fond
                }
            });
            FrameLayout cell = new FrameLayout(a);
            cell.addView(tile, new FrameLayout.LayoutParams(-1, -2));
            FrameLayout.LayoutParams slp = new FrameLayout.LayoutParams(dp(a, 44), dp(a, 44), Gravity.TOP | Gravity.END);
            slp.setMargins(0, dp(a, 12), dp(a, 12), 0);
            cell.addView(star, slp);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(tileW, -2);
            lp.setMargins(gap, gap, gap, gap);
            row.addView(cell, lp);
            if (selected) selectedRow = row;
        }
        // Dernière rangée complétée par des cases vides pour garder la largeur des colonnes
        for (int k = list.size(); k % COLUMNS != 0; k++) {
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(tileW, 1);
            lp.setMargins(gap, gap, gap, gap);
            row.addView(new View(a), lp);
        }
        finishFavorites(a, grid);
        alignWait(a);
        // Station changée (◀ ▶, volant, glissé) : la case de la station écoutée vient à l'écran
        String now = band + ":" + curDab + ":" + curFm + ":" + favOnly;
        if (selectedRow != null && scroll instanceof android.widget.ScrollView && !now.equals(scrolledFor)) {
            scrolledFor = now;
            final View sel = selectedRow;
            final android.widget.ScrollView sv = (android.widget.ScrollView) scroll;
            sv.post(new Runnable() {
                @Override public void run() {
                    int y = sv.getScrollY(), h = sv.getHeight() - sv.getPaddingTop() - sv.getPaddingBottom();
                    if (sel.getTop() < y) sv.smoothScrollTo(0, sel.getTop());
                    else if (sel.getBottom() > y + h) sv.smoothScrollTo(0, sel.getBottom() - h);
                }
            });
        }
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
    private static String rdsStamp(Context c, List<?> favs) {
        StringBuilder sb = new StringBuilder();
        if (favs != null) for (Object o : favs) sb.append(Stations.name(c, o)).append(',');
        return sb.toString();
    }

    // ── Nom RDS des favoris FM ────────────────────────────────────────────────
    // La radio SAIC enregistre le nom RDS d'un favori à chaque métadonnée reçue, mais juste après un
    // changement de fréquence elle peut recevoir le nom de la station d'avant et le garder (le 104,3
    // nommé comme le 101,9). Ici, un nom RDS apparu après l'accord, sur une fréquence écoutée depuis au
    // moins 6 s, remplace le nom enregistré du favori s'il est différent.
    private static int rdsChannel = -1;
    private static long rdsTunedAt, rdsSeenAt;
    private static String rdsLastPs = "";
    private static final long RDS_SETTLE_MS = 6000;

    private static void rdsFavoriteName(Activity a) {
        try {
            Object storage = storage(a);
            if (storage == null) return;
            keepFavoriteNames(a, storage);
            if (((Number) call(storage, "getStoredRadioBand")).intValue() != 1) { rdsChannel = -1; return; }
            long now = android.os.SystemClock.uptimeMillis();
            int ch = currentFmChannel(storage);
            Object rds = callQuiet(storage, "getRadioRds");
            Object psObj = rds == null ? null : callQuiet(rds, "getProgramService");
            String ps = psObj == null ? "" : psObj.toString().trim();
            if (ch != rdsChannel) {
                // Un nom déjà différent de celui de la station d'avant compte comme reçu après l'accord
                rdsSeenAt = ps.equals(rdsLastPs) ? 0 : now;
                rdsChannel = ch; rdsTunedAt = now; rdsLastPs = ps;
                return;
            }
            if (!ps.equals(rdsLastPs)) { rdsLastPs = ps; rdsSeenAt = now; }
            // Nom reçu après l'accord (pas un reste de la station d'avant), fréquence écoutée assez longtemps
            if (ps.length() < 2 || rdsSeenAt < rdsTunedAt || rdsSeenAt == 0 || now - rdsTunedAt < RDS_SETTLE_MS) return;
            Method forBand = storage.getClass().getMethod("getFavoriteForBand", int.class);
            List<?> favs = (List<?>) forBand.invoke(storage, 1);
            if (favs == null) return;
            Object mine = null;
            for (Object f : favs) {
                Object c = callQuiet(f, "getChannelNumber");
                if (!(c instanceof Number)) continue;
                if (((Number) c).intValue() == ch) { mine = f; continue; }
                // Nom déjà porté par un autre favori : sans doute un reste de cette station, on n'y touche pas
                Object r = callQuiet(f, "getRds");
                Object p = r == null ? null : callQuiet(r, "getProgramService");
                if (p != null && ps.equalsIgnoreCase(p.toString().trim())) return;
            }
            for (Object f : mine == null ? java.util.Collections.emptyList() : java.util.Collections.singletonList(mine)) {
                Object old = callQuiet(f, "getRds");
                Object oldPs = old == null ? null : callQuiet(old, "getProgramService");
                if (oldPs != null && ps.equals(oldPs.toString().trim())) return;
                // Nom effacé par la radio, et déjà gardé : affiché tel quel, rien à réécrire
                if ((oldPs == null || oldPs.toString().trim().isEmpty())
                        && ps.equals(a.getSharedPreferences("radio_dash", Context.MODE_PRIVATE).getString(NAME_KEY + ch, ""))) return;
                Class<?> rs = Class.forName("com.android.car.radio.service.RadioStation");
                Class<?> rdsCls = Class.forName("com.android.car.radio.service.RadioRds");
                // Objet RDS à nous : celui de la radio change pendant l'écriture en tâche de fond
                Object own = rdsCls.getConstructor(String.class, String.class, String.class).newInstance(ps, null, null);
                Object station = rs.getConstructor(int.class, int.class, int.class, rdsCls).newInstance(ch, 0, 1, own);
                storage.getClass().getMethod("storeFavorite", rs).invoke(storage, station);
                a.getSharedPreferences("radio_dash", Context.MODE_PRIVATE).edit().putString(NAME_KEY + ch, ps).apply();
                Log.i(TAG, "favori " + ch + " : nom RDS « " + oldPs + " » remplacé par « " + ps + " »");
                return;
            }
        } catch (Throwable t) {
            Log.w(TAG, "nom RDS du favori : " + t);
        }
    }

    /**
     * À chaque nouvelle liste de stations (balayage de fond), la radio SAIC réécrit le nom de tous les favoris FM
     * d'après cette liste (RadioStorage.updateFavoriteStationNameForFM) : un favori absent de la liste, ou listé sans
     * RDS, perd son nom. On garde ici le dernier nom connu de chaque fréquence, et les cases l'affichent quand la
     * radio n'en a plus (Stations.name). On ne le réécrit plus dans la base : la radio l'effaçait aussitôt, soit une
     * écriture toutes les 40 s environ.
     */
    private static void keepFavoriteNames(Activity a, Object storage) {
        try {
            List<?> favs = (List<?>) storage.getClass().getMethod("getFavoriteForBand", int.class).invoke(storage, 1);
            if (favs == null || favs.isEmpty()) return;
            for (Object f : favs) {
                Object c = callQuiet(f, "getChannelNumber");
                if (!(c instanceof Number)) continue;
                Object r = callQuiet(f, "getRds");
                Object p = r == null ? null : callQuiet(r, "getProgramService");
                if (p != null) Stations.rememberName(a, ((Number) c).intValue(), p.toString());
            }
        } catch (Throwable t) {
            Log.w(TAG, "noms des favoris : " + t);
        }
    }
    private static final String NAME_KEY = "rd_fm_name_";

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
                @Override public void tune(int khz) { tuneAmFm(khz, amBand); }
            });
            box.addView(dial, new ViewGroup.LayoutParams(-1, -1));
        }
        Object storage = storage(a);
        if (storage == null) return;
        int band = shownBand(a);
        if (band == 4) return;   // DAB : le bandeau est caché
        amBand = band == 0;
        dial.setAm(amBand);
        dial.setValue(currentFmChannel(storage, amBand ? 0 : 1));
        List<Integer> chans = new ArrayList<>();
        Method forBand = storage.getClass().getMethod("getFavoriteForBand", int.class);
        List<?> favs = (List<?>) forBand.invoke(storage, amBand ? 0 : 1);
        if (favs != null) for (Object f : favs) {
            Object ch = callQuiet(f, "getChannelNumber");
            if (ch instanceof Number) chans.add(((Number) ch).intValue());
        }
        dial.setFavorites(chans);
    }

    private static boolean amBand;

    /** Accord direct depuis le cadran : bande 0 = AM, 1 = FM. */
    private static void tuneAmFm(int khz, boolean am) {
        try {
            Class<?> rs = Class.forName("com.android.car.radio.service.RadioStation");
            Class<?> rds = Class.forName("com.android.car.radio.service.RadioRds");
            Object station = rs.getConstructor(int.class, int.class, int.class, rds).newInstance(khz, 0, am ? 0 : 1, null);
            tune(station, false);
        } catch (Throwable t) {
            Log.w(TAG, "accord " + (am ? "AM " : "FM ") + khz + " : " + t);
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

    /** Fréquence en cours de la bande FM ou AM affichée (kHz). La radio la garde par bande : 0 = AM, 1 = FM. */
    private static int currentFmChannel(Object storage, int band) {
        try {
            Method m = storage.getClass().getMethod("getStoredRadioChannel", int.class);
            return ((Number) m.invoke(storage, band)).intValue();
        } catch (Throwable t) {
            return -1;
        }
    }
    private static int currentFmChannel(Object storage) {
        Object ch = callQuiet(storage, "getStoredRadioChannel");
        if (ch instanceof Number) return ((Number) ch).intValue();
        try {
            int band = 1;
            try { band = ((Number) call(storage, "getStoredRadioBand")).intValue() == 0 ? 0 : 1; } catch (Throwable ignored) {}
            Method m = storage.getClass().getMethod("getStoredRadioChannel", int.class);
            return ((Number) m.invoke(storage, band)).intValue();
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

    /** Image DAB+ réduite pour les cases, gardée en mémoire tant que le fichier ne change pas (liste de toutes les stations). */
    private static Bitmap thumbDabArt(Context c, long serviceId) {
        if (serviceId < 0) return null;
        File f = new File(c.getFilesDir(), "dab_" + serviceId + ".jpg");
        long m = f.lastModified();
        if (m == 0) return null;
        Object[] e = thumbs.get(serviceId);
        if (e != null && (Long) e[0] == m) return (Bitmap) e[1];
        BitmapFactory.Options o = new BitmapFactory.Options();
        o.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(f.getPath(), o);
        int sample = 1;
        while (o.outWidth / (sample * 2) >= 240 && o.outHeight / (sample * 2) >= 240) sample *= 2;
        o = new BitmapFactory.Options();
        o.inSampleSize = sample;
        Bitmap b = BitmapFactory.decodeFile(f.getPath(), o);
        if (b != null) thumbs.put(serviceId, new Object[]{m, b});
        return b;
    }
    private static final android.util.LruCache<Long, Object[]> thumbs = new android.util.LruCache<Long, Object[]>(24 * 1024 * 1024) {
        @Override protected int sizeOf(Long k, Object[] v) { return ((Bitmap) v[1]).getByteCount(); }
    };

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
