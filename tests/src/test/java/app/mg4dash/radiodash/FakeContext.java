package app.mg4dash.radiodash;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.SharedPreferences;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/** Contexte avec des préférences en mémoire. */
public class FakeContext extends ContextWrapper {
    private final Map<String, FakePrefs> prefs = new HashMap<>();

    public FakeContext() { super(null); }

    @Override public SharedPreferences getSharedPreferences(String name, int mode) {
        FakePrefs p = prefs.get(name);
        if (p == null) { p = new FakePrefs(); prefs.put(name, p); }
        return p;
    }

    @Override public Context getApplicationContext() { return this; }

    /** SharedPreferences en mémoire, apply() immédiat. */
    public static class FakePrefs implements SharedPreferences {
        final Map<String, Object> values = new HashMap<>();

        @Override public Map<String, ?> getAll() { return new HashMap<>(values); }
        @Override public String getString(String k, String d) { Object v = values.get(k); return v == null ? d : (String) v; }
        @SuppressWarnings("unchecked")
        @Override public Set<String> getStringSet(String k, Set<String> d) { Object v = values.get(k); return v == null ? d : (Set<String>) v; }
        @Override public int getInt(String k, int d) { Object v = values.get(k); return v == null ? d : (Integer) v; }
        @Override public long getLong(String k, long d) { Object v = values.get(k); return v == null ? d : (Long) v; }
        @Override public float getFloat(String k, float d) { Object v = values.get(k); return v == null ? d : (Float) v; }
        @Override public boolean getBoolean(String k, boolean d) { Object v = values.get(k); return v == null ? d : (Boolean) v; }
        @Override public boolean contains(String k) { return values.containsKey(k); }
        @Override public void registerOnSharedPreferenceChangeListener(OnSharedPreferenceChangeListener l) {}
        @Override public void unregisterOnSharedPreferenceChangeListener(OnSharedPreferenceChangeListener l) {}

        @Override public Editor edit() {
            return new Editor() {
                final Map<String, Object> put = new HashMap<>();
                final Set<String> removed = new HashSet<>();
                boolean clear;
                @Override public Editor putString(String k, String v) { put.put(k, v); return this; }
                @Override public Editor putStringSet(String k, Set<String> v) { put.put(k, v); return this; }
                @Override public Editor putInt(String k, int v) { put.put(k, v); return this; }
                @Override public Editor putLong(String k, long v) { put.put(k, v); return this; }
                @Override public Editor putFloat(String k, float v) { put.put(k, v); return this; }
                @Override public Editor putBoolean(String k, boolean v) { put.put(k, v); return this; }
                @Override public Editor remove(String k) { removed.add(k); return this; }
                @Override public Editor clear() { clear = true; return this; }
                @Override public boolean commit() {
                    if (clear) values.clear();
                    for (String k : removed) values.remove(k);
                    values.putAll(put);
                    return true;
                }
                @Override public void apply() { commit(); }
            };
        }
    }
}
