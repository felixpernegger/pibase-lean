import Mathlib.Order.BourbakiWitt
import Mathlib.Topology.Separation.Hausdorff
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace Set.Notation

namespace PiBase

/- 92. k ω 3 space -/
class kω3Space (X : Type*) [TopologicalSpace X] : Prop where
  k_omega : ∃ K : ℕ → Set X, Monotone K ∧ univ = ⋃ n : ℕ, K n ∧
    (∀ n : ℕ, IsCompact (K n)) ∧ (∀ n : ℕ, T2Space (K n)) ∧
      ∀ s : Set X, IsOpen s ↔ ∀ n : ℕ, IsOpen ((K n) ↓∩ s)

end PiBase

namespace PiBase.Formal

def P92 : Property where
  toPred := kω3Space
  well_defined φ h := sorry

end PiBase.Formal
