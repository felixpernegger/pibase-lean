module

public import PiBaseLean.Properties.P149.Defs

import PiBaseLean.Properties.P18.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.omegaLindelof : WellDefined OmegaLindelof :=
  fun hXY h => ⟨Omega.wellDefined WellDefined.lindelofSpace hXY h.omega_lindelof⟩

end PiBase
