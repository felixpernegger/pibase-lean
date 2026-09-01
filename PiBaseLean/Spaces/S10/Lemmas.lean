module

public meta import PiBaseLean.Audit.Spaces.Registry
public import PiBaseLean.Spaces.Constructions.Sierpinski.Lemmas
public import PiBaseLean.Spaces.S10.Defs

@[expose] public section

namespace PiBase.Formal

/-! ## Direct catalog traits -/

theorem S10_P125 : P125 PiBase.S10 :=
  P125.well_defined PiBase.S10_canonicalHomeomorph.symm
    (show Nontrivial PiBase.SpaceConstructions.Sierpinski from inferInstance)

register_certificate S000010 P000125 true
  proof PiBase.Formal.S10_P125
  provenance direct
  assumptions []

theorem S10_P175_not : ¬P175 PiBase.S10 := by
  intro h
  exact PiBase.SpaceConstructions.sierpinski_not_cardGeThree
    (P175.well_defined PiBase.S10_canonicalHomeomorph h)

register_certificate S000010 P000175 false
  proof PiBase.Formal.S10_P175_not
  provenance direct
  assumptions []

theorem S10_P196 : P196 PiBase.S10 :=
  P196.well_defined PiBase.S10_canonicalHomeomorph.symm
    (show PiBase.HereditarilyConnected PiBase.SpaceConstructions.Sierpinski from inferInstance)

register_certificate S000010 P000196 true
  proof PiBase.Formal.S10_P196
  provenance direct
  assumptions []

theorem S10_P201 : P201 PiBase.S10 :=
  P201.well_defined PiBase.S10_canonicalHomeomorph.symm
    (show PiBase.HasGenericPoint PiBase.SpaceConstructions.Sierpinski from inferInstance)

register_certificate S000010 P000201 true
  proof PiBase.Formal.S10_P201
  provenance direct
  assumptions []

theorem S10_P203 : P203 PiBase.S10 :=
  P203.well_defined PiBase.S10_canonicalHomeomorph.symm
    (show PiBase.AlmostDiscreteSpace PiBase.SpaceConstructions.Sierpinski from inferInstance)

register_certificate S000010 P000203 true
  proof PiBase.Formal.S10_P203
  provenance direct
  assumptions []

end PiBase.Formal
