module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 46. Totally path disconnected -/
class TotallyPathDisconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  totally_path_disconnected : ∀ f : Icc (0 : ℝ) 1 → X, Continuous f → ∃ x : X, f = const (Icc 0 1) x

end PiBase

namespace PiBase.Formal

def P46 : Property where
  toPred := TotallyPathDisconnectedSpace
  well_defined φ h := sorry

end PiBase.Formal
