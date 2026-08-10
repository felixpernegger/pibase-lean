module

public import Mathlib.Topology.Algebra.Module.Basic
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Data.Real.Basic
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

/- 238. Has a real TVS topology -/
class HasRealTVSTopology (X : Type u) [t : TopologicalSpace X] : Prop where
  homeomorphic_to_tvs : ∃ a : (AddCommMonoid X), ∃ (_ : @Module ℝ X _ a),
    (Continuous fun ((r , x) : ℝ × X) ↦ r • x) ∧
      Continuous fun ((x, y) : X × X) ↦ x + y

end PiBase

namespace PiBase.Formal

def P238 : Property where
  toPred := HasRealTVSTopology
  well_defined φ h := sorry

end PiBase.Formal
