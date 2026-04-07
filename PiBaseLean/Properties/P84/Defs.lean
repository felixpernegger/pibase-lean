import Mathlib.Topology.Separation.Hausdorff
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 84. Locally T2 -/
class LocallyT2Space (X : Type*) [TopologicalSpace X] : Prop where
  locally_t2 : ∀ (x : X), ∃ C : Set X, C ∈ 𝓝 x ∧ T2Space C

end PiBase

namespace PiBase.Formal

def P84 : Property where
  toPred := LocallyT2Space
  well_defined φ h := sorry

end PiBase.Formal
