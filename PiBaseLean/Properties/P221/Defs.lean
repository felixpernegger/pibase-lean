module

public import Mathlib.Topology.UniformSpace.Cauchy
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 221. Dieudonné complete -/
class DieudonneCompleteSpace (X : Type u) [t : TopologicalSpace X] : Prop where
  complete_uniformity : ∃ s : UniformSpace X, s.toTopologicalSpace = t ∧ CompleteSpace X

end PiBase

namespace PiBase.Formal

def P221 : Property where
  toPred := DieudonneCompleteSpace
  well_defined φ h := sorry

end PiBase.Formal
