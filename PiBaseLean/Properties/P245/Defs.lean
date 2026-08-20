module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Defs.Basic
public import Mathlib.Topology.Sets.Opens

@[expose] public section

universe u

open TopologicalSpace Set

namespace PiBase

/- 245. Has finitely many open sets -/
class HasFinitelyManyOpenSets (X : Type u) [t : TopologicalSpace X] : Prop where
  finite_open_sets : Finite (Opens X)

end PiBase
