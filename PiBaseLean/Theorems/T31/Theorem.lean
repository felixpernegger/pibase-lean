module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P123.Bundled
public import PiBaseLean.Properties.P124.Bundled
public import PiBaseLean.Properties.P27.Bundled
public import PiBaseLean.Properties.P3.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T31: P123 (LocallyNEuclideanSpace) + P3 (T2Space) +
P27 (SecondCountableTopology) => P124 (TopologicalNManifold) -/
theorem instTopologicalNManifoldOfLocallyNEuclideanSpaceOfT2SpaceOfSecondCountableTopology
    {X : Type u}
    [TopologicalSpace X] [LocallyNEuclideanSpace X] [T2Space X] [SecondCountableTopology X] :
    TopologicalNManifold X := by tauto

end PiBase

namespace PiBase.Formal

theorem T31 : P123 ⊓ P3 ⊓ P27 ≤ P124 := fun X _ ⟨⟨h1, h2⟩, h3⟩ ↦
  @instTopologicalNManifoldOfLocallyNEuclideanSpaceOfT2SpaceOfSecondCountableTopology X _ h1 h2 h3

end PiBase.Formal
