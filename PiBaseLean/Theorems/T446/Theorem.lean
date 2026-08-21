module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P137.Bundled
public import PiBaseLean.Properties.P89.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T446: P89 (FixedPointSpace) => P137ᶜ (Nonempty) -/
theorem instNonemptyOfFixedPointSpace {X : Type u}
    [TopologicalSpace X] [h : FixedPointSpace X] :
    Nonempty X := .intro (h.fixed_point ⟨id, continuous_id⟩).choose

end PiBase

namespace PiBase.Formal

theorem T446 : P89 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@instNonemptyOfFixedPointSpace X _ h)

end PiBase.Formal
