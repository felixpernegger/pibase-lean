import PiBaseLean.AdditionalDefs
import PiBaseLean.Properties.Bundled.Defs

universe u

open Topology Set Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace PiBase

/- 105. Para-Lindelöf -/
class ParaLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  para_lindelof :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyCountable t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

namespace PiBase.Formal

def P105 : Property where
  toPred := ParaLindelofSpace
  well_defined' φ h := sorry

end PiBase.Formal
