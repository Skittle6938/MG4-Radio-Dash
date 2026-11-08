package app.mg4dash.radiodash;

import com.android.car.radio.service.RadioStation;

import java.util.ArrayList;
import java.util.List;

/** Simulation de RadioStorage, la base de la radio SAIC, lue par réflexion par Stations. */
public class FakeStorage {
    public final List<RadioStation> fmFavorites = new ArrayList<>(), amFavorites = new ArrayList<>();
    public final List<RadioStation> fmPreScanned = new ArrayList<>(), amPreScanned = new ArrayList<>();
    public final List<Dab> dabFavorites = new ArrayList<>(), dabStations = new ArrayList<>();
    public int fmChannel = -1, amChannel = -1;
    public Dab currentDab;
    /** Station DAB+ valide suivante / précédente selon la radio (comportement d'origine). */
    public Dab nextValid, previousValid;

    /** Station DAB+ : identifiant de service, nom du service et du multiplex. */
    public static class Dab {
        final long sid; final String name, ensemble;
        public Dab(long sid, String name, String ensemble) { this.sid = sid; this.name = name; this.ensemble = ensemble; }
        public Dab(long sid, String name) { this(sid, name, "Multiplex"); }
        public long getServiceId() { return sid; }
        public String getServiceName() { return name; }
        public String getEnsembleName() { return ensemble; }
        @Override public String toString() { return "DAB " + name; }
    }

    public List<Dab> getDabFavorite() { return dabFavorites; }
    public List<Dab> getDabStationList() { return dabStations; }
    public Dab getCurrentDabStation() { return currentDab; }
    public Dab getDabNextValidStation() { return nextValid; }
    public Dab getDabPreValidStation() { return previousValid; }
    public Dab getDabStationForServiceId(Dab d) { return d; }
    public List<RadioStation> getFavoriteForBand(int band) { return band == 0 ? amFavorites : fmFavorites; }
    public List<RadioStation> getPreScannedStationsForBand(int band) { return band == 0 ? amPreScanned : fmPreScanned; }
    public int getStoredRadioChannel(int band) { return band == 0 ? amChannel : fmChannel; }

    public void storeFavorite(RadioStation s) { getFavoriteForBand(s.getRadioBand()).add(s); }
    public void removeFavorite(RadioStation s) { getFavoriteForBand(s.getRadioBand()).remove(s); }
    public void storeDabFavorite(Dab d) { dabFavorites.add(d); }
    public void removeDabFavorite(Dab d) { dabFavorites.remove(d); }
}
