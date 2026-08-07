# Registry faithfulness review — 2026-07-02

The property registry (`data/registry.json`) is the project's highest-risk
correctness surface: if a pi-base property is mapped to a Mathlib class that means
something subtly different, every "proof" about it proves the wrong theorem — the
"silent statement-weakening" failure mode. Compiling only proves the names *exist*,
not that they mean the right thing. So the initial 40 Tier-A mappings were reviewed
adversarially against Mathlib's actual source.

**Method.** Five reviewers, each taking a batch of mappings, read the Mathlib class
definition from a local checkout (fields, `extends`, docstring, neighbouring
instances) and compared it to the pi-base definition text, returning a verdict:
EQUIVALENT / GAP (equivalent under a stated side-condition) / MISMATCH.

**Result: 37 EQUIVALENT, 3 GAP, 0 MISMATCH.**

All three gaps were the same issue — Mathlib bundles `Nonempty` into a class where
pi-base's stated definition is the vacuous-on-empty "pre" version:

| pi-base | first mapping | issue | faithful mapping |
|---|---|---|---|
| P000036 Connected | `ConnectedSpace` | bundles `Nonempty` | `PreconnectedSpace` |
| P000037 Path connected | `PathConnectedSpace` | bundles `Nonempty` | `∀ x y, Joined x y` |
| P000039 Hyperconnected | `IrreducibleSpace` | bundles `Nonempty` | `PreirreducibleSpace` |

**Ground truth.** pi-base has exactly one empty space, S000163 ("The Empty Space").
Its connectedness traits are not asserted, but the pi-base deduction engine
*derives* all three of Connected, Path-connected, and Hyperconnected as **true** for
it. So pi-base uses the preconnected/preirreducible convention (the empty space is
connected), and the `Nonempty`-bundled Mathlib classes would have been unfaithful.
The three mappings were changed accordingly (see the registry notes), verified to
compile, and the build stays green.

This is exactly the class of bug the review existed to catch: three statements that
compiled fine but would have mis-modelled pi-base on the empty space.
