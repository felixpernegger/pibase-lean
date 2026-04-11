module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P28.Defs
public import PiBaseLean.Properties.P110.Defs

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

open PiBase.AdditionalDefs

/-- Theorem T710: P110 (DevelopableSpace) => P28 (FirstCountableTopology) -/
instance instFirstCountableTopologyOfDevelopableSpace (X : Type u)
    [TopologicalSpace X] [h : DevelopableSpace X] :
    FirstCountableTopology X where
  nhds_generated_countable x :=
    let ⟨_, _, _, _, h'⟩ := h.developable.some
    (h' x).isCountablyGenerated

end PiBase

namespace PiBase.Formal

theorem T710 : P110 ≤ P28 := fun X _ ↦ @instFirstCountableTopologyOfDevelopableSpace X _

end PiBase.Formal
