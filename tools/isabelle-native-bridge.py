"""Configurable Isabelle launcher for released Blueprint and validation.

Builds receive single-thread proof-checking defaults, including document=false;
later command-line options override these defaults. Windows paths, including
Scala Path.explode literals, are translated for Cygwin. The companion shell
wrapper selects explicitly configured paths. No proof status is supplied.
"""
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys


def cyg(path):
    key, separator, value = path.partition("=")
    if separator and re.match(r"^[A-Za-z]:[\\/]", value):
        return key + separator + cyg(value)
    if os.name == "nt" and re.match(r"^[A-Za-z]:[\\/]", path):
        return "/cygdrive/" + path[0].lower() + path[2:].replace("\\", "/")
    return path


def main():
    home = os.environ.get("ISABELLE_NATIVE_HOME")
    if not home or not (Path(home) / "bin/isabelle").is_file():
        raise SystemExit("Set ISABELLE_NATIVE_HOME to an installed Isabelle2025-2 root")
    bash = os.environ.get("ISABELLE_NATIVE_BASH")
    if not bash:
        bash = str(Path(home) / "contrib/cygwin/bin/bash.exe") if os.name == "nt" else shutil.which("bash")
    if not bash or not Path(bash).is_file():
        raise SystemExit("Set ISABELLE_NATIVE_BASH to bundled Cygwin bash (Windows) or bash (Unix)")
    args = [cyg(arg) for arg in sys.argv[1:]]
    if args and args[0] == "scala":
        args = [re.sub(r'Path\.explode\(("(?:[^"\\]|\\.)*")\)',
                       lambda m: "Path.explode(" + json.dumps(cyg(json.loads(m[1]))) + ")", arg)
                for arg in args]
    if args and args[0] == "build":
        args[1:1] = ["-b", "-j1", "-o", "threads=1", "-o", "parallel_proofs=0",
                     "-o", "parallel_limit=1", "-o", "quick_and_dirty=false",
                     "-o", "skip_proofs=false", "-o", "system_heaps=false", "-o", "document=false"]
    env = os.environ.copy()
    for name in ("ISABELLE_NATIVE_HOME", "ISABELLE_NATIVE_USER_HOME", "ISABELLE_NATIVE_TMPDIR"):
        if env.get(name):
            env[name] = cyg(env[name])
    env["PATH"] = str(Path(bash).parent) + os.pathsep + env.get("PATH", "")
    script = cyg(str(Path(__file__).with_name("native-isabelle.sh")))
    return subprocess.call([bash, "--noprofile", "--norc", script, *args], env=env, stdin=subprocess.DEVNULL)


if __name__ == "__main__":
    raise SystemExit(main())
