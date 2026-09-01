module

public meta import PiBaseLean.Audit.Spaces.Registry
public import PiBaseLean.Properties.P129.Bundled
public import PiBaseLean.Spaces.Constructions.Finite.Lemmas
public import PiBaseLean.Spaces.S4.Defs

@[expose] public section

namespace PiBase.Formal

/-! ## Direct catalog traits -/

theorem S4_P125 : P125 PiBase.S4 :=
  P125.well_defined PiBase.S4_canonicalHomeomorph.symm
    (show Nontrivial (PiBase.SpaceConstructions.FiniteIndiscrete 2) from inferInstance)

register_certificate S000004 P000125 true
  proof PiBase.Formal.S4_P125
  provenance direct
  assumptions []

theorem S4_P129 : P129 PiBase.S4 := by
  change IndiscreteTopology PiBase.S4
  infer_instance

register_certificate S000004 P000129 true
  proof PiBase.Formal.S4_P129
  provenance direct
  assumptions []

theorem S4_P175_not : ¬P175 PiBase.S4 := by
  intro h
  exact PiBase.SpaceConstructions.finiteIndiscreteTwo_not_cardGeThree
    (P175.well_defined PiBase.S4_canonicalHomeomorph h)

register_certificate S000004 P000175 false
  proof PiBase.Formal.S4_P175_not
  provenance direct
  assumptions []

end PiBase.Formal
