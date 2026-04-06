import PiBaseLean.Properties.P65.Defs
import PiBaseLean.Properties.P163.Defs

universe u

open Cardinal

namespace PiBase

/-- Theorem 139: |X| = 𝔠 implies |X| ≤ 𝔠 -/
instance instCardLeContinuumOfCardEqContinuum {X : Type u} [h : CardEqContinuum X] :
    CardLeContinuum X where
  card_le := by rw [h.card_eq]

end PiBase
