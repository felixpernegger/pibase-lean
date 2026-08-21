module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P182.Bundled
public import PiBaseLean.Properties.P183.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T11: P183 (HasCountableKNetwork) => P182 (HasCountableNetwork) -/
instance instHasCountableNetworkOfHasCountableKNetwork {X : Type u}
    [TopologicalSpace X] [h : HasCountableKNetwork X] :
    HasCountableNetwork X where
  has_countable_network := by
    obtain ⟨ι, f, ιc, fh⟩ := h.ex_network
    exact ⟨ι, f, ιc, fh.isNetwork⟩

end PiBase

namespace PiBase.Formal

theorem T11 : P183 ≤ P182 := fun X _ ↦ @instHasCountableNetworkOfHasCountableKNetwork X _

end PiBase.Formal
