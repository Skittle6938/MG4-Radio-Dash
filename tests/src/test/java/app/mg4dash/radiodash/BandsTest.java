package app.mg4dash.radiodash;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import com.saicmotor.radio.model.RadioStorage;
import com.saicmotor.radio.utils.FeatureUtil;

import org.junit.After;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/** Bandes de la radio et passage direct à une bande depuis MG4Dash (__ACTION_SET_BAND__, MG4Dash #80). */
public class BandsTest {

    /** Service radio simulé : changeSource(bande, suivante) passe à la bande qui suit celle donnée. */
    static class Service extends FakeContext {
        final List<Integer> calls = new ArrayList<>();
        @SuppressWarnings("unused")
        private void changeSource(int band, boolean next) { calls.add(band); }
    }

    @After public void tearDown() {
        FeatureUtil.bands = null;
        RadioStorage.band = 1;
    }

    @Test public void bandsFromTheCarConfigurationWithoutAm() {
        FeatureUtil.bands = Arrays.asList(4, 1, 0);
        assertEquals(Arrays.asList(4, 1), Bands.radioBands());
    }

    @Test public void noDuplicateBands() {
        FeatureUtil.bands = Arrays.asList(1, 4, 1);
        assertEquals(Arrays.asList(1, 4), Bands.radioBands());
    }

    @Test public void emptyConfigurationOnSwi68GivesDabAndFm() {
        FeatureUtil.bands = null;
        assertEquals(Arrays.asList(4, 1), Bands.radioBands());
        FeatureUtil.bands = new ArrayList<>();
        assertEquals(Arrays.asList(4, 1), Bands.radioBands());
    }

    @Test public void onlyAmConfiguredStillGivesDabAndFm() {
        FeatureUtil.bands = Arrays.asList(0);
        assertEquals(Arrays.asList(4, 1), Bands.radioBands());
    }

    @Test public void amIsOffWithoutTheMg4DashOption() {
        assertFalse(Bands.amAllowed(null));
    }

    @Test public void setBandGivesChangeSourceTheBandBefore() {
        FeatureUtil.bands = Arrays.asList(4, 1);
        Service s = new Service();
        RadioStorage.band = 1;
        Bands.setBand(s, "DAB");
        assertEquals(Arrays.asList(1), s.calls);   // FM, then next = DAB

        s.calls.clear();
        RadioStorage.band = 4;
        Bands.setBand(s, "fm");
        assertEquals(Arrays.asList(4), s.calls);
    }

    @Test public void setBandDoesNothingWhenAlreadyThereOrUnknown() {
        FeatureUtil.bands = Arrays.asList(4, 1);
        Service s = new Service();
        RadioStorage.band = 4;
        Bands.setBand(s, "DAB");
        Bands.setBand(s, "LW");
        Bands.setBand(s, null);
        Bands.setBand(s, "AM");   // no AM on this radio
        assertEquals(new ArrayList<Integer>(), s.calls);
    }

    /** Infos DAB+ reçues en fond pendant la FM : la session média ne repasse pas en DAB+ (MG4Dash #80). */
    @Test public void dabMetadataOnlyWhenTheRadioIsOnDab() {
        Service s = new Service();
        RadioStorage.band = 1;
        assertTrue(Bands.notOnDab(s));
        RadioStorage.band = 0;
        assertTrue(Bands.notOnDab(s));
        RadioStorage.band = 4;
        assertFalse(Bands.notOnDab(s));
    }

    @Test public void dabMetadataNotBlockedWhenTheBandIsUnreadable() {
        assertFalse(Bands.notOnDab(null));
    }
}
