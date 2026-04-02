import Mathlib
import PibaseLean.AdditionalDefs

open Topology Set Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace UnstablePiBase

/- 105. Para-Lindelöf -/
class ParaLindelofSpace (X : Type*) [TopologicalSpace X] : Prop where
  para_lindelof :
    ∀ (α : Type) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyCountable t ∧ ∀ b, ∃ a, t b ⊆ s a

end UnstablePiBase
