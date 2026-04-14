module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P3.Defs
public import PiBaseLean.Properties.P48.Defs
public import PiBaseLean.Properties.P49.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T45: P49 (ExtremallyDisconnected) + P3 (T2Space) => P48 (TotallySeparatedSpace) -/
#check instTotallySeparatedSpaceOfExtremallyDisconnectedOfT2Space

end PiBase

namespace PiBase.Formal

theorem T45 : P49 ⊓ P3 ≤ P48 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P49, P3, P48]
  infer_instance

end PiBase.Formal
