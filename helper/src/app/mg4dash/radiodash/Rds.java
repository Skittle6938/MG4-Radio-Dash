package app.mg4dash.radiodash;

import android.util.Log;

/**
 * Textes RDS (radiotexte, nom de station) : le RDS n'est pas en Latin-1 mais dans son propre jeu de caractères
 * (EBU Latin, IEC 62106 annexe E), où « é » vaut 0x82, « è » 0x83, « à » 0x81, « ç » 0x9B… Le tuner rend chaque octet
 * tel quel en caractère : les lettres accentuées tombaient sur des caractères de contrôle invisibles (U+0080 à U+009F)
 * ou sur d'autres lettres, et n'étaient pas affichées, ni dans Radio Dash ni dans MG4Dash.
 *
 * Le texte n'est converti que s'il contient au moins un de ces caractères de contrôle, qui n'existent pas dans un texte
 * déjà correct : un tuner qui rendrait déjà de l'Unicode n'est pas touché.
 */
public final class Rds {
    private static final String TAG = "RadioDash";

    /** Caractères EBU de 0x80 à 0xFF (0xFF : non défini, espace = rien). */
    static final String EBU_HIGH =
            "áàéèíìóòúùÑÇŞβ¡Ĳ" +   // 0x80
            "âäêëîïôöûüñçşğıĳ" +   // 0x90
            "ªα©‰Ğěňőπ€£$←↑→↓" +   // 0xA0
            "º¹²³±İńűµ¿÷°¼½¾§" +   // 0xB0
            "ÁÀÉÈÍÌÓÒÚÙŘČŠŽĐĿ" +   // 0xC0
            "ÂÄÊËÎÏÔÖÛÜřčšžđŀ" +   // 0xD0
            "ÃÅÆŒŷÝÕØÞŊŔĆŚŹŦð" +   // 0xE0
            "ãåæœŵýõøþŋŕćśźŧ ";    // 0xF0

    private static String lastLogged;

    private Rds() {}

    /** Texte du tuner, avec les lettres accentuées du jeu RDS remises en Unicode. */
    public static String decode(String s) {
        if (s == null || s.isEmpty()) return s;
        boolean ebu = false;
        for (int i = 0; i < s.length() && !ebu; i++) {
            char ch = s.charAt(i);
            ebu = ch >= 0x80 && ch <= 0x9F;
        }
        if (!ebu) {
            logNonAscii(s);
            return s;
        }
        StringBuilder b = new StringBuilder(s.length());
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            if (ch >= 0x80 && ch <= 0xFF) {
                char m = EBU_HIGH.charAt(ch - 0x80);
                if (m != ' ') b.append(m);
            } else b.append(ch);
        }
        String out = b.toString();
        if (!out.equals(lastLogged)) { lastLogged = out; Log.i(TAG, "texte RDS en jeu EBU : « " + out + " »"); }
        return out;
    }

    /** Lettres hors ASCII laissées telles quelles : leurs codes dans le journal, pour voir ce que rend le tuner. */
    private static void logNonAscii(String s) {
        StringBuilder codes = null;
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            if (ch < 0x80) continue;
            if (codes == null) codes = new StringBuilder();
            codes.append(String.format(" U+%04X", (int) ch));
        }
        if (codes != null && !s.equals(lastLogged)) { lastLogged = s; Log.i(TAG, "texte RDS, caractères hors ASCII :" + codes); }
    }
}
