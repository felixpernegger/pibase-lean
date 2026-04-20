module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Lemmas
public import PiBaseLean.Properties.P93.Lemmas
public import PiBaseLean.Properties.P191.Lemmas
public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.AdditionalDefs.Cover

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T790: P93 (LocallyCountableSpace) + P2 (T1Space) => P191 (HasGδSingletons) -/
instance instHasGδSingletonsOfLocallyCountableSpaceOfT1Space (X : Type u)
    [TopologicalSpace X] [h : LocallyCountableSpace X] [h' : T1Space X] : HasGδSingletons X where
  isGδ_singleton x := by
    obtain ⟨s, sx, sc⟩ := h.locally_countable x
    by_cases! hs : s.Subsingleton
    · obtain ⟨U, Us, Uo, xU⟩ := mem_nhds_iff.mp sx
      have : U = {x} := by
        ext y
        simp_rw [mem_singleton_iff]
        refine ⟨fun h ↦ ?_, fun h ↦ h ▸ xU⟩
        rw [(subsingleton_iff_singleton xU).1 <| hs.anti Us] at h
        simpa using h
      rw [← this]
      exact IsOpen.isGδ Uo
    let T : Set (Set X) :=
      {t : Set X | ∃ (y : X) (h : y ∈ s) (xy : x ≠ y),
        t = (t1Space_iff_exists_open.mp h' xy).choose ∩ (interior s)}
    refine ⟨T, ?_, ?_, ?_⟩
    · intro t ⟨y, ys, xy, ht⟩
      rw [ht]
      exact (t1Space_iff_exists_open.mp h' xy).choose_spec.1.inter isOpen_interior
    · let f : (s \ {x} : Set X) → Set X := fun y ↦
        (t1Space_iff_exists_open.mp h' fun (a : x = y) ↦ y.2.2 a.symm).choose ∩ (interior s)
      have : Countable (s \ {x} : Set X) := countable_coe_iff.mpr <| Countable.diff sc
      suffices T ⊆ range f by
        apply Countable.subset (countable_range f) this
      intro t ⟨z, zs, xz, ht⟩
      simp only [mem_range, Subtype.exists, mem_diff, mem_singleton_iff, f]
      refine ⟨z, ⟨zs, xz.symm⟩, ?_⟩
      rw [ht]
    apply subset_antisymm
    · simp only [subset_sInter_iff, singleton_subset_iff]
      intro t ⟨y, ys, xy, ht⟩
      rw [ht]
      exact ⟨(t1Space_iff_exists_open.mp h' xy).choose_spec.2.1, mem_interior_iff_mem_nhds.mpr sx⟩
    · simp only [subset_singleton_iff, mem_sInter]
      intro z hz
      contrapose! hz
      by_cases! zs : z ∉ s
      · obtain ⟨p, ps, px⟩ := hs.exists_ne x
        refine ⟨(t1Space_iff_exists_open.mp h' px.symm).choose ∩ interior s, ?_, ?_⟩
        · simp only [ne_eq, exists_prop, mem_setOf_eq, T]
          exact ⟨p, ps, px.symm, rfl⟩
        · simp only [mem_inter_iff, not_and]
          intro _
          contrapose! zs
          exact interior_subset zs
      refine ⟨(t1Space_iff_exists_open.mp h' hz.symm).choose ∩ (interior s), ?_, ?_⟩
      · simp only [ne_eq, exists_prop, mem_setOf_eq, T]
        exact ⟨z, zs, hz.symm, rfl⟩
      · simp only [mem_inter_iff, not_and]
        intro h
        contrapose! h
        exact (t1Space_iff_exists_open.mp h' hz.symm).choose_spec.2.2

end PiBase

namespace PiBase.Formal

theorem T790 : P93 ⊓ P2 ≤ P191 :=
  fun X _ ⟨h1, h2⟩ ↦ @instHasGδSingletonsOfLocallyCountableSpaceOfT1Space X _ h1 h2

end PiBase.Formal
