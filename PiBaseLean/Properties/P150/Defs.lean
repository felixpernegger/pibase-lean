module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P68.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 150. ω-Rothberger -/
class OmegaRothberger (X : Type u) [TopologicalSpace X] : Prop where
  omega_rothberger : Omega RothbergerSpace X

end PiBase
