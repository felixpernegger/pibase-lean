import Mathlib.Topology.GDelta.Basic
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 191. Has points Gδ -/ --This def is from formal conjectures
class HasGδSingletons (X : Type*) [TopologicalSpace X] : Prop where
  isGδ_singleton : ∀ ⦃x : X⦄, IsGδ {x}

end PiBase

namespace PiBase.Formal

def P191 : Property where
  toPred := HasGδSingletons
  well_defined φ h := by
    refine ⟨fun x ↦ ?_⟩
    convert isGδ_induced φ.symm.continuous (@h.isGδ_singleton (φ.symm x))
    ext
    simp

end PiBase.Formal
