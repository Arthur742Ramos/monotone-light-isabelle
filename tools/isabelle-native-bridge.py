"""Local Windows/Cygwin bridge; forwards actual Isabelle commands unmodified.

Translate native absolute path arguments and Scala Path.explode literals to
Cygwin paths. Never fabricate build or proof evidence.
"""
import re
import shlex
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
BASH = r"C:\Users\arfreita\AppData\Local\Programs\Isabelle2025-2\contrib\cygwin\bin\bash.exe"

def cyg(path):
    if re.match(r"^[A-Za-z]:[\\/]", path):
        return "/cygdrive/" + path[0].lower() + path[2:].replace("\\", "/")
    return path

args = [cyg(arg) for arg in sys.argv[1:]]
if args and args[0] == "scala":
    # Native checker emits JSON string literals in Scala Path.explode calls.
    import json
    for i, arg in enumerate(args):
        if "Path.explode(" in arg:
            args[i] = re.sub(r'Path\.explode\(("(?:[^"\\]|\\.)*")\)',
                lambda m: "Path.explode(" + json.dumps(cyg(json.loads(m[1]))) + ")", arg)
if args and args[0] == "build":
    args[1:1] = ["-b", "-j1", "-o", "threads=1", "-o", "parallel_proofs=0",
        "-o", "parallel_limit=1", "-o", "quick_and_dirty=false",
        "-o", "skip_proofs=false", "-o", "system_heaps=false",
        "-o", "document=false"]
script = cyg(str(ROOT / "native-isabelle.sh"))
sys.exit(subprocess.call([BASH, "--noprofile", "--norc", script, *args],
    stdin=subprocess.DEVNULL))
