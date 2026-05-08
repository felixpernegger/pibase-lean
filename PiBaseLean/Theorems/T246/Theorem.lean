module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P11.Defs
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P130.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T246: P23 (WeaklyLocallyCompactSpace) + P11 (RegularSpace) =>
P130 (LocallyCompactSpace) -/
theorem instLocallyCompactSpaceOfWeaklyLocallyCompactSpaceOfRegularSpace (X : Type u)
    [TopologicalSpace X] [WeaklyLocallyCompactSpace X] [RegularSpace X] :
    LocallyCompactSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T246 : P23 ⊓ P11 ≤ P130 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P23, P11, P130]
  infer_instance

end PiBase.Formal
