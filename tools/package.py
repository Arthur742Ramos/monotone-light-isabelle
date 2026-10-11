"""Create and byte-verify the explicit AFP source projection."""
import argparse
import gzip
import hashlib
import io
import json
from pathlib import Path
import tarfile

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument("--project", type=Path, default=root / "projects/monotone-light-isabelle")
parser.add_argument("--output", type=Path, required=True)
options = parser.parse_args()
files = ["ROOT", "Monotone_Light.thy", "LICENSE", "document/root.tex", "document/root.bib"]
options.output.parent.mkdir(parents=True, exist_ok=True)
manifest = []
with options.output.open("wb") as raw:
    with gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=0) as compressed:
        with tarfile.open(fileobj=compressed, mode="w") as archive:
            for name in files:
                data = (options.project / name).read_bytes()
                member = tarfile.TarInfo("Monotone_Light/" + name)
                member.size = len(data)
                member.mode = 0o644
                archive.addfile(member, io.BytesIO(data))
                manifest.append({"path": member.name, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()})
with tarfile.open(options.output, "r:gz") as archive:
    assert [m.name for m in archive.getmembers()] == ["Monotone_Light/" + n for n in files]
    for name in files:
        assert archive.extractfile("Monotone_Light/" + name).read() == (options.project / name).read_bytes()
record = {"archive_sha256": hashlib.sha256(options.output.read_bytes()).hexdigest(),
          "source_bytes_match": True, "files": manifest}
options.output.with_suffix(".manifest.json").write_text(json.dumps(record, indent=2) + "\n")
print(json.dumps(record, indent=2))
