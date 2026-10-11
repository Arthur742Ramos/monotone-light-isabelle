import isabelle.*
class Owned_Tectonic_Engine extends Document_Build.Bash_Engine("owned_tectonic") {
  override def prepare_directory(context: Document_Build.Context, dir: Path,
      doc: Document_Build.Document_Variant, verbose: Boolean): Document_Build.Directory = {
    val docDir = context.make_directory(dir, doc)
    File.find_files(Path.explode("/cygdrive/c/Users/arfreita/Documents/Codex/2026-10-11/task/components/owned-tectonic/font-assets").file).foreach { f =>
      Isabelle_System.copy_file(File.path(f), docDir + Path.basic(f.getName))
    }
    context.prepare_directory(dir, doc, new Latex.Output(context.options), verbose)
  }
  override def build_script(context: Document_Build.Context,
      directory: Document_Build.Directory): String =
    "set -e\n" +
    "export TECTONIC_CACHE_DIR='C:/Users/arfreita/Documents/Codex/2026-10-11/task/tectonic-cache'\n" +
    "export FONTCONFIG_FILE='C:/Users/arfreita/Documents/Codex/2026-10-11/task/components/owned-tectonic/fonts.conf'\n" +
    "export OMP_NUM_THREADS=1 RAYON_NUM_THREADS=1\n" +
    Bash.string("/cygdrive/c/Users/arfreita/Documents/Codex/2026-10-11/task/components/tectonic.exe") +
    " --untrusted --only-cached --keep-logs --keep-intermediates --print " +
    directory.root_name_script("tex") + "\n"
}
