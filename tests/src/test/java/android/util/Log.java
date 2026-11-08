package android.util;

/**
 * Remplace le Log d'Android pendant les tests (celui du framework appelle du code natif).
 * Garde les dernières lignes pour les tests qui les vérifient.
 */
public final class Log {
    public static final java.util.List<String> lines = java.util.Collections.synchronizedList(new java.util.ArrayList<String>());

    private Log() {}

    private static int add(String level, String tag, String msg) { lines.add(level + "/" + tag + ": " + msg); return 0; }

    public static int v(String tag, String msg) { return add("V", tag, msg); }
    public static int d(String tag, String msg) { return add("D", tag, msg); }
    public static int i(String tag, String msg) { return add("I", tag, msg); }
    public static int w(String tag, String msg) { return add("W", tag, msg); }
    public static int e(String tag, String msg) { return add("E", tag, msg); }
    public static int w(String tag, String msg, Throwable t) { return add("W", tag, msg + " " + t); }
    public static int e(String tag, String msg, Throwable t) { return add("E", tag, msg + " " + t); }
    public static boolean isLoggable(String tag, int level) { return false; }
}
