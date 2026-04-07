import Mathlib.SetTheory.Cardinal.Continuum
import PiBaseLean.Properties.Bundled.Defs

open Cardinal

namespace PiBase

/- 65. Cardinality = 𝔠 -/
class CardEqContinuum (X : Type*) where
  card_eq : #X = 𝔠

end PiBase

namespace PiBase.Formal

def P65 : Property where
  toPred X := CardEqContinuum X
  well_defined φ h := by
    constructor
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_eq

end PiBase.Formal
