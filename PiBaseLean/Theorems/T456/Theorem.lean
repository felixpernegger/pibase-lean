module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P181.Bundled
public import PiBaseLean.Properties.P57.Bundled
public import PiBaseLean.Properties.P78.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem 456: a countably infinite space is infinite -/
instance instCountablyInfiniteOfCountableOfInfinite {X : Type u} [Countable X] [Infinite X] :
    CountablyInfinite X := by tauto

end PiBase

namespace PiBase.Formal

theorem T456 : P57 ⊓ P78ᶜ ≤ P181 := fun X _ ⟨h₁, h₂⟩ ↦
  @instCountablyInfiniteOfCountableOfInfinite X h₁ (.mk h₂)

end PiBase.Formal
