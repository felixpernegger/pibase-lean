module

public import PiBaseLean.Properties.P215.Defs

import PiBaseLean.Properties.P162.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hereditarilyRealcompactSpace : WellDefined HereditarilyRealcompactSpace :=
  fun hXY hX => ⟨(Hereditarily.wellDefined WellDefined.realcompactSpace) hXY hX.subset_realcompact⟩

end PiBase
