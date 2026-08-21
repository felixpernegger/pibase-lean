module

public import PiBaseLean.Properties.P180.Defs

import PiBaseLean.Properties.P26.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hereditarilySeparableSpace : WellDefined HereditarilySeparableSpace :=
  fun hXY hX => ⟨(Hereditarily.wellDefined WellDefined.separableSpace) hXY hX.subset_separable⟩

end PiBase
