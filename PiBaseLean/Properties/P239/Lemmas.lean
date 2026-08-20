module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P239.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open Topology Filter Set Function

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.semilocallyContractibleSpace : WellDefined SemilocallyContractibleSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine @SemilocallyContractibleSpace.mk _ _ fun y => ?_
    let x := φ.symm y
    have hφx : φ x = y := φ.apply_symm_apply y
    have hy_eq : y = φ x := hφx.symm
    obtain ⟨sX, hsX_mem, fX, hfX_cont, hfX_zero, hfX_one⟩ := h.contractible_nbhd x
    have hsY : φ '' sX ∈ 𝓝 y := by
      rw [hy_eq, ← φ.map_nhds_eq x, Filter.mem_map, φ.preimage_image]
      exact hsX_mem
    have h_mem_symm : ∀ yy ∈ φ '' sX, φ.symm yy ∈ sX := by
      intro yy hyy
      obtain ⟨xx, hxx_mem, hxx_eq⟩ := hyy
      have : φ.symm yy = xx := by
        calc φ.symm yy = φ.symm (φ xx) := by rw [hxx_eq]
          _ = xx := φ.symm_apply_apply xx
      rw [this]
      exact hxx_mem
    let to_sX : (φ '' sX) → sX := fun j =>
      ⟨φ.symm j.val, h_mem_symm j.val j.property⟩
    have h_to_sX_cont : Continuous to_sX :=
      Continuous.subtype_mk
        (φ.symm.continuous.comp continuous_subtype_val)
        (fun j => h_mem_symm j.val j.property)
    let fY : unitInterval → (φ '' sX) → _ := fun t j => φ (fX t (to_sX j))
    have h_fY_cont : Continuous (Function.uncurry fY) := by
      have h_map : Continuous (fun p : unitInterval × (φ '' sX) => (p.1, to_sX p.2)) :=
        Continuous.prodMk continuous_fst (h_to_sX_cont.comp continuous_snd)
      have h_mid : Continuous (fun p : unitInterval × (φ '' sX) => fX p.1 (to_sX p.2)) := by
        have h_eq : (fun p : unitInterval × (φ '' sX) => fX p.1 (to_sX p.2)) =
            (Function.uncurry fX) ∘ (fun p : unitInterval × (φ '' sX) => (p.1, to_sX p.2)) := by
          rfl
        rw [h_eq]
        exact hfX_cont.comp h_map
      have h_eq2 : Function.uncurry fY =
          fun p : unitInterval × (φ '' sX) => φ (fX p.1 (to_sX p.2)) := by
        rfl
      rw [h_eq2]
      exact φ.continuous.comp h_mid
    have h_fY_zero : fY 0 = Subtype.val := by
      funext j
      change φ (fX 0 (to_sX j)) = j.val
      have h0 : fX 0 (to_sX j) = (to_sX j).val := by
        have := congrFun hfX_zero (to_sX j)
        simpa using this
      rw [h0]
      exact φ.apply_symm_apply j.val
    have h_fY_one : ∀ a b : (φ '' sX), fY 1 a = fY 1 b := by
      intro a b
      change φ (fX 1 (to_sX a)) = φ (fX 1 (to_sX b))
      rw [hfX_one (to_sX a) (to_sX b)]
    exact ⟨φ '' sX, hsY, fY, h_fY_cont, h_fY_zero, h_fY_one⟩

end Meta

end PiBase
