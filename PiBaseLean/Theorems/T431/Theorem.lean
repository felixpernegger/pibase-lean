module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P176.Bundled
public import PiBaseLean.Properties.P78.Bundled

import Mathlib.SetTheory.Cardinal.Basic

@[expose] public section

universe u

namespace PiBase

-- TODO: Should this be changed? In theory it should use "not Finite" instead of Infinite
/-- Theorem 431: X infinite implies 4 ≤ |X| -/
instance instCardGeFourOfNotFinite {X : Type u} [h : Infinite X] :
    CardGeFour X where
  card_ge := le_trans Cardinal.ofNat_le_aleph0 <| Cardinal.infinite_iff.1 h

end PiBase

namespace PiBase.Formal

theorem T431 : P78ᶜ ≤ P176 := fun X _ h ↦ @instCardGeFourOfNotFinite X (.mk h)

end PiBase.Formal
