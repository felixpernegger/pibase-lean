import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P57.Defs
import PiBaseLean.Properties.P58.Defs

universe u

open Cardinal

namespace PiBase

/-- Theorem 67: Countable implies |X| < 𝔠 -/
instance instCardLtContinuumOfCountable (X : Type u) [h : Countable X] : CardLtContinuum X where
  card_lt := lt_of_le_of_lt (mk_le_aleph0_iff.mpr h) aleph0_lt_continuum

end PiBase

namespace PiBase.Formal

theorem T67 : P57 ≤ P58 := fun X _ ↦ @instCardLtContinuumOfCountable X

end PiBase.Formal
