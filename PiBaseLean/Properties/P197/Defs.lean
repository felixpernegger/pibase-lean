module

public import PiBaseLean.AdditionalDefs.Cardinal
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.DiscreteSubset

@[expose] public section

open Topology Set Filter TopologicalSpace Cardinal

universe u

namespace PiBase

/- 197. Has countable spread -/
class HasCountableSpread (X : Type u) [TopologicalSpace X] : Prop where
  spread_eq : Spread X = ℵ₀

end PiBase
