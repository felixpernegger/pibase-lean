import Mathlib

open Topology Set Function Filter TopologicalSpace Cardinal

namespace PiBase

/- 59. Cardinality < 2 ^ 𝔠 -/
class CardLessPowerContinuum (X : Type*) where
  card_lt : #X < 2 ^ 𝔠

end PiBase
