module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P149.Defs
public import PiBaseLean.Properties.P18.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.omegaLindelof : WellDefined OmegaLindelof :=
  fun hXY h => ⟨Omega.wellDefined WellDefined.lindelofSpace hXY h.omega_lindelof⟩

end Meta

end PiBase
