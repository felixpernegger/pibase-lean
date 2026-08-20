module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P206.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open Set

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.stronglyChoquetSpace : WellDefined StronglyChoquetSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro hY_inh
    let : Inhabited Y := hY_inh
    let iX : Inhabited X := ⟨φ.symm default⟩
    obtain ⟨fX, hfX⟩ := h.strongly_choquet iX
    let toX : Y × Set Y → X × Set X := fun p => (φ.symm p.1, φ ⁻¹' p.2)
    let toY : X × Set X → Y × Set Y := fun p => (φ p.1, φ '' p.2)
    have h_toY_toX : ∀ p : X × Set X, toX (toY p) = p := by
      intro ⟨x, U⟩
      simp only [toX, toY, φ.symm_apply_apply, φ.preimage_image]
    have hdX : (default : X) = φ.symm (default : Y) := rfl
    have h_def_toX : toX (default, (univ : Set Y)) = (default, (univ : Set X)) := by
      simp [toX, hdX]
    let S_X : List (X × Set X) → Prop := fun l =>
      IsOpen (l.getLastD (default, univ)).2 ∧
      (l.getLastD (default, univ)).2 ⊆ (l.dropLast.getLastD (default, univ)).2 ∧
      (Odd l.length → (l.getLastD (default, univ)).1 ∈ (l.getLastD (default, univ)).2) ∧
      (Even l.length → (l.dropLast.getLastD (default, univ)).1 ∈ (l.getLastD (default, univ)).2)
    let S_Y : List (Y × Set Y) → Prop := fun l =>
      IsOpen (l.getLastD (default, univ)).2 ∧
      (l.getLastD (default, univ)).2 ⊆ (l.dropLast.getLastD (default, univ)).2 ∧
      (Odd l.length → (l.getLastD (default, univ)).1 ∈ (l.getLastD (default, univ)).2) ∧
      (Even l.length → (l.dropLast.getLastD (default, univ)).1 ∈ (l.getLastD (default, univ)).2)
    have getLastD_map_toX : ∀ (l : List (Y × Set Y)) (d : Y × Set Y),
        (l.map toX).getLastD (toX d) = toX (l.getLastD d) := by
      intro l d
      exact List.getLastD_map
    have dropLast_map_toX : ∀ (l : List (Y × Set Y)), (l.map toX).dropLast = (l.dropLast).map toX :=
      fun _ => List.map_dropLast.symm
    have getLastD_drop_map_toX : ∀ (l : List (Y × Set Y)),
        (l.map toX).dropLast.getLastD (default, univ) =
        toX (l.dropLast.getLastD (default, univ)) := by
      intro l
      calc (l.map toX).dropLast.getLastD (default, univ)
          = ((l.dropLast).map toX).getLastD (default, univ) := by rw [dropLast_map_toX]
        _ = ((l.dropLast).map toX).getLastD (toX (default, univ)) := by rw [h_def_toX]
        _ = toX (l.dropLast.getLastD (default, univ)) := getLastD_map_toX _ _
    -- `toX` is the homeomorphism transport `p ↦ (φ.symm p.1, φ ⁻¹' p.2)`, so it reflects
    -- openness, inclusion and membership of the moves in the strong Choquet game.
    have open_toX : ∀ p : Y × Set Y, IsOpen (toX p).2 ↔ IsOpen p.2 := by
      intro p
      simpa only [toX] using φ.isOpen_preimage
    have sub_toX : ∀ p q : Y × Set Y, (toX p).2 ⊆ (toX q).2 ↔ p.2 ⊆ q.2 := by
      intro p q
      simp only [toX]
      refine ⟨fun hsub y hy => ?_, Set.preimage_mono⟩
      have hy' : φ.symm y ∈ φ ⁻¹' p.2 := by simpa using hy
      simpa using hsub hy'
    have mem_toX : ∀ p q : Y × Set Y, (toX p).1 ∈ (toX q).2 ↔ p.1 ∈ q.2 := by
      intro p q
      simp only [toX, Set.mem_preimage, φ.apply_symm_apply]
    have S_transfer : ∀ lY : List (Y × Set Y), S_Y lY ↔ S_X (lY.map toX) := by
      intro lY
      have hLast : (lY.map toX).getLastD (default, univ) =
          toX (lY.getLastD (default, univ)) := by
        calc (lY.map toX).getLastD (default, univ)
            = (lY.map toX).getLastD (toX (default, univ)) := by rw [h_def_toX]
          _ = toX (lY.getLastD (default, univ)) := getLastD_map_toX _ _
      dsimp only [S_X, S_Y]
      rw [hLast, getLastD_drop_map_toX lY, List.length_map, open_toX, sub_toX, mem_toX, mem_toX]
    let fY : List (Y × Set Y) → Y × Set Y := fun l => toY (fX (l.map toX))
    refine ⟨fY, ?_⟩
    intro bY hConsY
    let bX : ℕ → X × Set X := fun n => toX (bY n)
    have ofFun_map_bX : ∀ k : ℕ, (List.ofFun bY k).map toX = List.ofFun bX k := by
      intro k; induction k with
      | zero => rfl
      | succ k ih => simp [List.ofFun, ih, bX]
    have hConsX : ∀ n, bX (2 * n + 1) = fX (List.ofFun bX (2 * n + 1)) := by
      intro n
      have hMap : (List.ofFun bY (2 * n + 1)).map toX = List.ofFun bX (2 * n + 1) :=
        ofFun_map_bX _
      have h1 := hConsY n
      simp only [fY, bX] at h1 ⊢
      calc toX (bY (2 * n + 1)) = toX (toY (fX ((List.ofFun bY (2 * n + 1)).map toX))) := by rw [h1]
        _ = fX ((List.ofFun bY (2 * n + 1)).map toX) := h_toY_toX _
        _ = fX (List.ofFun bX (2 * n + 1)) := by rw [hMap]
    have hNotPayoffX := hfX bX hConsX
    have hIInter_transfer : ((⋂ n, (bX n).2) = ∅) ↔ ((⋂ n, (bY n).2) = ∅) := by
      constructor
      · intro hEmpty
        by_contra hNon
        obtain ⟨y, hy⟩ := Set.nonempty_iff_ne_empty.mpr hNon
        have hyX : φ.symm y ∈ ⋂ n, (bX n).2 := by
          rw [Set.mem_iInter] at hy ⊢
          intro n
          simpa only [bX, toX, Set.mem_preimage, φ.apply_symm_apply] using hy n
        rw [hEmpty] at hyX; exact hyX
      · intro hEmpty
        by_contra hNon
        obtain ⟨x, hx⟩ := Set.nonempty_iff_ne_empty.mpr hNon
        have hxY : φ x ∈ ⋂ n, (bY n).2 := by
          rw [Set.mem_iInter] at hx ⊢
          intro n
          simpa only [bX, toX, Set.mem_preimage] using hx n
        rw [hEmpty] at hxY; exact hxY
    intro hPayoffY
    apply hNotPayoffX
    change (∀ n, ¬ S_Y (List.ofFun bY (2 * n + 1)) →
      ∃ m < n, ¬ S_Y (List.ofFun bY (2 * m + 2))) ∧
      ((∃ n, ¬ S_Y (List.ofFun bY (2 * n + 2))) ∨ (⋂ n, (bY n).2) = ∅) at hPayoffY
    obtain ⟨hCond1Y, hCond2Y⟩ := hPayoffY
    have S_transfer' : ∀ k : ℕ, S_Y (List.ofFun bY k) ↔ S_X (List.ofFun bX k) := by
      intro k
      calc S_Y (List.ofFun bY k) ↔ S_X ((List.ofFun bY k).map toX) := S_transfer _
        _ ↔ S_X (List.ofFun bX k) := by rw [ofFun_map_bX k]
    constructor
    · intro n hNotSX
      obtain ⟨m, hm, hNotSY2⟩ := hCond1Y n ((S_transfer' _).not.mpr hNotSX)
      exact ⟨m, hm, (S_transfer' _).not.mp hNotSY2⟩
    · rcases hCond2Y with hExistsY | hIInterY
      · left
        obtain ⟨n, hn⟩ := hExistsY
        exact ⟨n, (S_transfer' _).not.mp hn⟩
      · right
        exact hIInter_transfer.mpr hIInterY

end Meta

end PiBase
