module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P58.Defs
public import PiBaseLean.Properties.P227.Defs

@[expose] public section

universe u

open Topology Set Function Cardinal

namespace PiBase

/-- Theorem T834: P227 (HasClosedDiscreteSubsetCardContinuum) => P58 (¬CardLtContinuum) -/
theorem not_CardLtContinuumOfHasClosedDiscreteSubsetCardContinuum (X : Type u)
    [TopologicalSpace X] [h : HasClosedDiscreteSubsetCardContinuum X] :
    ¬ CardLtContinuum X := by
  intro h'
  obtain ⟨s, _, _, hs⟩ := h.ex_subset
  have h0 := h'.card_lt
  contrapose! h0
  rw [← hs]
  exact Cardinal.mk_set_le s

end PiBase

namespace PiBase.Formal

theorem T834 : P227 ≤ P58ᶜ := fun X _ h ↦ @not_CardLtContinuumOfHasClosedDiscreteSubsetCardContinuum X _ h

end PiBase.Formal
