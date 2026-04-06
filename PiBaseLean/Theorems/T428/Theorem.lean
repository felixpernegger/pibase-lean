import PiBaseLean.Properties.P175.Defs
import PiBaseLean.Properties.P176.Defs
import Mathlib.Tactic

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem 430: 3 ≤ 4 -/
instance instCardGeThreeOfCardGeFour {X : Type u} [TopologicalSpace X] [h : CardGeFour X] :
    CardGeThree X where
  card_ge := le_trans (by norm_num) h.card_ge

end PiBase
