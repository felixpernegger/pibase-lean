module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P216.Defs
public import PiBaseLean.Properties.P30.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hereditarilyParacompact : WellDefined HereditarilyParacompact :=
  fun hXY hX => ⟨(Hereditarily.wellDefined WellDefined.paracompactSpace) hXY hX.subset_paracompact⟩

end Meta

end PiBase
