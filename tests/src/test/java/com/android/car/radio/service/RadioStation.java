package com.android.car.radio.service;

/** Simulation de la classe de la radio : station FM / AM (fréquence en kHz). */
public class RadioStation {
    private final int channel, band;
    private final RadioRds rds;
    public RadioStation(int channel, int subChannel, int band, RadioRds rds) { this.channel = channel; this.band = band; this.rds = rds; }
    public int getChannelNumber() { return channel; }
    public int getRadioBand() { return band; }
    public RadioRds getRds() { return rds; }
    @Override public String toString() { return "FM " + channel; }

    public static RadioStation fm(int ch) { return new RadioStation(ch, 0, 1, null); }
    public static RadioStation fm(int ch, String ps) { return new RadioStation(ch, 0, 1, new RadioRds(ps, null, null)); }
}
