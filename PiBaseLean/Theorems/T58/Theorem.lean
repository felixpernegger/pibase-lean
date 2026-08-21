module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P140.Bundled
public import PiBaseLean.Properties.P23.Bundled

@[expose] public section

universe u

namespace PiBase

/- Theorem T58: P23 (WeaklyLocallyCompactSpace) => P140 (CompactlyCoherentSpace) -/
#guard_msgs (drop info) in
#check CompactlyCoherentSpace.of_weaklyLocallyCompactSpace

end PiBase

namespace PiBase.Formal

theorem T58 : P23 ≤ P140 := fun X _ _ ↦ by
  simp_all only [P23, P140]
  infer_instance

end PiBase.Formal
