import PiBaseLean.Properties.P175.Defs
import Mathlib.SetTheory.Cardinal.Defs
import Mathlib.Tactic

universe u

open Cardinal

namespace PiBase

section --These results are in mathlib, but not yet in the stable version. Remove this section later

theorem le_one_iff_subsingleton {α : Type u} : #α ≤ 1 ↔ Subsingleton α :=
  ⟨fun ⟨f⟩ => ⟨fun _ _ => f.injective (Subsingleton.elim _ _)⟩, fun ⟨h⟩ =>
    ⟨fun _ => ULift.up 0, fun _ _ _ => h _ _⟩⟩

theorem one_lt_iff_nontrivial {α : Type u} : 1 < #α ↔ Nontrivial α := by
  rw [← not_le, le_one_iff_subsingleton, ← not_nontrivial_iff_subsingleton, Classical.not_not]

end

/-- Theorem 428: |X| ≥ 3 implies X has multiple points -/
instance instNontrivialOfCardGeThree {X : Type u} [h : CardGeThree X] : Nontrivial X :=
  one_lt_iff_nontrivial.mp <| lt_of_lt_of_le (by norm_num) h.card_ge

end PiBase
