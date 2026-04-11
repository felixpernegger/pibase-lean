module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P107.Defs
public import PiBaseLean.Properties.P137.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T621: P107 (HasClosedPoint) => P137 (¬IsEmpty) -/
instance instNonemptyOfHasClosedPoint (X : Type u)
    [TopologicalSpace X] [h : HasClosedPoint X] :
    Nonempty X :=
  let ⟨p, _⟩ := h.has_closed_point
  .intro p

end PiBase

namespace PiBase.Formal

theorem T621 : P107 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@instNonemptyOfHasClosedPoint X _ h)

end PiBase.Formal
