import Mathlib.Topology.Metrizable.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 82. Locally metrizable -/
class LocallyMetrizableSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_metrizable : ∀ (x : X), ∃ C : Set X, C ∈ 𝓝 x ∧ MetrizableSpace C

end PiBase

namespace PiBase.Formal

def P82 : Property where
  toPred := LocallyMetrizableSpace
  well_defined' φ h := sorry

end PiBase.Formal
