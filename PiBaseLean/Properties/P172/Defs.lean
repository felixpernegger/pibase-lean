module

public import PiBaseLean.AdditionalDefs
public import Mathlib.SetTheory.Ordinal.Topology
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 172. Radial -/
class RadialSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_seq (A : Set X) : ∀ x ∈ closure A, ∃ (s : Ordinal.{u}) (f : Iio s → X), Tendsto f atTop (𝓝 x)

end PiBase

namespace PiBase.Formal

def P172 : Property where
  toPred := RadialSpace
  well_defined φ h := sorry

end PiBase.Formal
