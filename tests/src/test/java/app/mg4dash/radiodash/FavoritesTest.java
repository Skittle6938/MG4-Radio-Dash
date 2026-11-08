package app.mg4dash.radiodash;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import com.android.car.radio.service.RadioStation;
import com.saicmotor.radio.utils.RadioSharedPreference;

import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/** Suivant / précédent par la session média : volant, accueil, widget MG4Dash (Favorites). */
public class FavoritesTest {
    /** RadioService simulé : champs lus par réflexion, accord par tuneRadioTune. */
    public static class Service extends FakeContext {
        @SuppressWarnings("unused") private final Object mRadioStorage;
        @SuppressWarnings("unused") private final int mCurrentRadioBand;
        final List<Integer> tuned = new ArrayList<>();
        Service(Object storage, int band) { mRadioStorage = storage; mCurrentRadioBand = band; }
        public void tuneRadioTune(RadioStation s) { tuned.add(s.getChannelNumber()); }
    }

    /** RadioService$6 : classe interne, l'instance englobante est dans this$0. */
    public static class Listener {
        @SuppressWarnings("unused") final Object this$0;
        Listener(Object outer) { this$0 = outer; }
    }

    private FakeStorage st;

    @Before public void setUp() {
        st = new FakeStorage();
        RadioSharedPreference.wasPlaying = null;
    }

    @Test public void nextDabFollowsTheFavourites() {
        FakeStorage.Dab a = new FakeStorage.Dab(1, "A"), b = new FakeStorage.Dab(2, "B");
        st.dabFavorites.addAll(Arrays.asList(a, b));
        st.currentDab = a;
        st.nextValid = new FakeStorage.Dab(99, "origine");
        assertSame(b, Favorites.nextDab(st, true));
        assertSame(b, Favorites.nextDab(st, false));
    }

    @Test public void nextDabWithoutFavouritesKeepsTheRadiosNextValidStation() {
        st.nextValid = new FakeStorage.Dab(10, "suivante");
        st.previousValid = new FakeStorage.Dab(11, "précédente");
        assertSame(st.nextValid, Favorites.nextDab(st, true));
        assertSame(st.previousValid, Favorites.nextDab(st, false));
    }

    @Test public void nextDabOnAnUnexpectedStorageGivesNothing() {
        assertNull(Favorites.nextDab(new Object(), true));
    }

    @Test public void skipFmTunesTheNextFavourite() {
        st.fmFavorites.addAll(Arrays.asList(RadioStation.fm(88600), RadioStation.fm(95000)));
        st.fmChannel = 95000;
        Service s = new Service(st, 1);
        assertTrue(Favorites.skipFm(new Listener(s), true));
        assertEquals(Arrays.asList(88600), s.tuned);
    }

    @Test public void skipFmOnTheAmBandUsesTheAmFavourites() {
        st.amFavorites.addAll(Arrays.asList(new RadioStation(531, 0, 0, null), new RadioStation(1188, 0, 0, null)));
        st.amChannel = 531;
        st.fmChannel = 1188;
        Service s = new Service(st, 0);
        assertTrue(Favorites.skipFm(new Listener(s), false));
        assertEquals(Arrays.asList(1188), s.tuned);
    }

    @Test public void skipFmWithoutFavouritesLeavesTheStockSearch() {
        Service s = new Service(st, 1);
        assertFalse(Favorites.skipFm(new Listener(s), true));
        assertTrue(s.tuned.isEmpty());
        assertFalse("écouteur inattendu : pas d'exception", Favorites.skipFm(new Object(), true));
    }

    @Test public void playFromTheSessionRemembersAutoResume() {
        Favorites.wasPlaying(new Listener(new FakeContext()), true);
        assertEquals(Boolean.TRUE, RadioSharedPreference.wasPlaying);
        Favorites.wasPlaying(new Object(), false);   // écouteur inattendu : ignoré
        assertEquals(Boolean.TRUE, RadioSharedPreference.wasPlaying);
    }
}
