import PiBaseLean.Properties.P163.Defs
import PiBaseLean.Properties.P114.Defs

universe u

open Cardinal

namespace PiBase

/-- Theorem 190: ℵ₁​ ≤ 𝔠 -/
instance instCardLeContinuumOfCardEqAlephOne {X : Type u} [h : CardEqAlephOne X] :
    CardLeContinuum X where card_le := h.card_eq ▸ aleph_one_le_continuum

end PiBase
