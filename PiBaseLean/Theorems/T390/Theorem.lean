import PiBaseLean.Properties.P59.Defs
import PiBaseLean.Properties.P163.Defs

universe u

open Cardinal

namespace PiBase

/-- Theorem 390: |X| ≤ 𝔠 implies |X| ≤ 2^𝔠 -/
instance instCardLeContinuumOfCardEqContinuum (X : Type u) [h : CardLeContinuum X] :
    CardLtPowerContinuum X where
  card_lt := lt_of_le_of_lt h.card_le (cantor 𝔠)

end PiBase
