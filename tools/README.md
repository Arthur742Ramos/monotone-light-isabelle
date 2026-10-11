# Native validation adapters

The core formalization uses ordinary Isabelle2025-2/HOL-Analysis plus AFP Topological_Groups. Standard installations can build with the documented Isabelle command and their normal LaTeX engine. These files document the local Windows validation, rather than requiring this exact host configuration.

`run-blueprint-native-check.py` changes only the read-only source-context query deadline to 300 seconds. `isabelle-native-bridge.py` translates native paths and chooses an isolated Isabelle user home; its local root must be configured for another host. Neither adapter supplies proof statuses or changes Isabelle's proof checker.

The official mandatory AFP linter rule bundle was used with an isolated Isabelle2025-2 XML compatibility change in `token_markup.scala`: transparent `command_range` wrappers are flattened while all contents and inner markup are preserved. The first control showed why this was needed: without it, the runner inspected no useful command tokens. After the change, the fully proved `lemma [simp]: "True" by simp` control is rejected for an unnamed global attribute, and the actual entry is inspected with an empty findings list. The rule bundle is not described as an unmodified upstream executable. This compatibility file is supporting evidence; it is not included in the AFP archive.

The bounded Mirabelle review produced no preferable proof simplification. Failed suggestions do not affect the existing successful kernel proof.

PDF generation used an isolated Tectonic cache and official Latin Modern 2.005 fonts downloaded from CTAN. The complete source document also builds with a suitably installed normal LaTeX environment. No global font, credential, permission or Isabelle installation was modified.
