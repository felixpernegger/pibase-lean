module

public import Mathlib.SetTheory.Cardinal.Continuum
public import Mathlib.Topology.Constructions
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open TopologicalSpace Cardinal

namespace PiBase

/- 227. Has a closed discrete subset of cardinality 𝔠 -/
class HasClosedDiscreteSubsetCardContinuum (X : Type*) [TopologicalSpace X] : Prop where
  ex_subset : ∃ s : Set X, IsDiscrete s ∧ IsClosed s ∧ #s = 𝔠

end PiBase

namespace PiBase.Formal

def P227 : Property where
  toPred := HasClosedDiscreteSubsetCardContinuum
  well_defined φ h := by
    obtain ⟨s, h_disc, h_closed, h_card⟩ := h.ex_subset
    -- image witness φ '' s; transport DiscreteTopology via subtype homeomorph
    -- closedness via Homeomorph closed image, cardinal via mk_image_eq
    refine ⟨φ '' s, ?_, ?_, ?_⟩
    · -- transport DiscreteTopology on subtype via subtype homeomorphism φ.image s : s ≃ₜ φ '' s
      have hDT : DiscreteTopology s := isDiscrete_iff_discreteTopology.mp h_disc
      have : DiscreteTopology (φ '' s) := by
        have := hDT
        exact (φ.image s).discreteTopology
      exact isDiscrete_iff_discreteTopology.mpr this
    · -- closedness via Homeomorph closed image
      exact φ.isClosed_image.mpr h_closed
    · -- cardinal via mk_image_eq
      rw [mk_image_eq φ.injective, h_card]

end PiBase.Formal
