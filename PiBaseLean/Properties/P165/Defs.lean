module

public import Mathlib.Data.Set.Countable
public import Mathlib.Order.BourbakiWitt
public import Mathlib.Topology.Separation.SeparatedNhds
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 165. Pseudonormal -/
class PseudonormalSpace (X : Type u) [TopologicalSpace X] : Prop where
  pseudonormal (s t : Set X) :
    s.Countable → IsClosed s → IsClosed t → Disjoint s t → SeparatedNhds s t

end PiBase

namespace PiBase.Formal

def P165 : Property where
  toPred := PseudonormalSpace
  well_defined φ h := sorry

end PiBase.Formal
