module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P227.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace Cardinal

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

-- Transport

-- Transport DiscreteTopology on subtype via subtype homeomorphism,
-- closedness via Homeomorph closed image, cardinal via mk_image_eq.
theorem WellDefined.hasClosedDiscreteSubsetCardContinuum :
    WellDefined HasClosedDiscreteSubsetCardContinuum :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
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

end Meta

end PiBase
