module

public import Mathlib.Topology.UniformSpace.Cauchy

@[expose] public section

universe u

namespace PiBase

/- 221. Dieudonné complete -/
class DieudonneCompleteSpace (X : Type u) [t : TopologicalSpace X] : Prop where
  complete_uniformity : ∃ s : UniformSpace X, s.toTopologicalSpace = t ∧ CompleteSpace X

end PiBase
