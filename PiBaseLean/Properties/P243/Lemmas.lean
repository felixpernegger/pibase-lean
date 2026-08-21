module

public import PiBaseLean.Properties.P243.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasCountablePiWeight : WellDefined HasCountablePiWeight :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨s, hsCount, hsPi⟩ := h.countable_pi_base
    have hsEmpty : ∅ ∉ s := hsPi.1
    have hsOpen : ∀ a ∈ s, IsOpen a := hsPi.2.1
    have hsSub : ∀ o : Set _, IsOpen o → o.Nonempty → ∃ t ∈ s, t ⊆ o := hsPi.2.2
    let s' : Set (Set _) := (fun t => φ '' t) '' s
    have hsCount' : s'.Countable := hsCount.image _
    have hsEmpty' : ∅ ∉ s' := by
      intro hMem
      obtain ⟨a, ha, haEq⟩ := hMem
      have hA_eq_empty : a = ∅ := Set.image_eq_empty.mp haEq
      have : ∅ ∈ s := hA_eq_empty ▸ ha
      exact hsEmpty this
    have hsOpen' : ∀ b ∈ s', IsOpen b := by
      intro b hb
      obtain ⟨a, ha, rfl⟩ := hb
      exact φ.isOpenMap _ (hsOpen a ha)
    have hsSub' : ∀ o : Set _, IsOpen o → o.Nonempty → ∃ t ∈ s', t ⊆ o := by
      intro o ho hoNon
      have hoPreOpen : IsOpen (φ ⁻¹' o) := ho.preimage φ.continuous
      have hoPreNon : (φ ⁻¹' o).Nonempty := by
        obtain ⟨y, hy⟩ := hoNon
        obtain ⟨x, hx⟩ := φ.surjective y
        exact ⟨x, by rw [Set.mem_preimage, hx]; exact hy⟩
      obtain ⟨a, ha, haSub⟩ := hsSub (φ ⁻¹' o) hoPreOpen hoPreNon
      refine ⟨φ '' a, ⟨a, ha, rfl⟩, ?_⟩
      calc φ '' a ⊆ φ '' (φ ⁻¹' o) := Set.image_mono haSub
        _ ⊆ o := Set.image_preimage_subset _ _
    exact ⟨s', hsCount', hsEmpty', hsOpen', hsSub'⟩

end PiBase
