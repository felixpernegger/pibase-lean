module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P120.Defs
public import PiBaseLean.Properties.P133.Defs
public import PiBaseLean.Properties.P133.Lemmas

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T750: P133 (Lots) => P120 (LocallyOrderableSpace) -/
instance instLocallyOrderableSpaceOfLots (X : Type u)
    [TopologicalSpace X] [h : Lots X] :
    LocallyOrderableSpace X where
  ex_nbhd_lots _ := ⟨univ, univ_mem, (WellDefined.Set.univ WellDefined.lots).mp h⟩

end PiBase

namespace PiBase.Formal

theorem T750 : P133 ≤ P120 := fun X _ ↦ @instLocallyOrderableSpaceOfLots X _

end PiBase.Formal
