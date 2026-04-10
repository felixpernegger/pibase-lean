module

public import Mathlib.Data.Setoid.Partition
public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 146. Ultraparacompact -/
class UltraparacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  partition_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (Setoid.IsPartition (range t))

end PiBase

namespace PiBase.Formal

def P146 : Property where
  toPred := UltraparacompactSpace
  well_defined φ h := sorry

end PiBase.Formal
