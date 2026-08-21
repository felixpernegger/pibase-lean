module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P11.Bundled
public import PiBaseLean.Properties.P130.Bundled
public import PiBaseLean.Properties.P23.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T246: P23 (WeaklyLocallyCompactSpace) + P11 (RegularSpace) =>
P130 (LocallyCompactSpace) -/
theorem instLocallyCompactSpaceOfWeaklyLocallyCompactSpaceOfRegularSpace {X : Type u}
    [TopologicalSpace X] [WeaklyLocallyCompactSpace X] [RegularSpace X] :
    LocallyCompactSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T246 : P23 ⊓ P11 ≤ P130 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P23, P11, P130]
  infer_instance

end PiBase.Formal
