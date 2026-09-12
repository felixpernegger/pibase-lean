module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P137.Bundled
public import PiBaseLean.Properties.P155.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T757: P137 (IsEmpty) => P155 (LocallyOneEuclideanSpace)

Being locally 1-Euclidean is a condition on every point, so it is vacuous on a space
with no points. -/
theorem instLocallyOneEuclideanSpaceOfIsEmpty {X : Type u} [TopologicalSpace X] [IsEmpty X] :
    LocallyOneEuclideanSpace X :=
  ⟨fun x ↦ isEmptyElim x⟩

end PiBase

namespace PiBase.Formal

theorem T757 : P137 ≤ P155 := fun X _ h ↦ @instLocallyOneEuclideanSpaceOfIsEmpty X _ h

end PiBase.Formal
