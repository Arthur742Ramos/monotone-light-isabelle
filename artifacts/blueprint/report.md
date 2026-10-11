# Monotone-light factorization - blueprint status

- Nodes: **7**
- Formal targets (with Isabelle ref): **7**
- Proved: **7**
- Found (exists, not yet trusted): **0**
- Problems (broken/not_found/tainted/failed_check): **0**
- Coverage (proved / formal targets): **100%** (7/7)

| Formal status | Count |
| --- | ---: |
| `proved` | 7 |

## Nodes

| ID | Kind | Title | Isabelle fact | Blueprint | Formal | Agent |
| --- | --- | --- | --- | --- | --- | --- |
| `fibre-component` | definition | Connected component within a point fibre | `Monotone_Light.fibre_component_def` | written | proved | solved |
| `partition` | lemma | Fibres of the component projection | `Monotone_Light.fibre_component_fibre` | written | proved | solved |
| `closed-projection` | theorem | The component projection is closed | `Monotone_Light.component_quotient_closed` | written | proved | solved |
| `compact-middle` | theorem | The middle space is compact | `Monotone_Light.component_quotient_compact` | written | proved | solved |
| `middle-space` | theorem | The middle space is Hausdorff | `Monotone_Light.component_quotient_Hausdorff` | written | proved | solved |
| `factorization` | theorem | Monotone-light factorization | `Monotone_Light.monotone_light_factorization` | written | proved | solved |
| `uniqueness` | theorem | Uniqueness of the factorization up to homeomorphism | `Monotone_Light.monotone_light_unique` | written | proved | solved |
