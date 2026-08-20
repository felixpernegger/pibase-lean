module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P228.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.weaklyFirstCountableSpace : WellDefined WeaklyFirstCountableSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨V, hVanti, hVopen⟩ := h.nhds_countable_weak_basis
    refine ⟨fun y n => φ '' V (φ.symm y) n, ?_⟩
    constructor
    · intro y
      constructor
      · intro n m hnm
        exact Set.image_mono ((hVanti (φ.symm y)).1 hnm)
      · intro n
        exact ⟨φ.symm y, (hVanti (φ.symm y)).2 n, φ.apply_symm_apply y⟩
    · intro O
      constructor
      · intro hO y hy
        have hO_pre : IsOpen (φ ⁻¹' O) := φ.isOpen_preimage.mpr hO
        have hy' : φ.symm y ∈ φ ⁻¹' O := by
          change φ (φ.symm y) ∈ O
          rwa [φ.apply_symm_apply]
        have := (hVopen (φ ⁻¹' O)).mp hO_pre (φ.symm y) hy'
        obtain ⟨k, hk⟩ := this
        refine ⟨k, ?_⟩
        calc φ '' V (φ.symm y) k ⊆ φ '' (φ ⁻¹' O) := Set.image_mono hk
          _ = O := φ.image_preimage O
      · intro hRHS
        have hRHS_pre : ∀ x ∈ φ ⁻¹' O, ∃ k : ℕ, V x k ⊆ φ ⁻¹' O := by
          intro x hx
          have hxO : φ x ∈ O := hx
          obtain ⟨k, hk⟩ := hRHS (φ x) hxO
          refine ⟨k, ?_⟩
          intro z hz
          have : φ z ∈ φ '' V x k := ⟨z, hz, rfl⟩
          -- Actually V x = V (φ.symm (φ x))? Need to align
          have hx_eq : φ.symm (φ x) = x := φ.symm_apply_apply x
          have hVk : V x k = V (φ.symm (φ x)) k := by rw [hx_eq]
          -- hk : φ '' V (φ.symm (φ x)) k ⊆ O
          have h' : V x k ⊆ φ ⁻¹' O := by
            intro w hw
            have : φ w ∈ φ '' V (φ.symm (φ x)) k := by
              have : V x k = V (φ.symm (φ x)) k := by rw [hx_eq]
              rw [this] at hw
              exact ⟨w, hw, rfl⟩
            exact hk this
          exact h' hz
        have hOpen_pre : IsOpen (φ ⁻¹' O) := (hVopen _).mpr hRHS_pre
        exact φ.isOpen_preimage.mp hOpen_pre

end Meta

end PiBase
