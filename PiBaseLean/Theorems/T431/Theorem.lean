import Mathlib.SetTheory.Cardinal.Basic
import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P78.Defs
import PiBaseLean.Properties.P176.Defs

universe u

namespace PiBase

--TODO: Maybe change this once negations are properly implemented
/-- Theorem 431: X infinite implies 4 ≤ |X| -/
instance instCardGeFourOfNotFinite {X : Type u} [h : Infinite X] :
    CardGeFour X where
  card_ge := le_trans Cardinal.ofNat_le_aleph0 <| Cardinal.infinite_iff.1 h

end PiBase

namespace PiBase.Formal

theorem T431 : P78ᶜ ≤ P176 := fun X _ h ↦ @instCardGeFourOfNotFinite X (.mk h)

end PiBase.Formal
