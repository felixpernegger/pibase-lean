import Mathlib.Topology.Defs.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function TopologicalSpace

namespace PiBase

/- 107. Has a closed point -/
class HasClosedPoint (X : Type*) [TopologicalSpace X] : Prop where
  has_closed_point : ∃ x : X, IsClosed {x}

end PiBase

namespace PiBase.Formal

def P107 : Property where
  toPred := HasClosedPoint
  well_defined φ h := by
    rcases h.has_closed_point with ⟨x, hx⟩
    refine ⟨φ x, ?_⟩
    convert φ.isClosed_image.2 hx
    simp only [image_singleton]

end PiBase.Formal
