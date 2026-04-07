module

public import Mathlib.Tactic.NormNum
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P175.Defs
public import PiBaseLean.Properties.P176.Defs

@[expose] public section

universe u

namespace PiBase

/-- Theorem 430: 3 ≤ 4 -/
instance instCardGeThreeOfCardGeFour {X : Type u} [h : CardGeFour X] :
    CardGeThree X where
  card_ge := le_trans (by norm_num) h.card_ge

end PiBase

namespace PiBase.Formal

theorem T430 : P176 ≤ P175 := fun X _ ↦ @instCardGeThreeOfCardGeFour X

end PiBase.Formal
