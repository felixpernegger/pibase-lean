import Mathlib.SetTheory.Cardinal.Order
import Mathlib.Topology.Defs.Basic
import PiBaseLean.Properties.Bundled.Defs

open Cardinal

namespace PiBase

/-- 175. Cardinality ≥ 3 -/
class CardGeThree (X : Type*) : Prop where
  card_ge : 3 ≤ #X

end PiBase

namespace PiBase.Formal

def P175 : Property where
  toPred X := CardGeThree X
  well_defined' φ h := by
    constructor
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_ge

end PiBase.Formal
