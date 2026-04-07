module

public import Mathlib.SetTheory.Cardinal.Continuum
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Cardinal

namespace PiBase

/- 163. Cardinality ≤ 𝔠 -/
class CardLeContinuum (X : Type*) where
  card_le : #X ≤ 𝔠

end PiBase

namespace PiBase.Formal

def P163 : Property where
  toPred X := CardLeContinuum X
  well_defined φ h := by
    constructor
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_le

end PiBase.Formal
