package app.mg4dash.radiodash;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import com.android.car.radio.service.RadioStation;

import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

/** Liste des stations de la case de droite et passage d'une station à l'autre (volant, ◀ ▶, MG4Dash). */
public class StationsTest {
    private FakeContext c;
    private FakeStorage st;

    @Before public void setUp() {
        c = new FakeContext();
        st = new FakeStorage();
    }

    private static List<Integer> channels(List<Object> list) throws Exception {
        List<Integer> out = new ArrayList<>();
        for (Object o : list) out.add(Stations.channel(o));
        return out;
    }

    private static List<String> names(List<Object> list) {
        List<String> out = new ArrayList<>();
        for (Object o : list) out.add(Stations.dabLabel(o));
        return out;
    }

    // ── Mode ★ Favoris ──

    @Test public void favouritesModeByDefault() {
        assertTrue(Stations.favOnly(c));
        assertTrue(Stations.favOnly(null));
        Stations.setFavOnly(c, false);
        assertFalse(Stations.favOnly(c));
    }

    @Test public void favouritesModeCyclesTheFavouritesInTheirOrder() throws Exception {
        st.fmFavorites.addAll(Arrays.asList(RadioStation.fm(105500), RadioStation.fm(89100)));
        st.fmPreScanned.add(RadioStation.fm(97300));
        assertEquals(Arrays.asList(105500, 89100), channels(Stations.cycle(c, st, 1)));
    }

    @Test public void noStorageNoList() {
        assertTrue(Stations.all(c, null, 1).isEmpty());
        assertNull(Stations.next(c, null, 1, true));
    }

    // ── Toutes les stations, FM ──

    @Test public void allFmStationsByFrequencyWithFavouritesAndNoDuplicates() throws Exception {
        Stations.setFavOnly(c, false);
        st.fmPreScanned.addAll(Arrays.asList(RadioStation.fm(105500), RadioStation.fm(89100), RadioStation.fm(97300)));
        st.fmFavorites.addAll(Arrays.asList(RadioStation.fm(97300), RadioStation.fm(101100)));
        assertEquals(Arrays.asList(89100, 97300, 101100, 105500), channels(Stations.cycle(c, st, 1)));
    }

    @Test public void outOfBandFrequenciesAreLeftOut() throws Exception {
        st.fmPreScanned.addAll(Arrays.asList(RadioStation.fm(87400), RadioStation.fm(87500), RadioStation.fm(108000), RadioStation.fm(108100), RadioStation.fm(0)));
        assertEquals(Arrays.asList(87500, 108000), channels(Stations.all(c, st, 1)));
    }

    @Test public void stationsFoundByAScanAreAddedWithTheirLastName() throws Exception {
        Stations.rememberName(c, 99900, "  NOVA ");
        Stations.found(c, 1, 99900);
        List<Object> all = Stations.all(c, st, 1);
        assertEquals(Arrays.asList(99900), channels(all));
        assertEquals("NOVA", Stations.name(c, all.get(0)));
    }

    @Test public void aCompleteScanHidesStationsNotFoundAgainButNeverFavourites() throws Exception {
        st.fmPreScanned.addAll(Arrays.asList(RadioStation.fm(89100), RadioStation.fm(97300)));
        st.fmFavorites.add(RadioStation.fm(104000));
        Stations.found(c, 1, 101100);
        Stations.scanComplete(c, st, 1, new HashSet<>(Arrays.asList(97300, 102500)));
        assertEquals(Arrays.asList(97300, 102500, 104000), channels(Stations.all(c, st, 1)));
    }

    @Test public void aStationFoundAgainIsShownAgain() throws Exception {
        st.fmPreScanned.add(RadioStation.fm(89100));
        Stations.scanComplete(c, st, 1, new HashSet<Integer>());
        assertTrue(Stations.all(c, st, 1).isEmpty());
        Stations.found(c, 1, 89100);
        assertEquals(Arrays.asList(89100), channels(Stations.all(c, st, 1)));
    }

    @Test public void amAndFmListsAreKeptApart() throws Exception {
        Stations.found(c, 0, 1404);
        Stations.found(c, 1, 99900);
        st.amPreScanned.add(RadioStation.fm(5000));   // hors de la bande AM
        assertEquals(Arrays.asList(99900), channels(Stations.all(c, st, 1)));
        assertEquals(Arrays.asList(1404), channels(Stations.all(c, st, 0)));
    }

    // ── Station suivante / précédente ──

    @Test public void nextAndPreviousWrapAround() throws Exception {
        st.fmFavorites.addAll(Arrays.asList(RadioStation.fm(89100), RadioStation.fm(97300), RadioStation.fm(105500)));
        st.fmChannel = 105500;
        assertEquals(89100, Stations.channel(Stations.next(c, st, 1, true)));
        st.fmChannel = 89100;
        assertEquals(105500, Stations.channel(Stations.next(c, st, 1, false)));
        assertEquals(97300, Stations.channel(Stations.next(c, st, 1, true)));
    }

    @Test public void offTheFavouritesListStartsAtItsEnds() throws Exception {
        st.fmFavorites.addAll(Arrays.asList(RadioStation.fm(97300), RadioStation.fm(89100)));
        st.fmChannel = 100000;
        assertEquals(97300, Stations.channel(Stations.next(c, st, 1, true)));
        assertEquals(89100, Stations.channel(Stations.next(c, st, 1, false)));
    }

    @Test public void offTheFullListGoesToTheNearestInTheDirectionAsked() throws Exception {
        Stations.setFavOnly(c, false);
        st.fmPreScanned.addAll(Arrays.asList(RadioStation.fm(89100), RadioStation.fm(97300), RadioStation.fm(105500)));
        st.fmChannel = 100000;
        assertEquals(105500, Stations.channel(Stations.next(c, st, 1, true)));
        assertEquals(97300, Stations.channel(Stations.next(c, st, 1, false)));
        st.fmChannel = 107000;
        assertEquals(89100, Stations.channel(Stations.next(c, st, 1, true)));
        st.fmChannel = 88000;
        assertEquals(105500, Stations.channel(Stations.next(c, st, 1, false)));
    }

    @Test public void emptyListLeavesTheStockSearch() {
        st.fmChannel = 97300;
        assertNull(Stations.next(c, st, 1, true));
    }

    // ── DAB+ ──

    @Test public void allDabStationsByNameWithFavouritesOnce() {
        Stations.setFavOnly(c, false);
        st.dabStations.addAll(Arrays.asList(new FakeStorage.Dab(3, "radio 3"), new FakeStorage.Dab(1, "Alpha"), new FakeStorage.Dab(2, "Bravo")));
        st.dabFavorites.addAll(Arrays.asList(new FakeStorage.Dab(2, "Bravo"), new FakeStorage.Dab(9, "Zulu")));
        assertEquals(Arrays.asList("Alpha", "Bravo", "radio 3", "Zulu"), names(Stations.cycle(c, st, 4)));
    }

    @Test public void dabLabelFallsBackOnTheMultiplex() {
        assertEquals("Mux A", Stations.dabLabel(new FakeStorage.Dab(1, " ", "Mux A")));
        assertEquals("DAB", Stations.dabLabel(new FakeStorage.Dab(1, null, null)));
        assertEquals("FIP", Stations.dabLabel(new FakeStorage.Dab(1, " FIP ", "Mux")));
    }

    @Test public void nextDabFavouriteFollowsTheServiceId() {
        FakeStorage.Dab a = new FakeStorage.Dab(1, "A"), b = new FakeStorage.Dab(2, "B");
        st.dabFavorites.addAll(Arrays.asList(a, b));
        st.currentDab = new FakeStorage.Dab(2, "B (other copy)");
        assertSame(a, Stations.next(c, st, 4, true));
        st.currentDab = null;
        assertSame(a, Stations.next(c, st, 4, true));
        assertSame(b, Stations.next(c, st, 4, false));
    }

    // ── Favoris ──

    @Test public void favouriteAddedAndRemovedThroughTheRadio() throws Exception {
        RadioStation playing = RadioStation.fm(97300);
        Stations.setFavorite(st, playing, 1, true);
        assertEquals(1, st.fmFavorites.size());
        // Retrait avec une autre instance de la même fréquence : c'est le favori enregistré qui part
        Stations.setFavorite(st, RadioStation.fm(97300), 1, false);
        assertTrue(st.fmFavorites.isEmpty());

        FakeStorage.Dab d = new FakeStorage.Dab(7, "FIP");
        Stations.setFavorite(st, d, 4, true);
        assertSame(d, Stations.favoriteOf(st, new FakeStorage.Dab(7, "FIP"), 4));
        Stations.setFavorite(st, new FakeStorage.Dab(7, "FIP"), 4, false);
        assertTrue(st.dabFavorites.isEmpty());
    }

    // ── Noms RDS ──

    @Test public void rdsNameOrTheLastOneHeardOnThatFrequency() {
        assertEquals("FIP", Stations.name(c, RadioStation.fm(105100, " FIP ")));
        assertEquals("", Stations.name(c, RadioStation.fm(105100)));
        Stations.rememberName(c, 105100, "FIP");
        assertEquals("FIP", Stations.name(c, RadioStation.fm(105100)));
        assertEquals("FIP", Stations.name(c, RadioStation.fm(105100, "F")));   // un seul caractère : pas un nom
    }

    @Test public void shortNamesAreNotRemembered() {
        Stations.rememberName(c, 105100, "X");
        Stations.rememberName(c, 105100, null);
        assertEquals("", Stations.name(c, RadioStation.fm(105100)));
    }

    @Test public void storedChannelListsSurviveJunk() {
        c.getSharedPreferences(Stations.PREFS, 0).edit().putString("rd_fm_found", "89100, x,,97300,89100").apply();
        assertEquals(new java.util.TreeSet<>(Arrays.asList(89100, 97300)), Stations.channels(c, "rd_fm_found"));
    }
}
