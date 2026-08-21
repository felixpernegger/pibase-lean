module

public import Mathlib.SetTheory.Ordinal.Topology
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

open Set

universe u

namespace PiBase

/- 190. Ordinal space -/
class OrdinalSpace (X : Type u) [TopologicalSpace X] : Prop where
  homeo_ordinal : ∃ a : Ordinal.{u}, IsHomeo X (Iio a : Set Ordinal.{u})

end PiBase
