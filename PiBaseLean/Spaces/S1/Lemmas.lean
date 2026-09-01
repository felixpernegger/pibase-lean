module

public meta import PiBaseLean.Audit.Spaces.Registry
public import PiBaseLean.Properties.P52.Bundled
public import PiBaseLean.Spaces.Constructions.Finite.Lemmas
public import PiBaseLean.Spaces.S1.Defs

@[expose] public section

namespace PiBase.Formal

/-! ## Direct catalog traits -/

theorem S1_P52 : P52 PiBase.S1 := by
  change DiscreteTopology PiBase.S1
  infer_instance

register_certificate S000001 P000052 true
  proof PiBase.Formal.S1_P52
  provenance direct
  assumptions []

theorem S1_P125 : P125 PiBase.S1 :=
  P125.well_defined PiBase.S1_canonicalHomeomorph.symm
    (show Nontrivial (PiBase.SpaceConstructions.FiniteDiscrete 2) from inferInstance)

register_certificate S000001 P000125 true
  proof PiBase.Formal.S1_P125
  provenance direct
  assumptions []

theorem S1_P175_not : ¬P175 PiBase.S1 := by
  intro h
  exact PiBase.SpaceConstructions.finiteDiscreteTwo_not_cardGeThree
    (P175.well_defined PiBase.S1_canonicalHomeomorph h)

register_certificate S000001 P000175 false
  proof PiBase.Formal.S1_P175_not
  provenance direct
  assumptions []

end PiBase.Formal
