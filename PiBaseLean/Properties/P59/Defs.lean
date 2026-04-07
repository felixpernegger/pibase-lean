module

public import Mathlib.SetTheory.Cardinal.Continuum
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Cardinal

namespace PiBase

/- 59. Cardinality ≤ 2 ^ 𝔠 -/
class CardLePowerContinuum (X : Type*) where
  card_le : #X ≤ 2 ^ 𝔠

end PiBase

namespace PiBase.Formal

def P59 : Property where
  toPred X := CardLePowerContinuum X
  well_defined φ h := by
    constructor
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_le

end PiBase.Formal
