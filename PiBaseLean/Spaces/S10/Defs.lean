module

public meta import PiBaseLean.Audit.Spaces.Registry
public import PiBaseLean.Spaces.Constructions.Sierpinski.Defs

@[expose] public section

namespace PiBase

/-- Pi-Base S000010: the Sierpiński space on `{0, 1}`, with `{0}` open. -/
def S10 := SpaceConstructions.SierpinskiBool

noncomputable instance : TopologicalSpace S10 :=
  SpaceConstructions.instTopologicalSpaceSierpinskiBool

/-- The explicit homeomorphism from the catalog presentation to canonical Sierpiński space. -/
noncomputable def S10_canonicalHomeomorph : S10 ≃ₜ SpaceConstructions.Sierpinski :=
  SpaceConstructions.sierpinskiBoolHomeomorph

register_space S000010
  carrier PiBase.S10
  canonical PiBase.S10_canonicalHomeomorph
  assumptions []

end PiBase
