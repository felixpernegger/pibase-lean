module

public meta import PiBaseLean.Audit.Spaces.Registry
public import PiBaseLean.Properties.P52.Bundled
public import PiBaseLean.Spaces.Constructions.Finite.Lemmas
public import PiBaseLean.Spaces.S189.Defs

@[expose] public section

namespace PiBase.Formal

/-! ## Direct catalog traits -/

theorem S189_P52 : P52 PiBase.S189 := by
  change DiscreteTopology PiBase.S189
  infer_instance

register_certificate S000189 P000052 true
  proof PiBase.Formal.S189_P52
  provenance direct
  assumptions []

theorem S189_P175 : P175 PiBase.S189 :=
  P175.well_defined PiBase.S189_canonicalHomeomorph.symm
    (show PiBase.CardGeThree (PiBase.SpaceConstructions.FiniteDiscrete 3) from inferInstance)

register_certificate S000189 P000175 true
  proof PiBase.Formal.S189_P175
  provenance direct
  assumptions []

theorem S189_P176_not : ¬P176 PiBase.S189 := by
  intro h
  exact PiBase.SpaceConstructions.finiteDiscreteThree_not_cardGeFour
    (P176.well_defined PiBase.S189_canonicalHomeomorph h)

register_certificate S000189 P000176 false
  proof PiBase.Formal.S189_P176_not
  provenance direct
  assumptions []

end PiBase.Formal
