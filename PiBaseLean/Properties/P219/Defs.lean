module

public import Mathlib.SetTheory.Cardinal.Defs
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

universe u

open Cardinal Set

namespace PiBase

/-- 219. Toronto -/
class TorontoSpace (X : Type*) [TopologicalSpace X] : Prop where
  toronto : ∀ ⦃Y : Set X⦄, #Y = #X → Nonempty (Y ≃ₜ X)

end PiBase
