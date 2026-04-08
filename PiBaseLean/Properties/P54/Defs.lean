module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 54. Has a σ-locally finite basis -/
class HasSigmaLocallyFiniteBasis (X : Type u) [TopologicalSpace X] : Prop where
  ex_basis : ∃ (ι : Type u), ∃ (f : ι → Set X),
    Sigma LocallyFinite f ∧ (∀ (i : ι), IsOpen (f i)) ∧
      ∀ᵉ (x : X) (s ∈ 𝓝 x), ∃ (i : ι), x ∈ f i ∧ f i ⊆ s

end PiBase

namespace PiBase.Formal

def P54 : Property where
  toPred := HasSigmaLocallyFiniteBasis
  well_defined φ h := sorry

end PiBase.Formal
