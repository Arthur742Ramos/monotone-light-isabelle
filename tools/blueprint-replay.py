"""Run released CLI and read-only MCP checks with recorded commands/exit codes."""
import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument("--project", type=Path, default=root / "projects/monotone-light-isabelle")
parser.add_argument("--evidence", type=Path, default=root / ".validation/blueprint")
options = parser.parse_args()
project = options.project.resolve()
options.evidence.mkdir(parents=True, exist_ok=True)
cli = [sys.executable, str(root / "tools/run-blueprint-native-check.py")]
commands = [
    ("lint", cli + ["lint", str(project)]),
    ("check", cli + ["check", str(project), "--strict", "--fail-on", "problem", "--timeout", "600", "--jobs", "1"]),
    ("snapshot", cli + ["snapshot", str(project), "--json"]),
    ("report", cli + ["report", str(project)]),
    ("graph", cli + ["graph", str(project)]),
    ("web", cli + ["web", str(project)]),
    ("mcp", [sys.executable, str(root / "tools/blueprint-mcp-final.py"), "--project-dir", str(project)]),
]
records = []
for name, command in commands:
    print("BLUEPRINT_REPLAY", name, flush=True)
    started = datetime.now(timezone.utc).isoformat()
    with (options.evidence / (name + ".log")).open("w", encoding="utf-8") as log:
        process = subprocess.run(command, cwd=root, stdout=log, stderr=subprocess.STDOUT)
    records.append({"name": name, "command": command, "started": started,
                    "finished": datetime.now(timezone.utc).isoformat(), "exit_status": process.returncode})
    (options.evidence / "invocations.json").write_text(json.dumps(records, indent=2) + "\n")
    if process.returncode:
        raise SystemExit(process.returncode)
    if name == "check":
        report = json.loads((project / "build/check_report.json").read_text())
        assert report["ran"] and report["return_code"] == 0 and report["proof_checked"]
        assert len(report["facts"]) == 7
        assert all(f["proof_status"] == "proved" and f["oracles"] == [] for f in report["facts"])
        assert not report["source_context_changed"]
        (options.evidence / "check-report.json").write_text(json.dumps(report, indent=2) + "\n")
print("BLUEPRINT_REPLAY_PASS", flush=True)
