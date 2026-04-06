import Mathlib.SetTheory.Cardinal.Continuum

open Cardinal

namespace PiBase

/- 163. Cardinality ≤ 𝔠 -/
class CardLeContinuum (X : Type*) where
  card_le : #X ≤ 𝔠

end PiBase
