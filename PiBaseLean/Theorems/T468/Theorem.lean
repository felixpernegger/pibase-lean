module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P129.Defs
public import PiBaseLean.Properties.P185.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T468: P185 (PartitionTopology) + P36 (PreconnectedSpace) => P129 (IndiscreteTopology) -/
instance instIndiscreteTopologyOfPartitionTopologyOfPreconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : PartitionTopology X] [h' : PreconnectedSpace X] :
    IndiscreteTopology X := by
  refine IndiscreteTopology.of_forall_inseparable (fun x y ↦ ?_)
  rw [preconnectedSpace_iff_clopen] at h'
  contrapose! h'
  refine ⟨{z | Inseparable x z}, ⟨?_, ?_⟩, ?_, ?_⟩
  · exact PartitionTopology.inseparable_closed X x
  · exact PartitionTopology.inseparable_open X x
  · exact ⟨x, .refl x⟩
  · exact (ne_of_mem_of_not_mem' trivial h').symm

end PiBase

namespace PiBase.Formal

theorem T468 : P185 ⊓ P36 ≤ P129 := fun X _ ⟨h1, h2⟩ ↦ @instIndiscreteTopologyOfPartitionTopologyOfPreconnectedSpace X _ h1 h2

end PiBase.Formal
