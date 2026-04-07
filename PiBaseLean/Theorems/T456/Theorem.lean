import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P57.Defs
import PiBaseLean.Properties.P78.Defs
import PiBaseLean.Properties.P181.Defs

universe u

namespace PiBase

--TODO: When negations of properties are properly implemented, maybe redo this
/-- Theorem 456: a countably infinite space is infinite -/
instance instCountablyInfiniteOfCountableOfInfinite {X : Type u} [Countable X] [Infinite X] :
    CountablyInfinite X := by tauto

end PiBase

namespace PiBase.Formal

theorem T456 : P57 ⊓ P78ᶜ ≤ P181 := fun X _ ⟨h₁, h₂⟩ ↦
  @instCountablyInfiniteOfCountableOfInfinite X h₁ (.mk h₂)

end PiBase.Formal
