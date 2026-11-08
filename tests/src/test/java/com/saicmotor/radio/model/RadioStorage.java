package com.saicmotor.radio.model;

import android.content.Context;

/** Simulation : la base de la radio, ici seulement la bande en cours. */
public class RadioStorage {
    public static int band = 1;
    private static final RadioStorage INSTANCE = new RadioStorage();
    public static RadioStorage getInstance(Context c) { return INSTANCE; }
    public int getStoredRadioBand() { return band; }
}
