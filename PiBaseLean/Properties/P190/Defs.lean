module

public import Mathlib.SetTheory.Ordinal.Topology
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Ordinal

universe u

namespace PiBase

/- 190. Ordinal space -/
class OrdinalSpace (X : Type u) [TopologicalSpace X] : Prop where
  homeo_ordinal : ∃ a : Ordinal.{u}, IsHomeo X (Iio a : Set Ordinal.{u})

end PiBase

namespace PiBase.Formal

def P190 : Property where
  toPred := OrdinalSpace
  well_defined φ h := sorry

end PiBase.Formal
