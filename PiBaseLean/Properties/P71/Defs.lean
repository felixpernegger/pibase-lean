import PiBaseLean.AdditionalDefs
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace PiBase

/- 71. σ-relatively compact -/
class SigmaRelativelyCompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  sigma_relatively_compact : ∃ R : ℕ → Set X, X = ⋃ n : ℕ, R n ∧ ∀ n : ℕ, IsRelativelyCompact (R n)

end PiBase

namespace PiBase.Formal

def P71 : Property where
  toPred := SigmaRelativelyCompactSpace
  well_defined φ h := sorry

end PiBase.Formal
