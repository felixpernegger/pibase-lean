module

public import Mathlib.Topology.Algebra.Module.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 238. Has a real TVS topology -/
class HasRealTVSTopology (X : Type u) [TopologicalSpace X] : Prop where
  homeomorphic_to_tvs : (sorry : Prop)

end PiBase

namespace PiBase.Formal

def P238 : Property where
  toPred := HasRealTVSTopology
  well_defined φ h := sorry

end PiBase.Formal
