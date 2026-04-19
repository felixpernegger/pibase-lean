module

public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P191.Defs
public import Mathlib.Data.Set.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

theorem Set.not_mem_ext_iff {α : Type u} {a b : Set α} : a = b ↔ ∀ (x : α), x ∉ a ↔ x ∉ b := by
  rw [Set.ext_iff]
  apply forall_congr'
  tauto

theorem mem_isGδ_ex_nhds_separate {X : Type u} [TopologicalSpace X] {s : Set X} {x y : X}
    (hs : IsGδ s) (hx : x ∈ s) (hy : y ∉ s) : ∃ U ∈ 𝓝 x, y ∉ U := by
  obtain ⟨f, fo, sf⟩ := isGδ_iff_eq_iInter_nat.mp hs
  have me := (Set.ext_iff.mp sf x).mp hx
  simp only [mem_iInter] at me
  simp only [Set.not_mem_ext_iff, mem_iInter, not_forall] at sf
  obtain ⟨i, hi⟩ := (sf y).mp hy
  exact ⟨f i, (IsOpen.mem_nhds_iff (fo i)).mpr <| me i, hi⟩

end PiBase
