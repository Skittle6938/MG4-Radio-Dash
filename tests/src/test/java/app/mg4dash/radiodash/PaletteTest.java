package app.mg4dash.radiodash;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

/**
 * Thème de MG4Dash appliqué à la radio (Palette) : réglage Settings.Global mg4dash_theme =
 * "fond,boutons,clair,barre verticale,lecteur,barre large,barre à droite,AM".
 */
public class PaletteTest {
    private static final int BLUE = 0xFF2979FF, CYAN = 0xFF00D2FF, TOP = 0xFF0B0F17, RADIO_BG = 0xFF141925, WHITE = 0xFFFFFFFF;

    @Before public void setUp() {
        Statics.set(Palette.class, "loaded", null);
        Palette.apply("0,0");
    }

    @Test public void originalThemeChangesNothing() {
        assertEquals(BLUE, Palette.map(BLUE));
        assertEquals(TOP, Palette.map(TOP));
        assertEquals(BLUE, Palette.accent());
        assertFalse(Palette.isLight());
    }

    @Test public void missingSettingIsTheOriginalTheme() {
        Palette.apply("2,2");
        Palette.apply(null);
        assertEquals(BLUE, Palette.map(BLUE));
    }

    @Test public void sameValueTwiceIsNotAChange() {
        assertTrue(Palette.apply("2,2"));
        assertFalse(Palette.apply("2,2"));
        assertTrue(Palette.apply("2,3"));
    }

    @Test public void darkThemeMapsBackgroundsAndButtons() {
        Palette.apply("2,2");   // fond graphite, boutons rouges
        assertEquals(0xFFE53935, Palette.map(BLUE));
        assertEquals(0xFFFF8A80, Palette.map(CYAN));
        assertEquals(0xFF15171A, Palette.map(TOP));
        assertEquals("fond propre à la radio", 0xFF22252A, Palette.map(RADIO_BG));
        assertEquals("bouton appuyé : action assombrie à 70 %", 0xFFA02725, Palette.map(0xFF1A5CCC));
        assertEquals("textes blancs en mode sombre", WHITE, Palette.map(WHITE));
        assertEquals("couleur inconnue inchangée", 0xFF123456, Palette.map(0xFF123456));
        assertEquals(0xFFE53935, Palette.starColor());
    }

    @Test public void alphaIsKept() {
        Palette.apply("0,3");
        assertEquals(0x4000C853, Palette.map(0x402979FF));
        assertEquals(0x0000C853, Palette.map(0x002979FF));
    }

    @Test public void lightThemeDarkensTexts() {
        Palette.apply("1,3,1");
        assertTrue(Palette.isLight());
        assertEquals(0xFF141922, Palette.map(WHITE));
        assertEquals(0xFF00A142, Palette.map(BLUE));
        assertEquals(0xFFEDEDED, Palette.map(TOP));
        assertEquals(0xFF4A5466, Palette.map(0xFFA0AEC0));
    }

    @Test public void outOfRangeIndexesAreClamped() {
        Palette.apply("99,-5");
        assertEquals("dernier fond", 0xFF13090C, Palette.map(TOP));
        assertEquals("premiers boutons", BLUE, Palette.map(BLUE));
    }

    @Test public void unreadableValueKeepsTheOriginalColours() {
        Palette.apply("2,2");
        Palette.apply("abc");
        assertEquals(BLUE, Palette.map(BLUE));
        assertFalse(Palette.isLight());
    }

    @Test public void layoutOptionsFollowTheirFields() {
        Palette.apply("0,0,0,1,1,1,1");
        assertTrue(Palette.verticalDock);
        assertEquals(1, Palette.mediaStyle);
        assertTrue(Palette.wideBar);
        assertTrue(Palette.rightBar);
        Palette.apply("0,0,0,0,0,0,0");
        assertFalse(Palette.verticalDock);
        assertEquals(0, Palette.mediaStyle);
        assertFalse(Palette.wideBar);
        assertFalse(Palette.rightBar);
        Palette.apply("0,0,0,1");
        Palette.apply("0,0");
        assertFalse("champs absents : éteints", Palette.verticalDock);
    }

    @Test public void amOptionIsTheEighthField() {
        assertFalse(Bands.amOption(null));
        assertFalse(Bands.amOption("0,0"));
        assertFalse(Bands.amOption("0,0,0,0,0,0,0,0"));
        assertFalse("7e champ = barre à droite", Bands.amOption("0,0,0,0,0,0,1"));
        assertTrue(Bands.amOption("0,0,0,0,0,0,0,1"));
        assertTrue(Bands.amOption("2,3,1,0,0,0,0, 1 "));
    }
}
