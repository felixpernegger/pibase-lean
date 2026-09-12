module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P86.Bundled
public import PiBaseLean.Properties.P129.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T349: P129 ≤ P86

Every map into an indiscrete space is continuous, so the transposition swapping `x` and `y`
is a homeomorphism carrying `x` to `y`. -/
theorem instHomogeneousSpaceOfIndiscreteTopology [IndiscreteTopology X] :
    HomogeneousSpace X := by
  classical
  exact ⟨fun x y ↦ ⟨⟨Equiv.swap x y, continuous_of_indiscreteTopology,
    continuous_of_indiscreteTopology⟩, Equiv.swap_apply_left x y⟩⟩

end PiBase

namespace PiBase.Formal

theorem T349 : P129 ≤ P86 := fun X _ h ↦ @instHomogeneousSpaceOfIndiscreteTopology X _ h

end PiBase.Formal
