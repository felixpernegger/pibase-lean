module

public import Mathlib.Topology.Separation.CompletelyRegular

@[expose] public section

open Set

universe u

namespace PiBase

/- 63. Cech complete -/
class CechCompleteSpace (X : Type u) [TopologicalSpace X] : Prop extends T35Space X where
  is_gδ : IsGδ (range (stoneCechUnit (α := X)))

end PiBase
