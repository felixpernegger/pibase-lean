module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P74.Defs
public import PiBaseLean.Properties.P179.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T241: P179 (AlephZeroSpace) => P74 (CosmicSpace) -/
instance instCosmicSpaceOfAlephZeroSpace (X : Type u)
    [TopologicalSpace X] [h : AlephZeroSpace X] :
    CosmicSpace X where
  has_countable_network :=
    let ⟨ι, f, fc, hf⟩ := h.ex_network
    ⟨ι, f, fc, hf.isNetwork⟩

end PiBase

namespace PiBase.Formal

theorem T241 : P179 ≤ P74 := fun X _ ↦ @instCosmicSpaceOfAlephZeroSpace X _

end PiBase.Formal
