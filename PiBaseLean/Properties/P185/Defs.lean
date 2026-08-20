module

public import Mathlib.Topology.Inseparable

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 185. Partition topology -/
class PartitionTopology (X : Type u) [TopologicalSpace X] : Prop where
  quotient_discrete : DiscreteTopology (SeparationQuotient X)

end PiBase
