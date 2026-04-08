module

public import Mathlib.Topology.Separation.CompletelyRegular
public import Mathlib.Topology.Compactification.StoneCech
public import Mathlib.Topology.GDelta.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 63. Cech complete -/
class CechCompleteSpace (X : Type u) [TopologicalSpace X] : Prop extends T35Space X where
  is_gδ : IsGδ (range (stoneCechUnit (α := X)))

end PiBase

namespace PiBase.Formal

def P63 : Property where
  toPred := CechCompleteSpace
  well_defined φ h := sorry

end PiBase.Formal
