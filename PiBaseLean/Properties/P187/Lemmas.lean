module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P187.Defs

@[expose] public section

universe u v

namespace PiBase

open Topology Filter

namespace Formal

section Transport

variable {M : Type u} {N : Type v}

/-- Mapping an initial segment of a sequence is the initial segment of the mapped sequence. -/
theorem ofFun_map (g : M → N) (f : ℕ → M) (k : ℕ) :
    (List.ofFun f k).map g = List.ofFun (fun n => g (f n)) k := by
  induction k with
  | zero => rfl
  | succ k ih => simp [List.ofFun, ih]

/-- Transport of `Game.ofAllowed` payoffs along a map `Ψ` of the move type. -/
theorem ofAllowed_isPayoff_iff (Ψ : N → M) {G : Game M} {H : Game N}
    {S : AllowedMoves M} {T : AllowedMoves N}
    (hST : ∀ l : List N, T l ↔ S (l.map Ψ))
    (hGH : ∀ c : ℕ → N, H.IsPayoff c ↔ G.IsPayoff (fun n => Ψ (c n)))
    (b : ℕ → N) :
    (Game.ofAllowed H T).IsPayoff b ↔ (Game.ofAllowed G S).IsPayoff (fun n => Ψ (b n)) := by
  simp only [Game.ofAllowed, ← ofFun_map Ψ b, hST, hGH]

/-- Transport a winning strategy for player A along a retraction `Ψ ∘ Φ = id` of the move type. -/
theorem hasWinningStrategyA_of_comap (Ψ : N → M) (Φ : M → N) (hΨΦ : ∀ p : M, Ψ (Φ p) = p)
    {G : Game M} {H : Game N}
    (hpay : ∀ b : ℕ → N, H.IsPayoff b ↔ G.IsPayoff (fun n => Ψ (b n)))
    (h : HasWinningStrategyA G) : HasWinningStrategyA H := by
  obtain ⟨f, hf⟩ := h
  refine ⟨fun l => Φ (f (l.map Ψ)), fun b hb => (hpay b).2 (hf _ fun n => ?_)⟩
  show Ψ (b (2 * n)) = f (List.ofFun (fun m => Ψ (b m)) (2 * n))
  rw [← ofFun_map Ψ b (2 * n)]
  simp only [hb n, hΨΦ]

end Transport

section WGame

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

/-- The move of the `wGame` on `X` corresponding to a move of the `wGame` on `Y`
along a homeomorphism `φ : X ≃ₜ Y`. -/
def wMoveComap (φ : X ≃ₜ Y) (q : Y × Set Y) : X × Set X := (φ.symm q.1, φ ⁻¹' q.2)

/-- The move of the `wGame` on `Y` corresponding to a move of the `wGame` on `X`
along a homeomorphism `φ : X ≃ₜ Y`. -/
def wMoveMap (φ : X ≃ₜ Y) (p : X × Set X) : Y × Set Y := (φ p.1, φ '' p.2)

theorem wMoveComap_wMoveMap (φ : X ≃ₜ Y) (p : X × Set X) :
    wMoveComap φ (wMoveMap φ p) = p := by
  simp [wMoveComap, wMoveMap, Set.preimage_image_eq _ φ.injective]

theorem wMoveComap_default (φ : X ≃ₜ Y) (y : Y) :
    wMoveComap φ (y, (∅ : Set Y)) = (φ.symm y, (∅ : Set X)) := by
  simp [wMoveComap]

theorem preimage_mem_nhds_symm_iff (φ : X ≃ₜ Y) (y : Y) (S : Set Y) :
    φ ⁻¹' S ∈ 𝓝 (φ.symm y) ↔ S ∈ 𝓝 y := by
  rw [← Filter.mem_map, φ.map_nhds_eq, φ.apply_symm_apply]

/-- The allowed moves of the `wGame` at `y` correspond to the allowed moves of the `wGame`
at `φ.symm y` under `wMoveComap φ`. -/
theorem wAllowed_comap_iff (φ : X ≃ₜ Y) (y : Y) (l : List (Y × Set Y)) :
    (l ≠ [] → (Odd l.length → (l.getLastD (y, ∅)).2 ∈ 𝓝 y) ∧
        (Even l.length → (l.getLastD (y, ∅)).1 ∈ (l.dropLast.getLastD (y, ∅)).2)) ↔
      (l.map (wMoveComap φ) ≠ [] →
        (Odd (l.map (wMoveComap φ)).length →
            ((l.map (wMoveComap φ)).getLastD (φ.symm y, ∅)).2 ∈ 𝓝 (φ.symm y)) ∧
          (Even (l.map (wMoveComap φ)).length →
            ((l.map (wMoveComap φ)).getLastD (φ.symm y, ∅)).1 ∈
              ((l.map (wMoveComap φ)).dropLast.getLastD (φ.symm y, ∅)).2)) := by
  rw [← wMoveComap_default φ y, ← List.map_dropLast, List.getLastD_map, List.getLastD_map]
  simp [wMoveComap, preimage_mem_nhds_symm_iff]

end WGame

end Formal

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.wSpace : WellDefined WSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun y => ?_⟩
    refine Formal.hasWinningStrategyA_of_comap (Formal.wMoveComap φ) (Formal.wMoveMap φ)
      (Formal.wMoveComap_wMoveMap φ) (fun b => ?_) (h.w_space (φ.symm y))
    unfold wGame
    refine Formal.ofAllowed_isPayoff_iff (Formal.wMoveComap φ) ?_ ?_ b
    · exact Formal.wAllowed_comap_iff φ y
    · intro c
      change Tendsto (fun n => (c (2 * n + 1)).1) atTop (𝓝 y) ↔
        Tendsto (fun n => (Formal.wMoveComap φ (c (2 * n + 1))).1) atTop (𝓝 (φ.symm y))
      rw [φ.symm.isInducing.tendsto_nhds_iff (f := fun n => (c (2 * n + 1)).1)]
      simp [Function.comp_def, Formal.wMoveComap]

end PiBase
