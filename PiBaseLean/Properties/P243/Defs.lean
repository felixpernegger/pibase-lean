module

public import PiBaseLean.AdditionalDefs.Meta
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Data.Set.Countable
public import Mathlib.Data.Set.Image

@[expose] public section

universe u

namespace PiBase

/- 243. Has countable π-weight -/
class HasCountablePiWeight (X : Type u) [TopologicalSpace X] : Prop where
  countable_pi_base : ∃ s : Set (Set X), s.Countable ∧ IsPiBase s

end PiBase
