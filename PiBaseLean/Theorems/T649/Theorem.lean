module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P107.Defs
public import PiBaseLean.Properties.P126.Defs
public import PiBaseLean.Properties.P137.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T649: P126 (DoorSpace) + P137ᶜ (Nonempty) => P107 (HasClosedPoint) -/
instance instHasClosedPointOfDoorSpaceOfNonempty (X : Type u)
    [TopologicalSpace X] [h : DoorSpace X] [h' : Nonempty X] :
    HasClosedPoint X where
  has_closed_point := by
    by_contra! h0
    have : ∀ x : X, IsOpen {x} := by
      intro x
      cases h.isOpen_or_isClosed {x}
      · assumption
      · tauto
    contrapose! h0
    refine ⟨h'.some, ?_⟩
    apply isOpen_compl_iff.mp
    refine isOpen_iff_mem_nhds.mpr ?_
    simp only [mem_compl_iff, mem_singleton_iff]
    intro y hy
    apply mem_nhds_iff.mpr
    refine ⟨{y}, ?_⟩
    simp_all [Ne.symm hy]

end PiBase

namespace PiBase.Formal

theorem T649 : P126 ⊓ P137ᶜ ≤ P107 :=
  fun X _ ⟨h1, h2⟩ ↦ haveI : Nonempty X := not_isEmpty_iff.mp h2
    @instHasClosedPointOfDoorSpaceOfNonempty X _ h1 ‹_›

end PiBase.Formal
