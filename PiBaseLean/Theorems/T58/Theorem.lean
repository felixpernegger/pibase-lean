module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P140.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T58: P23 (WeaklyLocallyCompactSpace) => P140 (CompactlyCoherentSpace) -/
#check CompactlyCoherentSpace.of_weaklyLocallyCompactSpace

end PiBase

namespace PiBase.Formal

theorem T58 : P23 ≤ P140 := fun X _ _ ↦ by
  simp_all only [P23, P140]
  infer_instance

end PiBase.Formal
