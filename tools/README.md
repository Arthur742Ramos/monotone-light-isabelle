# Native validation adapters

The core formalization uses Isabelle2025-2/HOL-Analysis plus AFP Topological_Groups. See [REPRODUCING.md](REPRODUCING.md) for pinned inputs, isolated setup, complete build/lint/control commands and Blueprint CLI/MCP replay. Machine-readable pins are in [inputs.json](inputs.json).

`run-blueprint-native-check.py` changes only the read-only source-context query deadline to 300 seconds. The configurable `isabelle-native-bridge.py` and included `native-isabelle.sh` translate native Windows paths, including option values and Scala literals, and use an explicitly configured user home. Build defaults select one thread, full proof checking and no document; later options select PDF generation. The current virtual-environment installer exposes `isabelle-native`, and the MCP probe uses the current Python and the actual repository root. Neither adapter supplies proof statuses or changes Isabelle's proof checker.

The official mandatory AFP linter bundle is pinned at upstream revision `c9983adc5c51a6455f702bb58c9f960d425a2af3`. Its exact [MIT notice](ISABELLE-LINTER-LICENSE), [provenance](../THIRD_PARTY.md), [complete patch](token_markup.patch) and hash-verifying setup script are included. The Isabelle2025-2 adaptation flattens transparent `command_range` wrappers while preserving text and inner markup. The fully proved `lemma [simp]: "True" by simp` control must be rejected for `global_attribute_on_unnamed_lemma`, while the entry must produce an empty findings list. The runner is explicitly compatibility-adapted. These helpers are excluded from the AFP archive.

The bounded Mirabelle review produced no preferable proof simplification. Failed suggestions do not affect the existing successful kernel proof.

Recorded PDF generation uses an isolated offline Tectonic component/cache and official Latin Modern 2.005 fonts downloaded from CTAN. A standard LaTeX installation is the normal reviewer route; that engine is not claimed as tested on this host. No global font, credential, permission or Isabelle installation was modified.
