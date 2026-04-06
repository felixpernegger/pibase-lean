import Mathlib.Topology.GDelta.Basic

namespace PiBase

/- 191. Has points Gδ -/ --This def is from formal conjectures
class HasGδSingletons (X : Type*) [TopologicalSpace X] : Prop where
  isGδ_singleton : ∀ ⦃x : X⦄, IsGδ {x}

end PiBase
