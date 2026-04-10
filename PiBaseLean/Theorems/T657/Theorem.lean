module

public import Mathlib.Topology.NoetherianSpace
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P131.Defs
public import PiBaseLean.Properties.P208.Defs

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T657: P208 (NoetherianSpace) => P131 (HereditarilyLindelofSpace) -/
instance instHereditarilyLindelofSpaceOfNoetherianSpace (X : Type u)
    [TopologicalSpace X] [h : NoetherianSpace X] :
    HereditarilyLindelofSpace X where
  isHereditarilyLindelof_univ := fun _ _ ↦ IsLindelof.of_coe

end PiBase

namespace PiBase.Formal

theorem T657 : P208 ≤ P131 := fun X _ ↦ @instHereditarilyLindelofSpaceOfNoetherianSpace X _

end PiBase.Formal
