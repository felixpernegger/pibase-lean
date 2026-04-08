module

public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function TopologicalSpace

universe u

namespace PiBase

/- 126. Door -/
class DoorSpace (X : Type u) [TopologicalSpace X] : Prop where
  isOpen_or_isClosed (s : Set X) : IsOpen s ∨ IsClosed s

end PiBase

namespace PiBase.Formal

def P126 : Property where
  toPred := DoorSpace
  well_defined φ h := sorry

end PiBase.Formal
