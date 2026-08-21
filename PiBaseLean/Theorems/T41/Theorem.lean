module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P137.Bundled
public import PiBaseLean.Properties.P45.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T41: P45 (HasDispersionPoint) => P137 (¬IsEmpty) -/
theorem instNonemptyOfHasDispersionPoint {X : Type u}
    [TopologicalSpace X] [HasDispersionPoint X] :
    Nonempty X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T41 : P45 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@instNonemptyOfHasDispersionPoint X _ h)

end PiBase.Formal
