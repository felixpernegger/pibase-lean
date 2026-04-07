module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P114.Defs
public import PiBaseLean.Properties.P163.Defs

@[expose] public section

universe u

open Cardinal

namespace PiBase

/-- Theorem 190: ℵ₁ ≤ 𝔠 -/
instance instCardLeContinuumOfCardEqAlephOne {X : Type u} [h : CardEqAlephOne X] :
    CardLeContinuum X where card_le := h.card_eq ▸ aleph_one_le_continuum

end PiBase

namespace PiBase.Formal

theorem T190 : P114 ≤ P163 := fun X _ ↦ @instCardLeContinuumOfCardEqAlephOne X

end PiBase.Formal
