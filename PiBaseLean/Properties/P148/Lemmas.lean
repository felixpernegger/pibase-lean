module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P148.Defs
public import PiBaseLean.Properties.P141.Bundled
public import PiBaseLean.Properties.P143.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace


section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.cWGH : WellDefined CWGH :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    have hCWGH_X : CWGH X := h
    have hCG_X : CompactlyGeneratedSpace X := inferInstance
    have hW_X : WeakT2Space X := inferInstance
    have hCG_Y : CompactlyGeneratedSpace Y := WellDefined.compactlyGeneratedSpace.homeo φ hCG_X
    have hW_Y : WeakT2Space Y := WellDefined.weakT2Space.homeo φ hW_X
    exact @CWGH.mk _ _ hCG_Y hW_Y

end Meta

end PiBase
