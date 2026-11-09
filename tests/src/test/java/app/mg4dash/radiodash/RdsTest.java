package app.mg4dash.radiodash;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import org.junit.Test;

/** Lettres accentuées du jeu de caractères RDS (EBU Latin), rendues octet par octet par le tuner. */
public class RdsTest {
    @Test public void tableHasOneCharacterPerCode() {
        assertEquals(128, Rds.EBU_HIGH.length());
    }

    @Test public void ebuAccentsBecomeUnicode() {
        // « Café à Noël, ça été » tel que rendu par le tuner : é = 0x82, à = 0x81, ë = 0x93, ç = 0x9B
        String raw = "Caf\u0082 \u0081 No\u0093l, \u009Ba \u0082t\u0082";
        assertEquals("Café à Noël, ça été", Rds.decode(raw));
        assertEquals("\u00e9\u00c8\u20ac", Rds.decode("\u0082\u00C3\u00A9"));
    }

    @Test public void correctTextIsLeftAlone() {
        assertEquals("Café à Noël", Rds.decode("Café à Noël"));
        assertEquals("RTL2 - Hits", Rds.decode("RTL2 - Hits"));
        assertEquals("", Rds.decode(""));
        assertNull(Rds.decode(null));
    }
}
