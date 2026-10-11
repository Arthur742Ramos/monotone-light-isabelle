"""Run one real validation command, retaining its invocation and exit status."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument("action", choices=["build", "lint", "negative-control"])
parser.add_argument("--afp", type=Path, default=os.environ.get("AFP"))
parser.add_argument("--project", type=Path, default=root / "projects/monotone-light-isabelle")
parser.add_argument("--evidence", type=Path, default=root / ".validation/evidence")
parser.add_argument("--document-engine", default="pdflatex")
options = parser.parse_args()
if not options.afp:
    parser.error("set AFP or pass --afp")
options.evidence.mkdir(parents=True, exist_ok=True)
project = options.project.resolve()
args = [sys.executable, str(root / "tools/isabelle-native-bridge.py")]
if options.action == "build":
    args += ["build", "-v", "-o", "document=pdf", "-o", "document_build=" + options.document_engine,
             "-o", "document_output=" + str((options.evidence / "document").resolve())]
else:
    args += ["lint", "-v", "-j1", "-o", "threads=1", "-o", "parallel_proofs=0",
             "-o", "quick_and_dirty=false", "-o", "skip_proofs=false", "-o", "document=false",
             "-o", "lint_bundles=afp_mandatory", "-f", "error", "-r", "json", "-O",
             str((options.evidence / (options.action + ".json")).resolve())]
if options.action == "negative-control":
    project = root / "tools/lint-control"
else:
    args += ["-d", str(options.afp.resolve() / "thys/Topological_Groups")]
args += ["-D", str(project)]
started = datetime.now(timezone.utc).isoformat()
with (options.evidence / (options.action + ".log")).open("w", encoding="utf-8") as log:
    log.write("COMMAND " + json.dumps(args) + "\n")
    log.flush()
    process = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                               text=True, encoding="utf-8", errors="replace")
    for line in process.stdout:
        print(line, end="", flush=True)
        log.write(line)
        log.flush()
    code = process.wait()
    log.write("EXIT_STATUS " + str(code) + "\n")
record = {"command": args, "started": started, "finished": datetime.now(timezone.utc).isoformat(),
          "exit_status": code, "action": options.action, "project": str(project),
          "native_environment": {k: os.environ.get(k) for k in
              ["ISABELLE_NATIVE_HOME", "ISABELLE_NATIVE_BASH", "ISABELLE_NATIVE_USER_HOME", "ISABELLE_NATIVE_TMPDIR"]}}
(options.evidence / (options.action + "-invocation.json")).write_text(json.dumps(record, indent=2) + "\n")
if options.action == "negative-control":
    report = (options.evidence / "negative-control.json").read_text(encoding="utf-8")
    if code == 0 or "global_attribute_on_unnamed_lemma" not in report:
        raise SystemExit("Negative control did not detect the expected named violation")
    print("EXPECTED_NEGATIVE_CONTROL_REJECTION", flush=True)
else:
    raise SystemExit(code)
