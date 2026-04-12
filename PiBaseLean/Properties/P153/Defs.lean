module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P66.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 153. ω-Menger -/
class OmegaMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  omega_menger : Omega MengerSpace X

end PiBase

namespace PiBase.Formal

def P153 : Property where
  toPred := OmegaMengerSpace
  well_defined φ h := sorry

end PiBase.Formal
