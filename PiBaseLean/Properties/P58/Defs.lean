module

public import Mathlib.SetTheory.Cardinal.Continuum
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Cardinal

namespace PiBase

/- 58. Cardinality < 𝔠 -/
class CardLtContinuum (X : Type*) where
  card_lt : #X < 𝔠

end PiBase

namespace PiBase.Formal

def P58 : Property where
  toPred X := CardLtContinuum X
  well_defined φ h := by
    constructor
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_lt

end PiBase.Formal
