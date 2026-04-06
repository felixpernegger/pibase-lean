import PiBaseLean.Properties.P58.Defs
import PiBaseLean.Properties.P65.Defs
import PiBaseLean.Properties.P163.Defs

universe u

open Cardinal PiBase.Formal

namespace PiBase

--TODO: Maybe redo this once negations are properly implemented
/-- Theorem 391: |X| ≤ 𝔠 and ¬ |X| < 𝔠  implies |X| = 𝔠 -/
instance instCardEqContinuumOfCardLeContinuumOfNotCardltContinuum (X : Type u)
    [h : CardLeContinuum X] [h' : NP58 X] : CardEqContinuum X where
  card_eq := by
    apply le_antisymm
    · exact h.card_le
    · have := h'.not_p58
      contrapose! this
      exact { card_lt := this }

end PiBase
