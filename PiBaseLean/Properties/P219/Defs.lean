import Mathlib.SetTheory.Cardinal.Defs
import Mathlib.Topology.Homeomorph.Defs

universe u

open Cardinal

namespace PiBase

/-- 219. Toronto -/
class TorontoSpace (X : Type u) [TopologicalSpace X] : Prop where
  toronto : ∀ ⦃Y : Set X⦄, #Y = #X → Nonempty (Y ≃ₜ X)

end PiBase
