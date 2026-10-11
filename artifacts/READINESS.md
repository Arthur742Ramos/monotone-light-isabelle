# Readiness evidence

All four Astra findings have been addressed. The final source retains the
reviewed theorem and proofs; its only theory changes are two document commands.
Human review and Arthur's submission approval remain pending.

Current Sol verification evidence is in [sol-review-fixes](evidence/sol-review-fixes/).

| Current check | Actual result | Evidence |
| --- | --- | --- |
| Full session/PDF | Pass, complete 13-page proof | [build](evidence/sol-review-fixes/session/build.log), [invocation](evidence/sol-review-fixes/session/build-invocation.json) |
| Exact archive rebuild | Pass in separate owned home, complete 13-page PDF | [build](evidence/sol-review-fixes/archive-build/build.log), [invocation](evidence/sol-review-fixes/archive-build/build-invocation.json) |
| Sources and PDF QA | Five-file archive matches source bytes; all 13 pages inspected; archive renders identical | [manifest](evidence/sol-review-fixes/Monotone_Light.tar.manifest.json), [audit](evidence/sol-review-fixes/final-audit.json) |
| Pinned mandatory lint | Entry findings empty; expected control rejection with raw exit 1 | [entry](evidence/sol-review-fixes/lint/lint.json), [control](evidence/sol-review-fixes/control/negative-control.json), [control invocation](evidence/sol-review-fixes/control/negative-control-invocation.json) |
| Licence/provenance | Exact MIT notice; unchanged upstream files match pinned source | [verification](evidence/sol-review-fixes/provenance-verification.json), [notice](../tools/ISABELLE-LINTER-LICENSE), [pins](../tools/inputs.json) |
| Released Blueprint | Seven current proved facts, empty oracles | [checker](evidence/sol-review-fixes/blueprint-check-report.json), [commands](evidence/sol-review-fixes/blueprint/invocations.json) |
| Read-only MCP | Complete; 7 proved, 0 stale, 0 ready tasks; no write tools | [validation](evidence/sol-review-fixes/blueprint/mcp-validation.json), [probe](evidence/sol-review-fixes/blueprint/mcp.log) |
| Astra review | No mathematical blocker; all four findings fixed by Sol | [review scope](../projects/monotone-light-isabelle/ASTRA_REVIEW.md), [replay recipe](../tools/REPRODUCING.md) |

The fibre-closedness statement is together on page 5, the complete factorization
statement is together on page 10, and the duplicate section heading is removed.
The complete PDF SHA-256 is `4541fdf62983c759465e13dc6bef83934fc9640e2f1e2d82952f0be29db5252f`;
the clean archive SHA-256 is `0eabfd91f2318d8f5a3d97ccd325670ad920a108cdd277cbaf9faed2a6338458`.
Only the offline Tectonic engine is claimed as tested on this host; its recorded
source/settings and font manifest are included. Standard LaTeX remains the normal
reviewer route. Preserved failed replay diagnostics are labelled separately.

## Original baseline evidence

The following table records the original run before the presentation/tooling fixes.

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
