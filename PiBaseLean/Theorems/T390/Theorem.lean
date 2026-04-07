import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P59.Defs
import PiBaseLean.Properties.P163.Defs

universe u

open Cardinal

namespace PiBase

/-- Theorem 390: |X| ≤ 𝔠 implies |X| ≤ 2^𝔠 -/
instance instCardLeContinuumOfCardLePowerContinuum (X : Type u) [h : CardLeContinuum X] :
    CardLePowerContinuum X where
  card_le := le_trans h.card_le (cantor 𝔠).le

end PiBase

namespace PiBase.Formal

theorem T390 : P163 ≤ P59 := fun X _ ↦ @instCardLeContinuumOfCardLePowerContinuum X

end PiBase.Formal
