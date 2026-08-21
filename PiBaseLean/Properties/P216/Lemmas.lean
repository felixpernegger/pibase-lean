module

public import PiBaseLean.Properties.P216.Defs

import PiBaseLean.Properties.P30.Lemmas

@[expose] public section

namespace PiBase

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hereditarilyParacompact : WellDefined HereditarilyParacompact :=
  fun hXY hX => ⟨(Hereditarily.wellDefined WellDefined.paracompactSpace) hXY hX.subset_paracompact⟩

end Meta

end PiBase
