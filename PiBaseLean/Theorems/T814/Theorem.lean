module

public import Mathlib
public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P129.Bundled
public import PiBaseLean.Properties.P219.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T814: P129 (IndiscreteTopology) => P219 (TorontoSpace) -/
theorem instTorontoSpaceOfIndiscreteTopology (X : Type u)
    [TopologicalSpace X] [h : IndiscreteTopology X] :
    TorontoSpace X :=
      ⟨fun _ h1 ↦ ⟨(Cardinal.eq.mp h1).some, continuous_of_indiscreteTopology,
    continuous_of_indiscreteTopology⟩⟩

end PiBase

namespace PiBase.Formal
theorem T814 : P129 ≤ P219 := fun X _ ↦ @instTorontoSpaceOfIndiscreteTopology X _
end PiBase.Formal
