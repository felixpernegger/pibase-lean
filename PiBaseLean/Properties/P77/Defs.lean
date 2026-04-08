module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 77. Corson compact -/
class CorsonCompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  homoeo_compact : ∃ α : Type u, ∃ s : Set (SigmaProduct (fun (_ : α) ↦ (0 : ℝ))),
    IsCompact s ∧ Nonempty (s ≃ₜ X)

end PiBase

namespace PiBase.Formal

def P77 : Property where
  toPred := CorsonCompactSpace
  well_defined φ h := sorry

end PiBase.Formal
