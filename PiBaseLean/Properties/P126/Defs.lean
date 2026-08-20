module

public import Mathlib.Topology.Defs.Basic

@[expose] public section

open Topology Set Function TopologicalSpace

universe u

namespace PiBase

/- 126. Door -/
class DoorSpace (X : Type u) [TopologicalSpace X] : Prop where
  isOpen_or_isClosed (s : Set X) : IsOpen s ∨ IsClosed s

end PiBase
