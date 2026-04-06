import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P58.Defs
import PiBaseLean.Properties.P65.Defs
import PiBaseLean.Properties.P163.Defs

universe u

open Cardinal PiBase.Formal

namespace PiBase

--TODO: Maybe redo this once negations are properly implemented
/-- Theorem 391: |X| ≤ 𝔠 and ¬ |X| < 𝔠  implies |X| = 𝔠 -/
instance instCardEqContinuumOfCardLeContinuumOfNotCardltContinuum (X : Type u)
    [h : CardLeContinuum X] (h' : ¬CardLtContinuum X) : CardEqContinuum X where
  card_eq := by
    refine le_antisymm h.card_le ?_
    contrapose! h'
    exact ⟨h'⟩

end PiBase

namespace PiBase.Formal

theorem T391 : P163 ⊓ P58ᶜ ≤ P65 := fun X _ ↦ and_imp.2
  (@instCardEqContinuumOfCardLeContinuumOfNotCardltContinuum X)

end PiBase.Formal
