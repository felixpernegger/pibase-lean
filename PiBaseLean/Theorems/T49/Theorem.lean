module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P46.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T49: P46 (TotallyPathDisconnectedSpace) => P2 (T1Space) -/
instance instT1SpaceOfTotallyPathDisconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : TotallyPathDisconnectedSpace X] : T1Space X := by
  apply t1Space_iff_exists_open.mpr
  intro x y xy
  rw [totallyPathDisconnectedSpace_iff_joined] at h
  contrapose! h
  refine ⟨x, y, ?_, xy⟩
  apply Nonempty.intro
  refine ⟨⟨fun i ↦ if i = 0 then x else y, ?_⟩, by simp, by simp⟩
  refine { isOpen_preimage := fun s hs ↦ ?_ }
  have rg : (range fun i : unitInterval ↦ if i = 0 then x else y) = ({x, y} : Set X) := by
    ext z
    simp only [mem_range, mem_insert_iff, mem_singleton_iff]
    refine ⟨fun ⟨e, he⟩ ↦ ?_, fun h ↦ ?_⟩
    · by_cases e0 : e = 0 <;> simp_all
    rcases h with h|h <;> rw [h]
    · refine ⟨0, ?_⟩
      simp
    · refine ⟨1, ?_⟩
      simp
  by_cases xs : x ∈ s
  · have : y ∈ s := h s hs xs
    suffices (fun i : unitInterval ↦ if i = 0 then x else y) ⁻¹' s = univ from this ▸ isOpen_univ
    simp only [preimage_eq_univ_iff]
    exact rg ▸ pair_subset xs (h s hs xs)
  · by_cases ys : y ∈ s
    · suffices (fun i : unitInterval ↦ if i = 0 then x else y) ⁻¹' s = {0}ᶜ by
        rw [this]
        simp
      ext z
      simp only [mem_preimage, mem_compl_iff, mem_singleton_iff]
      by_cases z = 0 <;> simp_all
    · suffices (fun i : unitInterval ↦ if i = 0 then x else y) ⁻¹' s = ∅ by
        rw [this]
        simp
      ext z
      simp only [mem_preimage, mem_empty_iff_false, iff_false]
      by_cases z = 0 <;> simp_all

end PiBase

namespace PiBase.Formal

theorem T49 : P46 ≤ P2 := fun X _ ↦ @instT1SpaceOfTotallyPathDisconnectedSpace X _

end PiBase.Formal
