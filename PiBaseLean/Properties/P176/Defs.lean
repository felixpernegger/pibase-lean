module

public import Mathlib.SetTheory.Cardinal.Order
public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Cardinal

namespace PiBase

/-- 176. Cardinality ≥ 4 -/
class CardGeFour (X : Type*) : Prop where
  card_ge : 4 ≤ #X

end PiBase

namespace PiBase.Formal

def P176 : Property where
  toPred X := CardGeFour X
  well_defined φ h := by
    constructor
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_ge

end PiBase.Formal
