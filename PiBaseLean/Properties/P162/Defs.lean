module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 162. Realcompact
Note: We need to use `Type` here, so the property is -/
class RealcompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  homeo_closed : ∃ (ι : Type u) (s : Set (ι → ℝ)), IsClosed s ∧ IsHomeo X s

end PiBase

namespace PiBase.Formal

def P162 : Property where
  toPred := RealcompactSpace
  well_defined φ h := sorry

end PiBase.Formal
