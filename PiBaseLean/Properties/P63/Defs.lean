module

public import Mathlib.Topology.Separation.CompletelyRegular
public import Mathlib.Topology.Compactification.StoneCech
public import Mathlib.Topology.GDelta.Basic

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 63. Cech complete -/
class CechCompleteSpace (X : Type u) [TopologicalSpace X] : Prop extends T35Space X where
  is_gδ : IsGδ (range (stoneCechUnit (α := X)))

end PiBase
