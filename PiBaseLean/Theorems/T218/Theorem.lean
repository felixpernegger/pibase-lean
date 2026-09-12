module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P52.Bundled
public import PiBaseLean.Properties.P94.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

/-- Theorem T218: P52 (DiscreteTopology) => P94 (LocallyFiniteSpace)

In a discrete space `{x}` is an open, and finite, neighbourhood of `x`. -/
theorem instLocallyFiniteSpaceOfDiscreteTopology {X : Type u} [TopologicalSpace X]
    [DiscreteTopology X] : LocallyFiniteSpace X :=
  ⟨fun x ↦ ⟨{x}, by simp, finite_singleton x⟩⟩

end PiBase

namespace PiBase.Formal

theorem T218 : P52 ≤ P94 := fun X _ h ↦ @instLocallyFiniteSpaceOfDiscreteTopology X _ h

end PiBase.Formal
