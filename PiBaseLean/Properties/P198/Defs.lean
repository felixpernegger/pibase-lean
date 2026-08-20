module

public import PiBaseLean.AdditionalDefs.Cardinal
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.DiscreteSubset

@[expose] public section

open Topology Set Filter TopologicalSpace Cardinal

universe u

namespace PiBase

/- 198. Has countable extent -/
class HasCountableExtent (X : Type u) [TopologicalSpace X] : Prop where
  extent_eq : Extent X = ℵ₀

end PiBase
