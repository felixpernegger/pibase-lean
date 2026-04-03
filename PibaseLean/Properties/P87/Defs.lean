import Mathlib.Topology.Algebra.Group.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 87. Has Group Topology -/
class HasGroupTopology (X : Type*) [TopologicalSpace X] : Prop where
  has_group_topology : ∃ (_ : Group X), IsTopologicalGroup X

end PiBase

namespace PiBase.Formal

abbrev P87 := HasGroupTopology

class NP87 (X : Type*) [TopologicalSpace X] where
  not_p87 : ¬ P87 X

end PiBase.Formal
