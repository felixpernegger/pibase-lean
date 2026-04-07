module

public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Set

namespace PiBase

/-- 139. Has an isolated point -/
class HasAnIsolatedPoint (X : Type*) [TopologicalSpace X] : Prop where
  ex_isolated : ∃ x : X, IsOpen {x}

end PiBase

namespace PiBase.Formal

def P139 : Property where
  toPred := HasAnIsolatedPoint
  well_defined φ h := by
    rcases h.ex_isolated with ⟨x, hx⟩
    refine ⟨φ x, ?_⟩
    convert φ.isOpen_image.2 hx
    simp only [image_singleton]

end PiBase.Formal
