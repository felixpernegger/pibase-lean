module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P11.Defs
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P64.Defs
public import Mathlib.Topology.Baire.LocallyCompactRegular

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T136: P23 (WeaklyLocallyCompactSpace) + P11 (RegularSpace) => P64 (BaireSpace) -/
theorem instBaireSpaceOfWeaklyLocallyCompactSpaceOfRegularSpace (X : Type u)
    [TopologicalSpace X] [WeaklyLocallyCompactSpace X] [RegularSpace X] : BaireSpace X :=
  BaireSpace.of_t2Space_locallyCompactSpace

end PiBase

namespace PiBase.Formal

theorem T136 : P23 ⊓ P11 ≤ P64 := fun X _ ⟨h1, h2⟩ ↦ @instBaireSpaceOfWeaklyLocallyCompactSpaceOfRegularSpace X _ h1 h2

end PiBase.Formal
