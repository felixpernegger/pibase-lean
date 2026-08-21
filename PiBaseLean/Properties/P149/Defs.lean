module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

/- 149. ω-Lindelöf -/
class OmegaLindelof (X : Type u) [TopologicalSpace X] : Prop where
  omega_lindelof : Omega LindelofSpace X

end PiBase
