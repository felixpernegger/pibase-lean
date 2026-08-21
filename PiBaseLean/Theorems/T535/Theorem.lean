module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P122.Bundled
public import PiBaseLean.Properties.P123.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T535: P123 (LocallyNEuclideanSpace) => P122 (LocallyEuclideanSpace) -/
instance instLocallyEuclideanSpaceOfLocallyNEuclideanSpace {X : Type u}
    [TopologicalSpace X] [h : LocallyNEuclideanSpace X] :
    LocallyEuclideanSpace X where
  locally_homeomorph x :=
    let ⟨n, hn⟩ := h.locally_homeomorph
    ⟨n, hn x⟩

end PiBase

namespace PiBase.Formal

theorem T535 : P123 ≤ P122 := fun X _ ↦ @instLocallyEuclideanSpaceOfLocallyNEuclideanSpace X _

end PiBase.Formal
