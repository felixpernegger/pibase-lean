module

public import Mathlib.SetTheory.Ordinal.Topology

@[expose] public section

open Topology Set Filter

universe u

namespace PiBase

/- 172. Radial -/
class RadialSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_seq (A : Set X) : ∀ x ∈ closure A, ∃ (s : Ordinal.{u}) (f : Iio s → X),
    0 < s ∧ range f ⊆ A ∧ Tendsto f atTop (𝓝 x)

end PiBase
