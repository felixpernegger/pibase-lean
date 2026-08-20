module

public import PiBaseLean.AdditionalDefs.Cover
public import Mathlib.Data.Set.Countable
public import Mathlib.Topology.Homeomorph.Defs

@[expose] public section

universe u

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 182. Has a countable network -/ --NOTE: We use `Type` instead of `Type u` to be able to use `ℕ`
class HasCountableNetwork (X : Type u) [TopologicalSpace X] : Prop where
  has_countable_network : ∃ (ι : Type) (f : ι → Set X), Countable ι ∧ IsNetwork f

end PiBase
