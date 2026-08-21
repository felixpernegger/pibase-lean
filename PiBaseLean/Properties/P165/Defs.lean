module

public import Mathlib.Data.Set.Countable
public import Mathlib.Topology.Separation.SeparatedNhds

@[expose] public section

universe u

namespace PiBase

/- 165. Pseudonormal -/
class PseudonormalSpace (X : Type u) [TopologicalSpace X] : Prop where
  pseudonormal (s t : Set X) :
    s.Countable → IsClosed s → IsClosed t → Disjoint s t → SeparatedNhds s t

end PiBase
