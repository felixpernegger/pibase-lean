module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P182.Defs
public import PiBaseLean.Properties.P183.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T11: P183 (HasCountableKNetwork) => P182 (HasCountableNetwork) -/
instance instHasCountableNetworkOfHasCountableKNetwork (X : Type u)
    [TopologicalSpace X] [h : HasCountableKNetwork X] :
    HasCountableNetwork X where
  has_countable_network := by
    obtain ⟨ι, f, ιc, fh⟩ := h.ex_network
    exact ⟨ι, f, ιc, fh.IsNetwork⟩

end PiBase

namespace PiBase.Formal

theorem T11 : P183 ≤ P182 := fun X _ ↦ @instHasCountableNetworkOfHasCountableKNetwork X _

end PiBase.Formal
