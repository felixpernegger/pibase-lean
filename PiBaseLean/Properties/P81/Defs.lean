import Mathlib.Data.Set.Countable
import Mathlib.Topology.Defs.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function TopologicalSpace

namespace PiBase

/- 81. Countably tight -/
class CountablyTightSpace (X : Type*) [TopologicalSpace X] : Prop where
  countably_tight : ∀ (x : X) (A : Set X), x ∈ closure A → ∃ D : Set X,
    D.Countable ∧ D ⊆ A ∧ x ∈ closure D

end PiBase

namespace PiBase.Formal

def P81 : Property where
  toPred := CountablyTightSpace
  well_defined φ h := sorry

end PiBase.Formal
