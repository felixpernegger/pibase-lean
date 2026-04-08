module

public import Mathlib
public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P68.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

open PiBase.AdditionalDefs

/-- 149. ω-Lindelöf -/
class OmegaLindelof (X : Type u) [TopologicalSpace X] : Prop where
  pow_lindelof : ∀ n : ℕ,

/-- 150. ω-Rothberger -/
class OmegaRothberger (X : Type u) [TopologicalSpace X] : Prop where
  pow_rothberger : ∀ {ι : Type u} (f : ι → Opens X), IsOmegaCover f →
    ∃ (ω : Type u) (g : ω → Opens X), Countable ω ∧ IsOmegaCover g ∧ range g ⊆ range f

end PiBase
