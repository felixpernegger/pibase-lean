module

public import Mathlib.Data.Set.Countable
public import Mathlib.Topology.Defs.Filter
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 93. Locally countable -/
class LocallyCountableSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_countable : ∀ x : X, ∃ s ∈ 𝓝 x, s.Countable

end PiBase

namespace PiBase.Formal

def P93 : Property where
  toPred := LocallyCountableSpace
  well_defined φ h := by
    refine ⟨fun y => ?_⟩
    rcases h.locally_countable (φ.symm y) with ⟨U, nU, cU⟩
    refine ⟨φ '' U, ?_, cU.image φ⟩
    rw [← φ.apply_symm_apply y, ← φ.map_nhds_eq (φ.symm y)]
    change φ ⁻¹' (φ '' U) ∈ 𝓝 (φ.symm y)
    simpa

end PiBase.Formal
