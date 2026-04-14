module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P129.Defs
public import PiBaseLean.Properties.P185.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T448: P129 (IndiscreteTopology) => P185 (PartitionTopology) -/
instance instPartitionTopologyOfIndiscreteTopology (X : Type u)
    [TopologicalSpace X] [h : IndiscreteTopology X] :
    PartitionTopology X where
  quotient_discrete := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T448 : P129 ≤ P185 := fun X _ ↦ @instPartitionTopologyOfIndiscreteTopology X _

end PiBase.Formal
