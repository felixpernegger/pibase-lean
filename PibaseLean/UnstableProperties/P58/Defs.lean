import Mathlib

open Topology Set Function Filter TopologicalSpace Cardinal

namespace PiBase

/- 58. Cardinality < 𝔠 -/
class CardLtContinuum (X : Type*) where
  card_lt : #X < 𝔠

end PiBase
