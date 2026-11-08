package app.mg4dash.radiodash;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

import java.lang.reflect.Field;

/**
 * Focus audio de la radio (MG4Dash #99) : sur les anciens firmwares, le son rendu après une perte définitive (CarPlay)
 * ne relance pas la radio ; après une perte temporaire (appel, guidage, Siri), elle reprend comme avant.
 * Le firmware est fixé directement (sur la voiture : présence du lanceur com.saicmotor.hmi.launcher).
 */
public class FocusTest {
    private static final int GAIN = 1, LOSS = -1, LOSS_TRANSIENT = -2, LOSS_DUCK = -3;
    private final FakeContext c = new FakeContext();

    private static void set(String name, Object v) throws Exception {
        Field f = Focus.class.getDeclaredField(name);
        f.setAccessible(true);
        f.set(null, v);
    }

    private static void firmware(boolean old) throws Exception { set("legacy", old); }

    @Before public void setUp() throws Exception { set("lostForGood", false); }

    @Test public void newFirmwareKeepsTheOriginalBehaviour() throws Exception {
        firmware(false);
        assertFalse(Focus.skip(c, LOSS));
        assertFalse(Focus.skip(c, GAIN));
        assertFalse(Focus.skip(c, LOSS_TRANSIENT));
        assertFalse(Focus.skip(c, GAIN));
    }

    @Test public void oldFirmwareWaitsAfterALossForGood() throws Exception {
        firmware(true);
        assertFalse("la perte elle-même suit le code d'origine", Focus.skip(c, LOSS));
        assertTrue("CarPlay rend le son : la radio ne repart pas", Focus.skip(c, GAIN));
        // Une seule fois : le gain suivant fait comme avant
        assertFalse(Focus.skip(c, GAIN));
    }

    @Test public void oldFirmwareResumesAfterATemporaryLoss() throws Exception {
        firmware(true);
        assertFalse(Focus.skip(c, LOSS_TRANSIENT));
        assertFalse(Focus.skip(c, GAIN));
        assertFalse(Focus.skip(c, LOSS_DUCK));
        assertFalse(Focus.skip(c, GAIN));
    }

    @Test public void temporaryLossAfterALossForGoodResumes() throws Exception {
        firmware(true);
        Focus.skip(c, LOSS);
        Focus.skip(c, LOSS_TRANSIENT);
        assertFalse(Focus.skip(c, GAIN));
    }

    @Test public void otherChangesAreLeftAlone() throws Exception {
        firmware(true);
        Focus.skip(c, LOSS);
        assertFalse(Focus.skip(c, 0));
        assertFalse(Focus.skip(c, 2));
        // La perte définitive reste mémorisée
        assertTrue(Focus.skip(c, GAIN));
    }

    @Test public void firmwareUnknownWithoutContextKeepsTheOriginalBehaviour() throws Exception {
        set("legacy", null);
        // Pas de gestionnaire de paquets : nouveau firmware, comme d'origine
        assertFalse(Focus.skip(c, LOSS));
        assertFalse(Focus.skip(c, GAIN));
        set("legacy", null);
    }
}
