module

public meta import PiBaseLean.Audit.Spaces.Registry
public import PiBaseLean.Spaces.Constructions.Finite.Defs

@[expose] public section

namespace PiBase

/-- Pi-Base S000001: the discrete topology on a two-point set. -/
def S1 := SpaceConstructions.FiniteDiscrete 2

instance : TopologicalSpace S1 :=
  SpaceConstructions.instTopologicalSpaceFiniteDiscrete 2

instance : DiscreteTopology S1 :=
  SpaceConstructions.instDiscreteTopologyFiniteDiscrete 2

/-- The canonical presentation of S000001 as the finite discrete two-point space. -/
def S1_canonicalHomeomorph : S1 ≃ₜ SpaceConstructions.FiniteDiscrete 2 :=
  Homeomorph.refl S1

register_space S000001
  carrier PiBase.S1
  canonical PiBase.S1_canonicalHomeomorph
  assumptions []

end PiBase
