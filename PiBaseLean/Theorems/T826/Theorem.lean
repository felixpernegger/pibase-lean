module

public import Mathlib.Data.SetLike.Fintype
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P90.Defs
public import PiBaseLean.Properties.P226.Lemmas

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem T826: P226 (ArtinianSpace) => P90 (Alexandrov) -/
#check instAlexandrovDiscreteOfArtinianSpace

end PiBase
