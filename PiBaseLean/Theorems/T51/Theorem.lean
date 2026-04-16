module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P39.Defs
public import PiBaseLean.Properties.P41.Defs

@[expose] public section

open Topology Set Function

namespace PiBase

/-- Theorem T51: P39 (PreirreducibleSpace) => P41 (LocallyConnectedSpace) -/
instance instLocallyConnectedSpaceOfPreirreducibleSpace (X : Type u)
    [TopologicalSpace X] [h : PreirreducibleSpace X] : LocallyConnectedSpace X := by
  refine locallyConnectedSpace_iff_connected_subsets.mpr (fun x U hU ↦ ?_)
  refine ⟨interior U, by simpa, ?_, interior_subset⟩
  apply IsPreirreducible.isPreconnected
  exact h.isPreirreducible_univ.open_subset isOpen_interior (subset_univ _)

end PiBase

namespace PiBase.Formal

theorem T78 : P39 ≤ P41 := instLocallyConnectedSpaceOfPreirreducibleSpace

end PiBase.Formal
