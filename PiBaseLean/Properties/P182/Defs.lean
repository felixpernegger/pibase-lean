module

public import Mathlib
public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

open Topology Set Function Filter TopologicalSpace

namespace PiBase

open PiBase.AdditionalDefs

/- 182. Has a countable network -/ --NOTE: We use `Type` instead of `Type u` to be able to use `ℕ`
class HasCountableNetwork (X : Type u) [TopologicalSpace X] : Prop where
  has_countable_network : ∃ (ι : Type) (f : ι → Set X), Countable ι ∧ IsNetwork f

end PiBase

namespace PiBase.Formal

def P182 : Property where
  toPred := HasCountableNetwork
  well_defined φ h := sorry

end PiBase.Formal
