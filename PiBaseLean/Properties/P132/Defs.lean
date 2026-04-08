module

public import Mathlib.Topology.GDelta.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 132. Gδ space -/
class GδSpace (X : Type u) [TopologicalSpace X] : Prop where
  closed_gdelta : ∀ ⦃s : Set X⦄, IsClosed s → IsGδ s

end PiBase

namespace PiBase.Formal

def P132 : Property where
  toPred := GδSpace
  well_defined φ h := sorry

end PiBase.Formal
