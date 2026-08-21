module

public import PiBaseLean.Properties.P153.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.omegaMengerSpace.{u} : WellDefined OmegaMengerSpace.{u} :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    have menger_pres : ∀ {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y],
        (X ≃ₜ Y) → MengerSpace X → MengerSpace Y := by
      intro X Y _ _ f hf
      constructor
      intro ι U hU_open hU_cover
      let U' : ℕ → ι → Set X := fun n i => f ⁻¹' (U n i)
      have hU'_open : ∀ n i, IsOpen (U' n i) := fun n i => f.isOpen_preimage.mpr (hU_open n i)
      have hU'_cover : ∀ n, (⋃ i, U' n i) = _root_.Set.univ := fun n => by
        have : (⋃ i, U' n i) = f ⁻¹' (⋃ i, U n i) := by simp [U', Set.preimage_iUnion]
        rw [this, ← hU_cover n, Set.preimage_univ]
      obtain ⟨s, hs⟩ := hf.menger U' hU'_open (fun n => by rw [hU'_cover n])
      refine ⟨s, ?_⟩
      calc _root_.Set.univ = f '' _root_.Set.univ :=
          (Set.image_univ_of_surjective f.surjective).symm
        _ = f '' (⋃ n, ⋃ i ∈ s n, U' n i) := by rw [hs]
        _ = ⋃ n, f '' (⋃ i ∈ s n, U' n i) := by rw [Set.image_iUnion]
        _ = ⋃ n, ⋃ i ∈ s n, f '' (U' n i) := by simp_rw [Set.image_iUnion]
        _ = ⋃ n, ⋃ i ∈ s n, U n i := by simp only [U', f.image_preimage]
    constructor
    intro n
    have h_n : MengerSpace (Fin n → _) := h.omega_menger n
    let e : (Fin n → _) ≃ₜ (Fin n → _) := Homeomorph.piCongrRight (fun _ => φ)
    exact menger_pres e h_n

end PiBase
