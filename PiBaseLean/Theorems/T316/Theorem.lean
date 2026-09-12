module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P236.Bundled
public import PiBaseLean.Properties.P237.Bundled
public import PiBaseLean.Properties.P27.Bundled
public import PiBaseLean.Properties.P3.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T316: P236 (LocallyNEuclideanHalfSpace) + P3 (T2Space) +
P27 (SecondCountableTopology) => P237 (TopologicalNManifoldWithBoundary) -/
theorem instTopologicalNManifoldWithBoundaryOfLocallyNEuclideanHalfSpace {X : Type u}
    [TopologicalSpace X] [LocallyNEuclideanHalfSpace X] [T2Space X] [SecondCountableTopology X] :
    TopologicalNManifoldWithBoundary X := by tauto

end PiBase

namespace PiBase.Formal

theorem T316 : P236 ⊓ P3 ⊓ P27 ≤ P237 := fun X _ ⟨⟨h1, h2⟩, h3⟩ ↦
  @instTopologicalNManifoldWithBoundaryOfLocallyNEuclideanHalfSpace X _ h1 h2 h3

end PiBase.Formal
