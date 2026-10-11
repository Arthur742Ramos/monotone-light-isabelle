# Reproduce the checks

Run commands from the repository root. Install Isabelle2025-2 (revision
`89701cf1768e`) and a working LaTeX engine. Use a private virtual environment
and an isolated Isabelle user home; an existing home with matching parent
heaps can be reused. Do not point the commands at another running job's home.

## Pinned inputs

Download the AFP and linter URLs in [inputs.json](inputs.json). Check their
SHA-256 values before extraction. The dated AFP archive was downloaded again
and matched the original archive exactly. Extract AFP beside this checkout as
`afp-2026-10-06`; the checked-in Blueprint config then finds its dependency.
For another layout, edit `[isabelle].dirs` in the local Blueprint config.

Install the released Blueprint commit in the virtual environment:

```sh
python -m venv .validation/blueprint-env
# Activate this environment using its platform's activation script.
python -m pip install 'isabelle-blueprint[mcp] @ git+https://github.com/Arthur742Ramos/isa-blueprint.git@6f52dc13d92d03f44a47b76609cf6ae7c55ecae2'
python tools/install-native-launcher.py
```

The commit is the dereferenced `v1.19.0` tag. Installing from the source pin
also works when a package index has not yet published 1.19.0. No global
Python or Isabelle installation needs modification.

Set these environment variables, using absolute native paths:

| Variable | Value |
| --- | --- |
| `AFP` | Extracted `afp-2026-10-06` root |
| `ISABELLE_NATIVE_HOME` | Isabelle2025-2 root containing `bin/isabelle` |
| `ISABELLE_NATIVE_BASH` | Bundled Cygwin `bin/bash.exe` on Windows; optional on Unix |
| `ISABELLE_NATIVE_USER_HOME` | Isolated user home, or the owned home holding matching heaps |
| `ISABELLE_NATIVE_TMPDIR` | Owned temporary directory |

On Unix use `export NAME=/absolute/path`. On PowerShell use
`$env:NAME = 'C:/absolute/path'`. Keep the activated virtual environment's
Scripts/bin directory on PATH so Blueprint can find `isabelle-native`.
The bridge translates Windows path arguments and Scala `Path.explode`
literals. It prepends build defaults: `-b -j1`, `threads=1`,
`parallel_proofs=0`, `parallel_limit=1`, `quick_and_dirty=false`,
`skip_proofs=false`, `system_heaps=false`, `document=false`. Later options
override these defaults; the full build below explicitly selects `document=pdf`.

## Full session and PDF

```sh
python tools/validate.py build --evidence .validation/session
```

This uses the ordinary `pdflatex` document engine. The recorded Windows run
instead passed `--document-engine owned_tectonic` because this host uses an
existing isolated, offline Tectonic component. That engine's source, settings
and asset manifest are provided with the evidence; they are not AFP sources.
Only the recorded engine is claimed as tested here. A standard LaTeX build
remains the normal reviewer route.

## Exact mandatory linter and negative control

Prepare the pinned component; the script verifies the archive and original
token-markup hashes and installs precisely the published adapted file:

```sh
python tools/setup-linter.py /absolute/path/linter-upstream.tar.gz .validation/linter
python tools/isabelle-native-bridge.py components -u /absolute/path/to/checkout/.validation/linter
python tools/isabelle-native-bridge.py scala_build
python tools/validate.py lint --evidence .validation/lint
python tools/validate.py negative-control --evidence .validation/control
```

Component registration applies to the configured isolated user home. With
already compiled installation modules, `scala_build` compiles the new local
component. The `afp_mandatory` bundle is selected explicitly with `-f error`,
JSON reports and `export_theory=true`. Every invocation and raw exit status
is recorded by `validate.py`. A clean entry must exit zero with an empty
findings list. The fully proved control `lemma [simp]: "True" by simp` must
exit nonzero and report `global_attribute_on_unnamed_lemma`; the wrapper exits
zero only when that exact expected rejection is confirmed. This prevents
an empty or ineffective token scan from passing unnoticed.

## Released Blueprint checker and read-only MCP

The complete recorded CLI/MCP sequence is also available as
`python tools/blueprint-replay.py --evidence .validation/blueprint`. It runs
from this repository root, avoiding unrelated current-directory launchers.

```sh
python tools/run-blueprint-native-check.py lint projects/monotone-light-isabelle
python tools/run-blueprint-native-check.py check projects/monotone-light-isabelle --strict --fail-on problem --isabelle isabelle-native --timeout 600
python tools/run-blueprint-native-check.py snapshot projects/monotone-light-isabelle --json
python tools/blueprint-mcp-final.py
```

The deadline adapter changes only the genuine source-context query's 30-second
deadline to 300 seconds. It supplies no status and does not alter the released
proof, oracle, source-digest, staleness or failure checks. The probe uses the
current Python and this checkout's project by default; `--project-dir` selects
another local checkout. It checks that write tools are absent and requires
seven current proved facts, no stale facts and no ready tasks. The probe
explicitly forwards PATH and the four `ISABELLE_NATIVE_*` variables to stdio
MCP; the client's default environment does not include these custom variables.

After a successful check, generate `report`, `graph` and `web` outputs with
the same CLI adapter. Preserve failed diagnostics separately. Generated
checker theories and reports must not enter the AFP archive.

## Clean archive

`tools/package.py` creates an explicit five-file source projection, checks
every archived byte against its source, and writes a source hash manifest:

```sh
python tools/package.py --output .validation/Monotone_Light.tar.gz
# Extract this archive into an empty owned directory.
python tools/validate.py build --project /absolute/path/extracted/Monotone_Light --evidence .validation/archive-build
```

Inspect every page of both resulting complete proof PDFs, verify that the
source archive has one `Monotone_Light/` directory, and retain the successful
invocations and exit statuses. Submission remains subject to Arthur's approval.
