import Mathlib
import PibaseLean.AdditionalDefs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u v

namespace PiBase

/- 105. Para-Lindelöf -/
class ParaLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  para_lindelof :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyCountable t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase
