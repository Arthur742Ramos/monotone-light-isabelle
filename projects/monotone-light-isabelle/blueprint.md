# Monotone-light factorization

The target is the classical factorization of a continuous map from a compact
Hausdorff space X to a Hausdorff space Y. The middle space consists of connected
components of point fibres, with the quotient topology. No metrizability,
local connectivity, or surjectivity of the original map is assumed. The
factorization is unique up to a homeomorphism commuting with the maps.

This is an informal proof plan authored before the main proof. Authored status
is not a claim of kernel checking. The released Blueprint checker will provide
the formal evidence. We reuse AFP Topological_Groups.quot_topology.

::: definition {#fibre-component}
title: Connected component within a point fibre
isabelle: Monotone_Light.fibre_component_def
status: {blueprint: written, formal: named}

q(x) is the component of x in f inverse {f(x)}. Only points in the carrier
matter. Components are nonempty connected closed subsets of their fibres.
:::

::: lemma {#partition}
title: Fibres of the component projection
isabelle: Monotone_Light.fibre_component_fibre
uses: [fibre-component]
status: {blueprint: written, formal: named}

For x in X, q inverse {q(x)} is exactly q(x).

## Proof

Component equivalence and equality
of f values establish this. Hence q has connected fibres.
:::

::: theorem {#closed-projection}
title: The component projection is closed
isabelle: Monotone_Light.component_quotient_closed
uses: [partition]
status: {blueprint: written, formal: named}

For compact Hausdorff X, Hausdorff Y and continuous f, q is closed.

## Proof

For a closed A and x outside its saturation, separate q(x) from A inside the
compact fibre using equality of components and quasicomponents. Extend the
clopen partition of that fibre to disjoint open sets in X, one avoiding A.
Since f is closed, a neighbourhood of f(x) has its whole preimage inside their
union. Connected fibre components cannot cross this union. This yields an open
neighbourhood of x avoiding the saturation of A. Thus the saturation is closed,
and the quotient criterion makes q(A) closed.
:::

::: theorem {#compact-middle}
title: The middle space is compact
isabelle: Monotone_Light.component_quotient_compact
uses: [partition]
status: {blueprint: written, formal: named}

Under the target assumptions, the quotient by fibre components is compact.

## Proof

Compactness follows from continuity and surjectivity of q.
:::

::: theorem {#middle-space}
title: The middle space is Hausdorff
isabelle: Monotone_Light.component_quotient_Hausdorff
uses: [closed-projection]
status: {blueprint: written, formal: named}

Under the target assumptions, the quotient by fibre components is Hausdorff.

## Proof

The source is normal; a closed continuous quotient of a normal Hausdorff space
is normal Hausdorff.
:::

::: theorem {#factorization}
title: Monotone-light factorization
isabelle: Monotone_Light.monotone_light_factorization
uses: [partition, compact-middle, middle-space]
status: {blueprint: written, formal: named}

Every continuous f from compact Hausdorff X to Hausdorff Y factors through
the component quotient as a surjective monotone quotient q and continuous light l.

## Proof

f is constant on q-fibres, so the quotient lifting theorem supplies a continuous
l with f = l composed with q. If C is a connected subset of an l-fibre, its
preimage under the closed monotone q is connected. That preimage lies in one
f-fibre, hence in one component, and therefore C contains at most one point.
This proves lightness.
:::

::: theorem {#uniqueness}
title: Uniqueness of the factorization up to homeomorphism
isabelle: Monotone_Light.monotone_light_unique
uses: [factorization]
status: {blueprint: written, formal: named}
effort: 3

Any alternative continuous monotone-light factorization through a Hausdorff
middle space, with surjective first map, admits a unique commuting homeomorphism
from the component quotient. Uniqueness is on the carrier.

## Proof

In any such factorization with surjective monotone first map and
light second map, a fibre of the first map is contained in an f-component.
Conversely, the image of an f-component is connected inside a light fibre and
thus a singleton. Hence the first map has exactly the same fibres as q. The
quotient lifting theorem supplies a continuous bijection of middle spaces,
which is a homeomorphism by compactness and the Hausdorff condition.
:::
