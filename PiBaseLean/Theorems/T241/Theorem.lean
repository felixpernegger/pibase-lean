module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P179.Bundled
public import PiBaseLean.Properties.P74.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T241: P179 (AlephZeroSpace) => P74 (CosmicSpace) -/
instance instCosmicSpaceOfAlephZeroSpace {X : Type u}
    [TopologicalSpace X] [h : AlephZeroSpace X] :
    CosmicSpace X where
  has_countable_network :=
    let ⟨ι, f, fc, hf⟩ := h.ex_network
    ⟨ι, f, fc, hf.isNetwork⟩

end PiBase

namespace PiBase.Formal

theorem T241 : P179 ≤ P74 := fun X _ ↦ @instCosmicSpaceOfAlephZeroSpace X _

end PiBase.Formal
