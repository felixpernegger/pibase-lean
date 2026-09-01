module

public meta import PiBaseLean.Audit.Spaces.Registry
public import PiBaseLean.Spaces.Constructions.Finite.Defs

@[expose] public section

namespace PiBase

/-- Pi-Base S000004: the indiscrete topology on a two-point set. -/
def S4 := SpaceConstructions.FiniteIndiscrete 2

instance : TopologicalSpace S4 :=
  SpaceConstructions.instTopologicalSpaceFiniteIndiscrete 2

instance : IndiscreteTopology S4 :=
  SpaceConstructions.instIndiscreteTopologyFiniteIndiscrete 2

/-- The canonical presentation of S000004 as the finite indiscrete two-point space. -/
def S4_canonicalHomeomorph : S4 ≃ₜ SpaceConstructions.FiniteIndiscrete 2 :=
  Homeomorph.refl S4

register_space S000004
  carrier PiBase.S4
  canonical PiBase.S4_canonicalHomeomorph
  assumptions []

end PiBase
