module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P3.Bundled
public import PiBaseLean.Properties.P48.Bundled
public import PiBaseLean.Properties.P49.Bundled

@[expose] public section

universe u

namespace PiBase

/- Theorem T45: P49 (ExtremallyDisconnected) + P3 (T2Space) => P48 (TotallySeparatedSpace) -/
#guard_msgs (drop info) in
#check instTotallySeparatedSpaceOfExtremallyDisconnectedOfT2Space

end PiBase

namespace PiBase.Formal

theorem T45 : P49 ⊓ P3 ≤ P48 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P49, P3, P48]
  infer_instance

end PiBase.Formal
