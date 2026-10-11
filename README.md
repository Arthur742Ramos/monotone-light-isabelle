# Monotone-Light Factorization in Isabelle

Every continuous map from a compact Hausdorff space to a Hausdorff space has a canonical monotone-light factorization, unique up to a commuting homeomorphism. The construction uses connected components of point fibres; no metrizability, local connectivity, nonemptiness or surjectivity of the original map is required. This is a classical theorem, with checked references and no claim of mathematical novelty.

Authors: Arthur Freitas Ramos, David Barros Hulak, and Ruy Jose Guerra Barretto de Queiroz. Codex assisted with planning, proof engineering, prose and validation. Independent AI source review is documented with its limitations; human review or endorsement is not claimed.

- [Formal source and build instructions](projects/monotone-light-isabelle/README.md)
- [Complete 13-page proof PDF](artifacts/Monotone_Light.pdf)
- [Clean AFP source archive](artifacts/Monotone_Light.tar.gz)
- [Informal proof plan](projects/monotone-light-isabelle/blueprint.md)
- [Blueprint report: 7/7 proved](artifacts/blueprint/report.md), [offline site](artifacts/blueprint/site/index.html) and [dependency graph](artifacts/blueprint/graph.mmd)
- [Readiness and validation evidence](artifacts/READINESS.md)
- [Actual Blueprint 1.19.0 dogfooding observations](projects/monotone-light-isabelle/DOGFOODING.md)
- [Independent mathematical source review](projects/monotone-light-isabelle/MATHEMATICAL_REVIEW.md)

The full Isabelle2025-2 session and PDF build pass, as does a separate rebuild of the exact clean archive. The AFP mandatory linter inspects the actual entry without findings; a fully proved negative control demonstrates that the compatibility-adapted runner detects the intended violation. Blueprint's released checker verifies seven exact fact links without oracle dependencies; its canonical snapshot and read-only MCP status restore current evidence. Local native Windows adapters and their limits are disclosed.

This repository is a fresh scoped public mirror of the new entry, with no private monorepo history or unrelated projects. Review occurs in a draft PR. No AFP or Palomar submission has occurred; Arthur's later approval is required.
