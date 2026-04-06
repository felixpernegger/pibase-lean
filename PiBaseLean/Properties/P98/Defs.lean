import Mathlib.Order.BourbakiWitt
import Mathlib.Topology.Defs.Induced
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace Set.Notation

namespace PiBase

/- 98. k ω 1 space -/
class kω1Space (X : Type*) [TopologicalSpace X] : Prop where
  k_omega : ∃ K : ℕ → Set X, Monotone K ∧ univ = ⋃ n : ℕ, K n ∧
    (∀ n : ℕ, IsCompact (K n)) ∧
      ∀ s : Set X, IsOpen s ↔ ∀ n : ℕ, IsOpen ((K n) ↓∩ s)

end PiBase

namespace PiBase.Formal

def P98 : Property where
  toPred := kω1Space
  well_defined' φ h := sorry

end PiBase.Formal
