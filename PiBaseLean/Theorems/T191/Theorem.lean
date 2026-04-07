module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P57.Defs
public import PiBaseLean.Properties.P114.Defs

@[expose] public section

universe u

open Cardinal

namespace PiBase

--TODO: Maybe redo this if we have negations properly implemented
/-- Theorem 191: ℵ₁ is uncountable -/
instance instNotCountableOfCardEqAlephOne {X : Type u} [h : CardEqAlephOne X] :
    ¬ Countable X := by
  refine (uncountable_iff_not_countable X).mp <| aleph1_le_mk_iff.mp ?_
  rw [h.card_eq]

end PiBase

namespace PiBase.Formal

theorem T191 : P114 ≤ P57ᶜ := fun X _ ↦ @instNotCountableOfCardEqAlephOne X

end PiBase.Formal
