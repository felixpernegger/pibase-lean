module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P126.Lemmas
public import PiBaseLean.Properties.P203.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T572: P203 (AlmostDiscreteSpace) => P126 (DoorSpace) -/
instance instDoorSpaceOfAlmostDiscreteSpace (X : Type u)
    [TopologicalSpace X] [h : AlmostDiscreteSpace X] : DoorSpace X where
  isOpen_or_isClosed s := by
    obtain ⟨p, hp⟩ := h.ex_point
    by_cases ps : p ∈ s
    · right
      apply isOpen_compl_iff.mp
      refine isOpen_iff_forall_mem_open.mpr (fun x xs ↦ ?_)
      refine ⟨{x}, singleton_subset_iff.mpr xs, ?_, mem_singleton_of_eq rfl⟩
      apply (hp x).mp
      contrapose! ps
      rw [ps] at xs
      exact (mem_compl_iff s p).mp xs
    · left
      refine isOpen_iff_forall_mem_open.mpr (fun x xs ↦ ?_)
      refine ⟨{x}, singleton_subset_iff.mpr xs, ?_, mem_singleton_of_eq rfl⟩
      apply (hp x).mp
      contrapose! ps
      rw [ps] at xs
      exact xs

end PiBase

namespace PiBase.Formal

theorem T572 : P203 ≤ P126 := fun X _ ↦ @instDoorSpaceOfAlmostDiscreteSpace X _

end PiBase.Formal
