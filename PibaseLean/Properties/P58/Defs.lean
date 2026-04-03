import Mathlib.SetTheory.Cardinal.Continuum

open Cardinal
namespace PiBase

/- 58. Cardinality < 𝔠 -/
class CardLtContinuum (X : Type*) where
  card_lt : #X < 𝔠

end PiBase

namespace PiBase.Formal

abbrev P58 := CardLtContinuum

class NP58 (X : Type*) where
  not_p58 : ¬ P58 X

end PiBase.Formal
