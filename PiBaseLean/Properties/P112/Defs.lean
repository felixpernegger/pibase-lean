import Mathlib.Topology.Metrizable.Basic

open Topology Set TopologicalSpace

universe u

namespace PiBase

/- 112. Submetrizable space -/ -- TODO : Check that this is the right direction
class SubmetrizableSpace (X : Type u) [τ : TopologicalSpace X] : Prop where
  le_metrizable : ∃ t : TopologicalSpace X, MetrizableSpace X (t := t) ∧ t ≤ τ

end PiBase
