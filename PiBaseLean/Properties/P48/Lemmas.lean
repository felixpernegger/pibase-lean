module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P48.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.totallySeparatedSpace : WellDefined TotallySeparatedSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    rw [totallySeparatedSpace_iff_exists_isClopen] at h ⊢
    intro x y hne
    have hne' : φ.symm x ≠ φ.symm y := by
      intro heq
      apply hne
      calc x = φ (φ.symm x) := (φ.apply_symm_apply x).symm
        _ = φ (φ.symm y) := by rw [heq]
        _ = y := φ.apply_symm_apply y
    obtain ⟨U, hU, hxU, hyU⟩ := h hne'
    refine ⟨φ '' U, ⟨φ.isClosed_image.mpr hU.1, φ.isOpen_image.mpr hU.2⟩,
      ⟨φ.symm x, hxU, φ.apply_symm_apply x⟩, ?_⟩
    rw [Set.mem_compl_iff, Set.mem_image]
    rintro ⟨u, huU, huEq⟩
    have : u = φ.symm y := by
      calc u = φ.symm (φ u) := (φ.symm_apply_apply u).symm
        _ = φ.symm y := by rw [huEq]
    rw [this] at huU
    exact (Set.mem_compl_iff _ _).mp hyU huU

end Meta

end PiBase
