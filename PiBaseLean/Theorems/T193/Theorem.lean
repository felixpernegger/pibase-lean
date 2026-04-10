module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P3.Defs
public import PiBaseLean.Properties.P84.Defs

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T193: P3 (T2Space) => P84 (LocallyT2Space) -/
instance instLocallyT2SpaceOfT2Space (X : Type u)
    [TopologicalSpace X] [T2Space X] :
    LocallyT2Space X where
  locally_t2 _ := ⟨univ, univ_mem, instT2SpaceSubtype⟩

end PiBase

namespace PiBase.Formal

theorem T193 : P3 ≤ P84 := fun X _ ↦ @instLocallyT2SpaceOfT2Space X _

end PiBase.Formal
