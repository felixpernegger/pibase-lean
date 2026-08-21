module

public import Mathlib.Topology.Inseparable

@[expose] public section

universe u

namespace PiBase

/- 185. Partition topology -/
class PartitionTopology (X : Type u) [TopologicalSpace X] : Prop where
  quotient_discrete : DiscreteTopology (SeparationQuotient X)

end PiBase
