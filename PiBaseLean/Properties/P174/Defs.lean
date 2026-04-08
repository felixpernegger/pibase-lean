module

public import Mathlib.Topology.Defs.Filter
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 174. Well-based -/
class WellBasedSpace (X : Type u) [TopologicalSpace X] : Prop where
  basis_ordered : ∀ x : X, ∃ (ι : Type u) (s : ι → Set X), (∀ i : ι, x ∈ s i) ∧
    HasBasis (𝓝 x) (fun _ ↦ True) s ∧ ∀ (i j : ι), s i ⊆ s j ∨ s j ⊆ s i

end PiBase

namespace PiBase.Formal

def P174 : Property where
  toPred := WellBasedSpace
  well_defined φ h := sorry

end PiBase.Formal
