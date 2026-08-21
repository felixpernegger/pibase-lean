module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P76.Defs

import Mathlib.Topology.UniformSpace.Basic

@[expose] public section

namespace PiBase

open Set Filter Topology

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.proximalSpace : WellDefined ProximalSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro hY
    -- The default point of `X` has to stay reducible, so it is introduced with `let`.
    let hX : Inhabited X := ⟨φ.symm hY.default⟩
    obtain ⟨tX, htX, hwin⟩ := h.proximal hX
    subst htX
    -- Pull the uniformity back along `φ.symm`, keeping the topology on `Y` untouched.
    refine ⟨(UniformSpace.comap φ.symm tX).replaceTopology φ.symm.isInducing.eq_induced, rfl, ?_⟩
    set tY : UniformSpace Y :=
      (UniformSpace.comap φ.symm tX).replaceTopology φ.symm.isInducing.eq_induced with htY
    -- Entourages of `Y` correspond exactly to entourages of `X`.
    have hEnt : ∀ V : Set (Y × Y),
        V ∈ @uniformity Y tY ↔ Prod.map φ φ ⁻¹' V ∈ @uniformity X tX := by
      intro V
      have huniv : @uniformity Y tY
          = Filter.comap (Prod.map (φ.symm : Y → X) φ.symm) (@uniformity X tX) := rfl
      rw [huniv, Filter.mem_comap]
      refine ⟨fun hV ↦ ?_, fun hV ↦ ⟨Prod.map φ φ ⁻¹' V, hV, fun p hp ↦ ?_⟩⟩
      · obtain ⟨U, hU, hsub⟩ := hV
        refine Filter.mem_of_superset hU fun p hp ↦ hsub ?_
        simpa using hp
      · simpa using hp
    refine HasWinningStrategyA.of_equiv (proximalMoveEquiv φ) (fun b hb ↦ ?_) hwin
    have hd : proximalMoveEquiv φ (hY.default, univ) = (hX.default, univ) := by
      change (hX.default, Prod.map (φ : X → Y) φ ⁻¹' (univ : Set (Y × Y))) = (hX.default, univ)
      rw [preimage_univ]
    refine (isPayoff_ofAllowed_iff (proximalMoveEquiv φ) (fun l ↦ ?_) b ?_).mpr hb
    · -- The allowed moves correspond to each other.
      have hlast : (l.map (proximalMoveEquiv φ)).getLastD (hX.default, univ)
          = proximalMoveEquiv φ (l.getLastD (hY.default, univ)) := by
        rw [← hd, List.getLastD_map]
      have hlast1 : (l.map (proximalMoveEquiv φ)).dropLast.getLastD (hX.default, univ)
          = proximalMoveEquiv φ (l.dropLast.getLastD (hY.default, univ)) := by
        rw [← List.map_dropLast, ← hd, List.getLastD_map]
      have hlast2 : (l.map (proximalMoveEquiv φ)).dropLast.dropLast.getLastD (hX.default, univ)
          = proximalMoveEquiv φ (l.dropLast.dropLast.getLastD (hY.default, univ)) := by
        rw [← List.map_dropLast, ← List.map_dropLast, ← hd, List.getLastD_map]
      simp only [hlast, hlast1, hlast2, List.length_map, ne_eq, List.map_eq_nil_iff,
        proximalMoveEquiv_fst, proximalMoveEquiv_snd, hEnt, preimage_prodMap_subset_iff,
        preimage_prodMap_eq_iff, EmbeddingLike.apply_eq_iff_eq, slice_preimage_prodMap,
        mem_preimage, Homeomorph.apply_symm_apply]
    · -- The payoff conditions correspond to each other.
      change ((∃ z : Y, Tendsto (fun n ↦ (b n).1) atTop (𝓝 z)) ∨
          (⋂ n, Prod.mk (b (2 * n + 1)).1 ⁻¹' (b (2 * n + 1)).2) = ∅) ↔
        ((∃ z : X, Tendsto (fun n ↦ (proximalMoveEquiv φ (b n)).1) atTop (𝓝 z)) ∨
          (⋂ n, Prod.mk (proximalMoveEquiv φ (b (2 * n + 1))).1 ⁻¹'
            (proximalMoveEquiv φ (b (2 * n + 1))).2) = ∅)
      simp only [proximalMoveEquiv_fst, proximalMoveEquiv_snd, slice_preimage_prodMap,
        ← preimage_iInter, preimage_eq_empty_iff_of_homeomorph, exists_tendsto_comp_iff]

end PiBase
