module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.Sets.Opens

@[expose] public section

universe u

namespace PiBase

open TopologicalSpace Set

/- 245. Has finitely many open sets -/
class HasFinitelyManyOpenSets (X : Type u) [t : TopologicalSpace X] : Prop where
  finite_open_sets : Finite (Opens X)

end PiBase

namespace PiBase.Formal

def P245 : Property where
  toPred := HasFinitelyManyOpenSets
  well_defined φ h := sorry

end PiBase.Formal
