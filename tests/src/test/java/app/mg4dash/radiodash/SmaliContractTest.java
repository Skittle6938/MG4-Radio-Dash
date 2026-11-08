package app.mg4dash.radiodash;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;

import java.io.File;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Contrat entre le smali modifié de la radio (dash/smali) et le module d'aide (helper/src) : chaque appel
 * {@code invoke-static … Lapp/mg4dash/radiodash/…} doit viser une méthode publique et statique qui existe avec
 * exactement cette signature. apktool ne le vérifie pas : une méthode renommée ou un paramètre changé ne se voit
 * qu'en voiture, par un NoSuchMethodError qui fait planter la radio.
 */
public class SmaliContractTest {
    private static final Pattern CALL = Pattern.compile(
            "^\\s*(invoke-[a-z/]+)\\s+\\{[^}]*\\},\\s*Lapp/mg4dash/radiodash/([A-Za-z0-9_$]+);->([A-Za-z0-9_$<>]+)(\\([^)]*\\)\\S+)",
            Pattern.MULTILINE);

    @Test public void everyHelperCallFromTheSmaliExists() throws Exception {
        List<String> problems = new ArrayList<>();
        int calls = 0;
        for (File f : Repo.files("dash/smali", ".smali")) {
            Matcher m = CALL.matcher(Repo.read(f));
            while (m.find()) {
                calls++;
                String where = Repo.relative(f) + " : " + m.group(2) + "." + m.group(3) + m.group(4);
                if (!m.group(1).startsWith("invoke-static")) { problems.add(where + " appelé par " + m.group(1) + " au lieu de invoke-static"); continue; }
                Class<?> c;
                try {
                    c = Class.forName("app.mg4dash.radiodash." + m.group(2), false, getClass().getClassLoader());
                } catch (ClassNotFoundException e) {
                    problems.add(where + " : classe absente du module");
                    continue;
                }
                Method found = null;
                for (Method x : c.getDeclaredMethods()) {
                    if (x.getName().equals(m.group(3)) && descriptor(x).equals(m.group(4))) found = x;
                }
                if (found == null) problems.add(where + " : aucune méthode avec cette signature");
                else if (!Modifier.isStatic(found.getModifiers()) || !Modifier.isPublic(found.getModifiers())
                        || !Modifier.isPublic(c.getModifiers()))
                    problems.add(where + " : doit être public static dans une classe publique");
            }
        }
        assertTrue("aucun appel au module trouvé dans dash/smali : expression à revoir", calls > 0);
        if (!problems.isEmpty()) fail("Appels smali cassés :\n" + String.join("\n", problems));
    }

    static String descriptor(Method m) {
        StringBuilder b = new StringBuilder("(");
        for (Class<?> p : m.getParameterTypes()) b.append(type(p));
        return b.append(')').append(type(m.getReturnType())).toString();
    }

    private static String type(Class<?> c) {
        if (c.isArray()) return "[" + type(c.getComponentType());
        if (c == void.class) return "V";
        if (c == boolean.class) return "Z";
        if (c == byte.class) return "B";
        if (c == char.class) return "C";
        if (c == short.class) return "S";
        if (c == int.class) return "I";
        if (c == long.class) return "J";
        if (c == float.class) return "F";
        if (c == double.class) return "D";
        return "L" + c.getName().replace('.', '/') + ";";
    }

    @Test public void descriptorMatchesTheSmaliNotation() throws Exception {
        Method m = Bands.class.getMethod("session", android.content.Context.class, android.media.session.MediaSession.class,
                android.media.session.MediaSession.Callback.class);
        assertTrue(descriptor(m).equals(
                "(Landroid/content/Context;Landroid/media/session/MediaSession;Landroid/media/session/MediaSession$Callback;)V"));
        assertTrue(descriptor(Focus.class.getMethod("skip", android.content.Context.class, int.class)).equals("(Landroid/content/Context;I)Z"));
    }
}
