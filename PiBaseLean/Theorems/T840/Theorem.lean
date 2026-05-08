module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P79.Defs
public import PiBaseLean.Properties.P228.Defs

@[expose] public section

universe u

open Topology TopologicalSpace

namespace PiBase

/-- Theorem T840: P228 (WeaklyFirstCountableSpace) => P79 (SequentialSpace) -/
theorem instSequentialSpaceOfWeaklyFirstCountableSpace (X : Type u)
    [TopologicalSpace X] [hX : WeaklyFirstCountableSpace X] :
    SequentialSpace X := by
  refine ⟨fun s hs ↦ ?_⟩
  contrapose hs
  obtain ⟨V, hV₁, hV₂⟩ := hX.nhds_countable_weak_basis
  simp only [← isOpen_compl_iff, hV₂, Set.mem_compl_iff,
    not_forall, not_exists, Set.not_subset, not_not] at hs
  obtain ⟨x, hx₁, hx₂⟩ := hs
  choose y hy using hx₂
  simp only [IsSeqClosed, not_forall]
  refine ⟨y, x, fun n ↦ (hy n).right, ?_, hx₁⟩
  rw [tendsto_atTop_nhds]
  intro U hx hU
  obtain ⟨N, hN⟩ := (hV₂ _ |>.mp hU) x hx
  exact ⟨N, fun n hn ↦ hN <| (hV₁ x).left hn (hy n).left⟩

end PiBase
namespace PiBase.Formal
theorem T840 : P228 ≤ P79 := fun X _ ↦ @instSequentialSpaceOfWeaklyFirstCountableSpace X _
end PiBase.Formal
