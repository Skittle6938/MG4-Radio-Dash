package app.mg4dash.radiodash;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

/** Fichiers du dépôt lus par les tests de contrat (les tests tournent dans tests/). */
final class Repo {
    private Repo() {}

    static File root() {
        File d = new File("").getAbsoluteFile();
        while (d != null && !new File(d, "dash").isDirectory()) d = d.getParentFile();
        if (d == null) throw new AssertionError("dossier dash/ introuvable depuis " + new File("").getAbsolutePath());
        return d;
    }

    static File file(String path) { return new File(root(), path); }

    static List<File> files(String dir, String suffix) {
        List<File> out = new ArrayList<>();
        walk(file(dir), suffix, out);
        if (out.isEmpty()) throw new AssertionError("aucun fichier " + suffix + " dans " + dir);
        return out;
    }

    private static void walk(File f, String suffix, List<File> out) {
        File[] kids = f.listFiles();
        if (kids == null) return;
        for (File k : kids) {
            if (k.isDirectory()) walk(k, suffix, out);
            else if (k.getName().endsWith(suffix)) out.add(k);
        }
    }

    static String read(File f) {
        try {
            return new String(Files.readAllBytes(f.toPath()), StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new AssertionError(f + " illisible", e);
        }
    }

    static String relative(File f) { return root().toPath().relativize(f.toPath()).toString().replace('\\', '/'); }
}
