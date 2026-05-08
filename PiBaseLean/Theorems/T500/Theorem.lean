module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Theorems.T500.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T500: P191 (HasGδSingletons) => P2 (T1Space) -/
instance instT1SpaceOfHasGδSingletons (X : Type u)
    [TopologicalSpace X] [h : HasGδSingletons X] : T1Space X := by
  refine t1Space_iff_exists_open.mpr (fun x y xy ↦ ?_)
  have : y ∉ ({x} : Set X) := by exact notMem_singleton_iff.mpr (Ne.symm xy)
  obtain ⟨s, sx, sy⟩ := mem_isGδ_ex_nhds_separate (h.isGδ_singleton x) (mem_singleton_of_eq rfl)
    <| notMem_singleton_iff.mpr xy.symm
  refine ⟨interior s, isOpen_interior, ?_, ?_⟩
  · exact mem_interior_iff_mem_nhds.mpr sx
  · contrapose! sy
    exact interior_subset sy

end PiBase
