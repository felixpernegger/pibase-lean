import Mathlib.SetTheory.Cardinal.Aleph
import PiBaseLean.Properties.Bundled.Defs

open Cardinal

namespace PiBase

/- 114. Cardinality = ℵ₁ -/
class CardEqAlephOne (X : Type*) where
  card_eq : #X = ℵ₁

end PiBase

namespace PiBase.Formal

def P114 : Property where
  toPred X := CardEqAlephOne X
  well_defined' φ h := by
    constructor
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_eq

end PiBase.Formal
