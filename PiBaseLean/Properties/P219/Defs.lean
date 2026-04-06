import Mathlib.SetTheory.Cardinal.Defs
import Mathlib.Topology.Homeomorph.Defs
import PiBaseLean.Properties.Bundled.Defs

open Cardinal

namespace PiBase

/-- 219. Toronto -/
class TorontoSpace (X : Type*) [TopologicalSpace X] : Prop where
  toronto : ∀ ⦃Y : Set X⦄, #Y = #X → Nonempty (Y ≃ₜ X)

end PiBase

namespace PiBase.Formal

def P219 : Property where
  toPred := TorontoSpace
  well_defined' φ h := sorry

end PiBase.Formal
