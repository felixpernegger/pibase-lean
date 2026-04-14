module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P1.Defs
public import PiBaseLean.Properties.P51.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T169: P51 (ScatteredSpace) => P1 (T0Space) -/
instance instT0SpaceOfScatteredSpace (X : Type u)
    [TopologicalSpace X] [h : ScatteredSpace X] :
    T0Space X := by
  apply (t0Space_iff_inseparable X).mpr (fun x y xy ↦ ?_)
  obtain ⟨⟨p,p_mem⟩, hp⟩ := h.scattered {x, y} (by simp)
  contrapose! xy
  obtain ⟨s, so, hs⟩ := hp
  apply not_inseparable_iff_exists_open.mpr
  have h : ∀ r ∈ ({x, y} : Set X), r ∈ s ↔ r = p := by
    intro r hr
    rw [Set.ext_iff] at hs
    specialize hs ⟨r, hr⟩
    simp_all
  refine ⟨s, so, xor_def.mpr ?_⟩
  simp only [mem_insert_iff, mem_singleton_iff, forall_eq_or_imp, forall_eq] at h
  apply xor_def.mpr
  cases p_mem <;> rename_i hp'
  · left
    simp_all [xy.symm]
  · right
    simp_all [mem_singleton_iff.mp hp']

end PiBase

namespace PiBase.Formal

theorem T169 : P51 ≤ P1 := fun X _ ↦ @instT0SpaceOfScatteredSpace X _

end PiBase.Formal
