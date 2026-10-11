"""Prepare a fresh component from the hash-pinned upstream archive and patch."""
import argparse
import hashlib
from pathlib import Path
import tarfile

parser = argparse.ArgumentParser()
parser.add_argument("archive", type=Path)
parser.add_argument("destination", type=Path)
options = parser.parse_args()
expected = "83dc386d6e9dcbfa9f820abddac31c1bedffa46f1f74265a8ccf9007ff9ca2f1"
assert hashlib.sha256(options.archive.read_bytes()).hexdigest() == expected, "upstream archive hash mismatch"
assert not options.destination.exists(), "use a fresh destination"
prefix = "isabelle-linter-c9983adc5c51a6455f702bb58c9f960d425a2af3/"
with tarfile.open(options.archive, "r:gz") as archive:
    for member in archive.getmembers():
        if member.isfile() and member.name.startswith(prefix + "linter_base/"):
            relative = Path(member.name.removeprefix(prefix + "linter_base/"))
            assert not relative.is_absolute() and ".." not in relative.parts
            target = options.destination / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(archive.extractfile(member).read())
    licence = archive.extractfile(prefix + "LICENSE").read()
(options.destination / "LICENSE").write_bytes(licence)
(options.destination / "ISABELLE-LINTER-LICENSE").write_bytes(licence)
source = options.destination / "src/token_markup.scala"
assert hashlib.sha256(source.read_bytes()).hexdigest() == "38fd0b84e055ad591cdf9740164c666ad1edc5fc74ef163fd6bf5e0032c897e5"
source.write_bytes(Path(__file__).with_name("token_markup.scala").read_bytes())
print("PINNED_LINTER_PREPARED", options.destination.resolve())
