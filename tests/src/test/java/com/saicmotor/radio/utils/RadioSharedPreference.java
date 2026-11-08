package com.saicmotor.radio.utils;

import android.content.Context;

/** Simulation : préférences de la radio, ici seulement le drapeau de reprise auto. */
public class RadioSharedPreference {
    public static Boolean wasPlaying;
    private static final RadioSharedPreference INSTANCE = new RadioSharedPreference();
    public static RadioSharedPreference getInstance(Context c) { return INSTANCE; }
    public void putRadioWasPlaying(boolean playing) { wasPlaying = playing; }
}
