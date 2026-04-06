import PiBaseLean.Properties.P58.Defs

universe u

open Cardinal

namespace PiBase

/-- Theorem 67: Countable implies |X| < 𝔠 -/
instance instCardLtContinuumOfCountable (X : Type u) [h : Countable X] : CardLtContinuum X where
  card_lt := lt_of_le_of_lt (mk_le_aleph0_iff.mpr h) aleph0_lt_continuum

end PiBase
