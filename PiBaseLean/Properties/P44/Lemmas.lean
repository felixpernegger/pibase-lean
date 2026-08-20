module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P44.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace


section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.biconnectedSpace : WellDefined BiconnectedSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    have hpX : PreconnectedSpace X := h.toPreconnectedSpace
    have hpY : PreconnectedSpace Y := φ.surjective.denseRange.preconnectedSpace φ.continuous
    refine ⟨fun s v hCs hNs hCv hNv => ?_⟩
    have : ConnectedSpace s := hCs
    have : ConnectedSpace v := hCv
    have eS : (φ ⁻¹' s) ≃ₜ s := (IsHomeo.subset_preimage φ s).some
    have eV : (φ ⁻¹' v) ≃ₜ v := (IsHomeo.subset_preimage φ v).some
    have hCsX : ConnectedSpace (φ ⁻¹' s) :=
      eS.symm.surjective.connectedSpace eS.symm.continuous
    have hCvX : ConnectedSpace (φ ⁻¹' v) :=
      eV.symm.surjective.connectedSpace eV.symm.continuous
    obtain ⟨x, hxs, hxv⟩ :=
      h.no_partition _ _ hCsX (hNs.preimage φ.surjective) hCvX (hNv.preimage φ.surjective)
    exact ⟨φ x, hxs, hxv⟩

end Meta

end PiBase
