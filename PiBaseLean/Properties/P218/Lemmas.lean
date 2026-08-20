module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P218.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.ultranormalSpace : WellDefined UltranormalSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s t hdisj hs ht
    have hsX : IsClosed (φ ⁻¹' s) := φ.isClosed_preimage.mpr hs
    have htX : IsClosed (φ ⁻¹' t) := φ.isClosed_preimage.mpr ht
    have hdisjX : Disjoint (φ ⁻¹' s) (φ ⁻¹' t) := hdisj.preimage φ
    obtain ⟨rX, hrXc, hrXsub, htXsub⟩ := h.disjoint_clopen hdisjX hsX htX
    refine ⟨φ '' rX, ?_, ?_, ?_⟩
    · have hClosed : IsClosed (φ '' rX) := φ.isClosedMap rX hrXc.1
      have hOpen : IsOpen (φ '' rX) := φ.isOpenMap rX hrXc.2
      exact ⟨hClosed, hOpen⟩
    · calc s = φ '' (φ ⁻¹' s) := (φ.image_preimage s).symm
        _ ⊆ φ '' rX := Set.image_mono hrXsub
    · intro y hy
      rintro ⟨x, hx, rfl⟩
      exact htXsub hy hx

end Meta

end PiBase
