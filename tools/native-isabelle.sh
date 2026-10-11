#!/usr/bin/env bash
set -euo pipefail
: "${ISABELLE_NATIVE_HOME:?Set the installed Isabelle root}"
unset ISABELLE_SETTINGS_PRESENT ISABELLE_SITE_SETTINGS_PRESENT ISABELLE_REGISTRY
unset ISABELLE_HOME_USER ISABELLE_HEAPS ISABELLE_HEAPS_SYSTEM ISABELLE_SETUP_CLASSPATH
if [[ -n "${ISABELLE_NATIVE_USER_HOME:-}" ]]; then
  export USER_HOME="$ISABELLE_NATIVE_USER_HOME"
fi
if [[ -n "${ISABELLE_NATIVE_TMPDIR:-}" ]]; then
  mkdir -p "$ISABELLE_NATIVE_TMPDIR"
  export TMPDIR="$ISABELLE_NATIVE_TMPDIR"
  if command -v cygpath >/dev/null; then
    export TEMP="$(cygpath -m "$TMPDIR")"
  else
    export TEMP="$TMPDIR"
  fi
  export TMP="$TEMP"
fi
export OMP_NUM_THREADS=1 RAYON_NUM_THREADS=1
exec "$ISABELLE_NATIVE_HOME/bin/isabelle" "$@"
