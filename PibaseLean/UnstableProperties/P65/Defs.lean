import Mathlib

open Topology Set Function Filter TopologicalSpace Cardinal

namespace UnstablePiBase

/- 65. Cardinality = 𝔠 -/
class CardEqContinuum (X : Type*) where
  card_eq : #X = 𝔠

end UnstablePiBase
