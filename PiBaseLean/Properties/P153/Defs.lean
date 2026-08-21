module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P66.Defs

@[expose] public section

universe u

namespace PiBase

/- 153. ω-Menger -/
class OmegaMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  omega_menger : Omega MengerSpace X

end PiBase
