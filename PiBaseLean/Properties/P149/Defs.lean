module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 149. ω-Lindelöf -/
class OmegaLindelof (X : Type u) [TopologicalSpace X] : Prop where
  omega_lindelof : Omega LindelofSpace X

end PiBase
