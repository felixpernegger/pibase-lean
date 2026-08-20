module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P180.Defs
public import PiBaseLean.Properties.P26.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hereditarilySeparableSpace : WellDefined HereditarilySeparableSpace :=
  fun hXY hX => ⟨(Hereditarily.wellDefined WellDefined.separableSpace) hXY hX.subset_separable⟩

end Meta

end PiBase
