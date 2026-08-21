module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P196.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.hereditarilyConnected [HereditarilyConnected X] (φ : X ≃ₜ Y) :
    HereditarilyConnected Y where
  subset_connected t := by
    have h1 : IsPreconnected (φ ⁻¹' t) := HereditarilyConnected.subset_connected _
    have h2 : IsPreconnected (φ '' (φ ⁻¹' t)) := h1.image φ φ.continuous.continuousOn
    rwa [φ.image_preimage t] at h2

theorem WellDefined.hereditarilyConnected : WellDefined HereditarilyConnected :=
  fun {_ _} _ _ h _ => Homeomorph.hereditarilyConnected h.some

end PiBase
