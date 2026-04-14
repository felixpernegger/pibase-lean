module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P168.Defs
public import Mathlib.Topology.DiscreteSubset

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T221: P168 (CountableSetsDiscrete) => P2 (T1Space) -/
instance instT1SpaceOfCountableSetsDiscrete (X : Type u)
    [TopologicalSpace X] [h : CountableSetsDiscrete X] :
    T1Space X := by
  refine t1Space_iff_exists_open.mpr (fun x y xy ↦ ?_)
  have := h.countable_discrete <| to_countable {x, y}
  obtain ⟨U, hU, hx⟩ := (isDiscrete_iff_forall_exists_isOpen.mp <| h.countable_discrete
    <| to_countable {x, y}) x (mem_insert x {y})
  refine ⟨U, hU, ?_, ?_⟩
  · exact mem_of_subset_of_mem inter_subset_left <| hx.symm ▸ mem_singleton_of_eq <| .refl x
  contrapose! xy
  suffices y ∈ ({x} : Set X) by simp_all
  rw [← hx]
  simpa

end PiBase

namespace PiBase.Formal

theorem T221 : P168 ≤ P2 := fun X _ ↦ @instT1SpaceOfCountableSetsDiscrete X _

end PiBase.Formal
