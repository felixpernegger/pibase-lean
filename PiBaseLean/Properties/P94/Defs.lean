import Mathlib.Data.Finite.Defs
import Mathlib.Topology.Defs.Filter
import PiBaseLean.Properties.Bundled.Defs

open Topology Filter

namespace PiBase

/- 94. Locally finite -/
class LocallyFiniteSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_finite : ∀ x : X, ∃ s ∈ 𝓝 x, s.Finite

end PiBase

namespace PiBase.Formal

def P94 : Property where
  toPred := LocallyFiniteSpace
  well_defined φ h := by
    refine ⟨fun y => ?_⟩
    rcases h.locally_finite (φ.symm y) with ⟨U, nU, cU⟩
    refine ⟨φ '' U, ?_, cU.image φ⟩
    rw [← φ.apply_symm_apply y, ← φ.map_nhds_eq (φ.symm y)]
    change φ ⁻¹' (φ '' U) ∈ 𝓝 (φ.symm y)
    simpa

end PiBase.Formal
