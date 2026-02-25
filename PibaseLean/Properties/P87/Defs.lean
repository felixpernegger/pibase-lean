import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 87. Has Group Topology -/
class HasGroupTopology (X : Type*) [TopologicalSpace X] : Prop where
  has_group_topology : ∃ (_ : Group X), IsTopologicalGroup X

end PiBase
