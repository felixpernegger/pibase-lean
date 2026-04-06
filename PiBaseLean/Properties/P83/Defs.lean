import PiBaseLean.AdditionalDefs
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 83. Meta Lindelöf -/
class MetaLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  meta_lindelof :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointCountable t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

namespace PiBase.Formal

def P83 : Property where
  toPred := MetaLindelofSpace
  well_defined' φ h := sorry

end PiBase.Formal
