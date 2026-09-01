module

public meta import PiBaseLean.Audit.Spaces.Registry
public import PiBaseLean.Spaces.Constructions.Finite.Defs

@[expose] public section

namespace PiBase

/-- Pi-Base S000189: the discrete topology on a three-point set. -/
def S189 := SpaceConstructions.FiniteDiscrete 3

instance : TopologicalSpace S189 :=
  SpaceConstructions.instTopologicalSpaceFiniteDiscrete 3

instance : DiscreteTopology S189 :=
  SpaceConstructions.instDiscreteTopologyFiniteDiscrete 3

/-- The canonical presentation of S000189 as the finite discrete three-point space. -/
def S189_canonicalHomeomorph : S189 ≃ₜ SpaceConstructions.FiniteDiscrete 3 :=
  Homeomorph.refl S189

register_space S000189
  carrier PiBase.S189
  canonical PiBase.S189_canonicalHomeomorph
  assumptions []

end PiBase
