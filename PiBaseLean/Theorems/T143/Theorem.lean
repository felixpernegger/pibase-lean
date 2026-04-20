module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P1.Lemmas
public import PiBaseLean.Properties.P126.Lemmas
public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T143: P126 (DoorSpace) => P1 (T0Space) -/
instance instT0SpaceOfDoorSpace (X : Type u)
    [TopologicalSpace X] [h : DoorSpace X] : T0Space X := by
  refine t0Space_iff_inseparableComponent_eq_singleton.mpr (fun x ↦ ?_)
  refine subset_antisymm ?_ (singleton_subset_iff.mpr rfl)
  rcases h.isOpen_or_isClosed {x} with h|h
  · exact inseparableComponent_subset_open h <| mem_singleton_of_eq rfl
  · exact inseparableComponent_subset_closed h <| mem_singleton_of_eq rfl

end PiBase

namespace PiBase.Formal

theorem T143 : P126 ≤ P1 := fun X _ ↦ @instT0SpaceOfDoorSpace X _

end PiBase.Formal
