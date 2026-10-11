# Isabelle Blueprint 1.19.0: actual use

The informal proof plan was written before the main proof. Six initial nodes recorded the component partition, closed projection, quotient, factorization and uniqueness. A seventh node was introduced after real checking exposed a multiple-fact mapping limitation. The final read-only MCP probe independently restored current checker evidence and reported complete status, seven proved facts, zero stale facts and no ready proof tasks. All seven final mapped facts were verified by Blueprint's generated Isabelle checker session: `proved`, with empty oracle lists. Authored status was never changed to simulate verification. The initial snapshot had six formal targets and zero proved; the final checker completed on 2026-10-11 with return code 0.

The isolated environment installed the released `v1.19.0` tag at commit `6f52dc13d92d03f44a47b76609cf6ae7c55ecae2`; the local package index offered only 1.18.0. The older global installation was preserved. The VS Code extension was not exercised.

Observed issues and responses:

* A scalar `status: written` left formal status missing despite supplied fact names. Explicit `{blueprint: written, formal: named}` expressed the intended plan. A diagnostic beside such mappings would improve discoverability.
* Lint correctly requested `## Proof` sections for informal proof sketches. The plan was revised accordingly.
* Mapping the two-fact theorem `component_quotient_compact_Hausdorff` caused the generated `@{thm ...}` antiquotation to fail because it expects one fact. The top-level message described an unverifiable source context, obscuring the underlying singleton-fact error. Two kernel-derived aliases now expose compactness and Hausdorffness separately. Supporting indexed fact references and preserving the underlying error would improve this workflow.
* The genuine native Windows context query took 117.359 seconds, exceeding the released fixed 30-second cap. A local launcher raises only that read-only query deadline to 300 seconds. The released dependency/source digest, kernel proof, oracle, skip-proof, failure and staleness checks remain unchanged. The installed released package was not edited and the adapter supplies no status. This is released 1.19.0 plus a disclosed local deadline adapter, rather than an unmodified Windows run.
* The native launcher translates Windows paths to Cygwin paths and selects an isolated user home with matching parent heaps. These changes do not manufacture proof evidence.
* Graphviz was absent. Actual DOT, JSON, GraphML, Mermaid and offline HTML outputs are provided; no Graphviz-generated SVG is claimed.
* MCP's installed Pydantic dependency emitted a field-shadowing warning during the real read-only probe. The initial probe exposed read-only tools and correctly reported zero proved targets before checking. No write tools were enabled.

Stale evidence was withheld after changing the plan and formal fact mappings. Failure and diagnostic outputs are retained separately from the successful final report. Suggested improvements above are observations from this run; no upstream issue submission or accepted fix is claimed.

The monorepo archive helper also recursively collected Blueprint's generated checker theory. Packaging therefore used an explicit clean source projection and the canonical helper on that projection. The delivered archive contains only the authored theory, ROOT, document sources and licence.

## Sol replay repairs after Astra review

The public replay now includes its required shell wrapper, configurable native
paths, a virtual-environment console installer and correct project-root
resolution. Actual replay also exposed Windows paths inside Isabelle option
values, and a surrounding workspace's relative `.CMD` launcher shadowing the
installed executable. Both are handled explicitly; CLI and MCP launch from the
repository root. MCP's stdio client omitted custom Isabelle environment variables,
so the probe forwards only PATH and the four configured native variables.

The initial replay MCP process returned success while reporting seven stale facts.
The probe now requires complete health, seven current proved facts, zero stale
facts and zero ready tasks, as well as absence of write tools. After environment
and working-directory fixes it meets those requirements. The released checker
was rerun on the final source and again checked all seven mapped facts with
empty oracle lists. These are launcher fixes; the released checker and authored
statuses were not edited. Failure logs and current execution evidence are
published under `artifacts/evidence/sol-review-fixes` in the public mirror.
