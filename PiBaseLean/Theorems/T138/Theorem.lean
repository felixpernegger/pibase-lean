import PiBaseLean.Properties.P175.Defs

universe u

open Cardinal PiBase.Formal

namespace PiBase

/-- Theorem 428: |X| ≥ 3 implies X has multiple points -/
instance instNontrivialOfCardGeThree {X : Type u} [h : CardGeThree X] : NP58 X where
  not_p58 := fun h' ↦ (and_not_self_iff (𝔠 ≤ 𝔠)).mp <| h.card_eq ▸ h'.card_lt

end PiBase
