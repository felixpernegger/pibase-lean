module

public import Mathlib.Topology.Inseparable
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 185. Partition topology -/
class PartitionTopology (X : Type u) [TopologicalSpace X] : Prop where
  quotient_discrete : DiscreteTopology (SeparationQuotient X)

end PiBase

namespace PiBase.Formal

def P185 : Property where
  toPred := PartitionTopology
  well_defined φ h := sorry

end PiBase.Formal
