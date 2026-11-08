package com.android.car.radio.service;

/** Simulation de la classe de la radio : nom RDS (PS) d'une station FM. */
public class RadioRds {
    private final String ps;
    public RadioRds(String programService, String radioText, String other) { this.ps = programService; }
    public String getProgramService() { return ps; }
}
