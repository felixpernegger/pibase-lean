module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 162. Realcompact
Note: We need to use `Type` here, so the property is -/
class RealcompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  homeo_closed : ∃ (ι : Type u) (f : X → ι → ℝ), IsClosedEmbedding f

end PiBase
