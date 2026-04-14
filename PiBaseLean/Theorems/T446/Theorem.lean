module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P89.Defs
public import PiBaseLean.Properties.P137.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T446: P89 (FixedPointSpace) => P137ᶜ (Nonempty) -/
theorem instNonemptyOfFixedPointSpace (X : Type u)
    [TopologicalSpace X] [h : FixedPointSpace X] :
    Nonempty X := .intro (h.fixed_point ⟨id, continuous_id⟩).choose

end PiBase

namespace PiBase.Formal

theorem T446 : P89 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@instNonemptyOfFixedPointSpace X _ h)

end PiBase.Formal
