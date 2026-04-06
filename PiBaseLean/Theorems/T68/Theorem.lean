import PiBaseLean.Properties.P58.Defs
import PiBaseLean.Properties.P163.Defs

universe u

open Cardinal

namespace PiBase


/-- Theorem 68: < 𝔠 implies ≤ 𝔠 -/
instance instCardLeContinuumOfCardLtContinuum {X : Type u} [h : CardLtContinuum X] :
    CardLeContinuum X where
  card_le := le_of_lt CardLtContinuum.card_lt

end PiBase
