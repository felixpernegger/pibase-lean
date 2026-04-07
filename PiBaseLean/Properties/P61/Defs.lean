import PiBaseLean.AdditionalDefs
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace PiBase

/- 61. Cozero complemented -/
class CozeroComplementedSpace (X : Type*) [TopologicalSpace X] : Prop where
  cozero_complemented : ∀ s : Set X, IsCozero s → ∃ t : Set X, IsCozero t ∧ Dense (s ∪ t)

end PiBase

namespace PiBase.Formal

def P61 : Property where
  toPred := CozeroComplementedSpace
  well_defined φ h := sorry

end PiBase.Formal
