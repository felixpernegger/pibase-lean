module

public import Mathlib.Logic.Equiv.Bool
public import Mathlib.Topology.Homeomorph.Defs
public import Mathlib.Topology.Maps.Basic
public import Mathlib.Topology.Order

@[expose] public section

namespace PiBase.SpaceConstructions

/-- The canonical Sierpiński space, using Mathlib's topology on propositions. -/
abbrev Sierpinski := Prop

/-- The catalog presentation of the Sierpiński space on `Bool`, where `{false}` is open. -/
def SierpinskiBool := Bool

/-- The catalog's distinguished point corresponds to `True` in the canonical presentation. -/
noncomputable def sierpinskiBoolEquiv : SierpinskiBool ≃ Sierpinski :=
  Equiv.boolNot.trans Equiv.propEquivBool.symm

noncomputable instance : TopologicalSpace SierpinskiBool :=
  TopologicalSpace.induced sierpinskiBoolEquiv sierpinskiSpace

/-- The catalog presentation is explicitly homeomorphic to the canonical Sierpiński space. -/
noncomputable def sierpinskiBoolHomeomorph : SierpinskiBool ≃ₜ Sierpinski :=
  sierpinskiBoolEquiv.toHomeomorphOfIsInducing (.induced sierpinskiBoolEquiv)

end PiBase.SpaceConstructions
