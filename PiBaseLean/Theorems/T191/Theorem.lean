module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P57.Bundled
public import PiBaseLean.Properties.P114.Bundled

@[expose] public section

universe u

open Cardinal

namespace PiBase

/-- Theorem 191: ℵ₁ is uncountable -/
theorem instNotCountableOfCardEqAlephOne {X : Type u} [h : CardEqAlephOne X] :
    ¬ Countable X := by
  refine (uncountable_iff_not_countable X).mp <| aleph0_lt_mk_iff.mp ?_
  rw [h.card_eq]
  simp

end PiBase

namespace PiBase.Formal

theorem T191 : P114 ≤ P57ᶜ := fun X _ ↦ @instNotCountableOfCardEqAlephOne X

end PiBase.Formal
