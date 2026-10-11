# Monotone–Light Factorization

Authors: Arthur Freitas Ramos, David Barros Hulak, and Ruy Jose Guerra Barretto de Queiroz.

This entry formalizes the classical monotone–light factorization of every continuous map from a compact Hausdorff space to a Hausdorff space, together with uniqueness up to a commuting homeomorphism. The first map is the quotient by connected components of point fibres. No metrizability, local connectivity, nonemptiness, or surjectivity assumption is imposed on the original map.

The theory contains the definitions, the closed-projection argument, compactness and Hausdorff separation of the quotient, lightness, existence, and uniqueness. The proof document prints the complete development.

## Prerequisites and build

Use Isabelle2025-2 and the matching AFP release. Development uses AFP's 2026-10-06 release of `Topological_Groups`, whose quotient topology is imported rather than duplicated. With `AFP` pointing to the extracted AFP root:

```sh
isabelle build -d "$AFP/thys/Topological_Groups" -D .
```

The parent is HOL-Analysis through Topological_Groups. Existing matching heaps can be reused. Generated heaps and document output are not submission sources.

## Blueprint

`blueprint.md` records the informal proof and dependencies. Install the released `isabelle-blueprint[mcp]==1.19.0`; its source release is tagged `v1.19.0` in Arthur742Ramos/isa-blueprint. Configure the AFP dependency directory in `isabelle-blueprint.toml`, then run:

```sh
isabelle-blueprint lint .
isabelle-blueprint check . --strict
isabelle-blueprint report .
isabelle-blueprint graph .
isabelle-blueprint web .
```

Authored node status is not evidence of kernel verification. The check output records actual fact existence and proof evidence.

## Attribution and review

The three names above identify the established human author team. This repository does not assign or invent individual responsibilities. Codex assisted with literature searches, proof planning, Isabelle proof engineering, document preparation, tooling, and validation. An independent AI mathematical review checked the argument and statement generality; this is not a claim of human review or endorsement.

The result is classical, and no mathematical novelty is claimed. A targeted prerequisite search did not find an existing formalization; that search is not an exhaustive assertion about all formal libraries.

Prepared for review only. Submission to AFP or Palomar requires Arthur's later approval.

Validation on 2026-10-11: the full Isabelle2025-2 session and complete 13-page PDF pass; Blueprint verifies seven mapped facts without oracles; the AFP mandatory linter reports no findings for the entry. See DOGFOODING.md for the native Windows path/deadline adapter and actual usability observations. The configured AFP path assumes this checkout is beside an afp-2026-10-06 directory; adjust it for another installation.
