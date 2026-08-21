module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P226.Bundled
public import PiBaseLean.Properties.P78.Bundled

import Mathlib.Data.SetLike.Fintype

@[expose] public section

universe u

namespace PiBase

/-- Theorem T825: P78 (Finite) => P226 (ArtinianSpace) -/
theorem instArtinianSpaceOfFinite {X : Type u}
    [TopologicalSpace X] [Finite X] :
    ArtinianSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T825 : P78 ≤ P226 := fun X _ ↦ @instArtinianSpaceOfFinite X _

end PiBase.Formal
