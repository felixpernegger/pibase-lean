module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P46.Lemmas
public import PiBaseLean.Properties.P47.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T47: P47 (TotallyDisconnectedSpace) => P46 (TotallyPathDisconnectedSpace) -/
instance instTotallyPathDisconnectedSpaceOfTotallyDisconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : TotallyDisconnectedSpace X] :
    TotallyPathDisconnectedSpace X := by
  apply (totallyPathDisconnectedSpace_iff_pathComponent_singleton X).mpr (fun x ↦ ?_)
  apply subset_antisymm ?_ (by simp)
  exact subset_trans (pathComponent_subset_component x) (by simp)

end PiBase

namespace PiBase.Formal

theorem T47 : P47 ≤ P46 := fun X _ ↦ @instTotallyPathDisconnectedSpaceOfTotallyDisconnectedSpace X _

end PiBase.Formal
