import PiBaseLean.Properties.Bundled.Basic
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

namespace PiBase.Formal

theorem T139 : P65 ≤ P163 := fun X _ ↦ @instCardLeContinuumOfCardEqContinuum X

end PiBase.Formal
