package app.mg4dash.radiodash;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilderFactory;

/**
 * Ressources de Radio Dash (dash/res) : XML bien formés, et toute ressource propre à Radio Dash (préfixe rd_)
 * citée par les mises en page ou par le module existe. apktool échoue sur un XML cassé ; une icône rd_ absente
 * ne se voit qu'à l'écran (getIdentifier renvoie 0, bouton sans icône).
 */
public class ResourcesTest {
    @Test public void everyXmlResourceIsWellFormed() {
        List<String> problems = new ArrayList<>();
        for (File f : Repo.files("dash/res", ".xml")) {
            try {
                DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(f);
            } catch (Exception e) {
                problems.add(Repo.relative(f) + " : " + e.getMessage());
            }
        }
        if (!problems.isEmpty()) fail("XML invalides :\n" + String.join("\n", problems));
    }

    /** Noms des ressources de dash/res d'un type (drawable, mipmap, layout…), toutes variantes confondues. */
    private static Set<String> names(String type) {
        Set<String> out = new HashSet<>();
        File[] dirs = Repo.file("dash/res").listFiles();
        if (dirs != null) for (File d : dirs) {
            if (!d.getName().equals(type) && !d.getName().startsWith(type + "-")) continue;
            File[] files = d.listFiles();
            if (files != null) for (File f : files) out.add(f.getName().replaceAll("\\..*$", ""));
        }
        return out;
    }

    @Test public void radioDashResourcesUsedByTheLayoutsExist() {
        Pattern ref = Pattern.compile("@(drawable|mipmap|layout)/(rd_[a-z0-9_]+)");
        List<String> missing = new ArrayList<>();
        int refs = 0;
        for (File f : Repo.files("dash/res", ".xml")) {
            Matcher m = ref.matcher(Repo.read(f));
            while (m.find()) {
                refs++;
                if (!names(m.group(1)).contains(m.group(2))) missing.add(Repo.relative(f) + " : @" + m.group(1) + "/" + m.group(2));
            }
        }
        assertTrue(refs > 0);
        if (!missing.isEmpty()) fail("Ressources absentes de dash/res :\n" + String.join("\n", missing));
    }

    @Test public void radioDashIconsNamedByTheHelperExist() {
        // Icônes passées par leur nom à getIdentifier(…, "drawable", …) : rd_ic_*, rd_btn_*, rd_bg_*
        Pattern lit = Pattern.compile("\"(rd_(?:ic|btn|bg)_[a-z0-9_]+)\"");
        Set<String> drawables = names("drawable");
        List<String> missing = new ArrayList<>();
        int refs = 0;
        for (File f : Repo.files("helper/src", ".java")) {
            Matcher m = lit.matcher(Repo.read(f));
            while (m.find()) {
                refs++;
                if (!drawables.contains(m.group(1))) missing.add(Repo.relative(f) + " : " + m.group(1));
            }
        }
        assertTrue(refs > 0);
        if (!missing.isEmpty()) fail("Icônes absentes de dash/res/drawable :\n" + String.join("\n", missing));
    }

    @Test public void versionFileIsAPlainVersion() {
        String v = Repo.read(Repo.file("VERSION")).trim();
        assertTrue("VERSION = « " + v + " » : lu par MG4Dash (meta-data radiodash.version)",
                v.matches("\\d+\\.\\d+\\.\\d+(-beta\\.\\d+)?"));
    }
}
