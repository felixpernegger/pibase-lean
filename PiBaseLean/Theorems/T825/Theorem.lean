module

public import Mathlib.Data.SetLike.Fintype
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P78.Defs
public import PiBaseLean.Properties.P226.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T825: P78 (Finite) => P226 (ArtinianSpace) -/
theorem instArtinianSpaceOfFinite (X : Type u)
    [TopologicalSpace X] [Finite X] :
    ArtinianSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T825 : P78 ≤ P226 := fun X _ ↦ @instArtinianSpaceOfFinite X _

end PiBase.Formal
