# Readiness evidence

Local submission preparation is complete. The entry remains unsubmitted, and human approval/review is pending.

| Check | Actual result | Evidence |
| --- | --- | --- |
| Full session and document | Pass, all proofs; complete PDF 13 pages | [build](evidence/document-build-04.log), [PDF QA](evidence/pdf-qa.json) |
| Clean archive | One entry, one authored theory; exact source bytes match | [members](evidence/archive-members.txt), [manifest](evidence/archive-source-manifest.json) |
| Exact archive rebuild | Pass with full PDF in separate user home; complete PDF has 13 pages | [build](evidence/package-build.log), [validation](evidence/package-validation.json) |
| Proof escape audit | No sorry, oops, axiomatization, smt_oracle, admit or cheat; 469 theory lines | [audit](evidence/source-audit-final.json) |
| AFP mandatory linter | Actual theory inspected, no findings | [JSON](evidence/official-lint.json), [log](evidence/official-lint.log) |
| Linter negative control | Expected failure for unnamed global simp attribute in a fully proved lemma | [log](evidence/linter-negative-control-04.log), [control source](../tools/lint-control/Lint_Control.thy) |
| Blueprint check | 7 exact facts proved; no oracle dependencies | [report](evidence/blueprint-check-final.json), [kernel status TSV](evidence/blueprint-proof-status-final.tsv) |
| Canonical evidence | Current; 100% coverage, no stale/problem targets | [snapshot](evidence/blueprint-snapshot-final.json), [report](blueprint/report.md) |
| Blueprint lint | Zero errors, warnings or other findings | [output](evidence/blueprint-final-lint.log) |
| Read-only MCP | Complete status, 7 proved, 0 stale; no write tools enabled | [actual probe](evidence/blueprint-mcp-final.log) |
| Independent mathematical review | No material gap found in reviewed source; final aliases/tool checks not independently reviewed | [scope and corrections](../projects/monotone-light-isabelle/MATHEMATICAL_REVIEW.md) |
| Bounded proof cleanup | Retain structured proofs; actual outcomes recorded | [summary](evidence/mirabelle-summary.txt) |

The source was developed in an isolated branch/checkout of Arthur742Ramos/isabelle-afp-monorepo. The original checkout, the submitted Sharp_Planar_Isoperimetric entry and unrelated active work were preserved. The private monorepo was not made public. Only this entry and selected supporting outputs are mirrored here.

The document prints all authored definitions, statements and proofs. All 13 pages were visually inspected for missing glyphs and clipping. Four primary references, including DOI links, appear in its bibliography. No unfinished proof, new axiom, oracle-backed workaround or weakened target was introduced.

See the [native validation notes](../tools/README.md) for the linter XML compatibility change, authentic negative control, Blueprint path/deadline adapter and PDF environment. No VS Code extension exercise or unmodified native checker run is claimed. Failures are retained as labelled dogfooding evidence; they are not passed off as successful checks.
