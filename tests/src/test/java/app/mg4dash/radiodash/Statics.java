package app.mg4dash.radiodash;

import java.lang.reflect.Field;

/** Accès aux champs statiques privés, pour remettre l'état du module à zéro entre deux tests. */
final class Statics {
    private Statics() {}

    static void set(Class<?> c, String name, Object value) {
        try {
            Field f = c.getDeclaredField(name);
            f.setAccessible(true);
            f.set(null, value);
        } catch (ReflectiveOperationException e) {
            throw new AssertionError("champ " + c.getSimpleName() + "." + name + " introuvable", e);
        }
    }

    static Object get(Class<?> c, String name) {
        try {
            Field f = c.getDeclaredField(name);
            f.setAccessible(true);
            return f.get(null);
        } catch (ReflectiveOperationException e) {
            throw new AssertionError("champ " + c.getSimpleName() + "." + name + " introuvable", e);
        }
    }
}
