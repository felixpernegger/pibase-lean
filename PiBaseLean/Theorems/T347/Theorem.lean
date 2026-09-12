module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P86.Bundled
public import PiBaseLean.Properties.P87.Bundled

import Mathlib.Topology.Algebra.Group.Basic

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T347: P87 ≤ P86

Left translation by `y * x⁻¹` is a homeomorphism carrying `x` to `y`. -/
theorem instHomogeneousSpaceOfHasGroupTopology [h : HasGroupTopology X] : HomogeneousSpace X :=
  let ⟨_, _⟩ := h.has_group_topology
  ⟨fun x y ↦ ⟨Homeomorph.mulLeft (y * x⁻¹), by simp⟩⟩

end PiBase

namespace PiBase.Formal

theorem T347 : P87 ≤ P86 := fun X _ h ↦ @instHomogeneousSpaceOfHasGroupTopology X _ h

end PiBase.Formal
