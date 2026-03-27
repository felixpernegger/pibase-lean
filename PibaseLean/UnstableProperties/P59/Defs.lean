import Mathlib

open Topology Set Function Filter TopologicalSpace Cardinal

namespace UnstablePiBase

/- 59. Cardinality < 2 ^ 𝔠 -/
class CardLessPowerContinuum (X : Type*) where
  card_lt : #X < 2 ^ 𝔠

end UnstablePiBase
