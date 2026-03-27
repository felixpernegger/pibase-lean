import Mathlib
import PibaseLean.AdditionalDefs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace UnstablePiBase

/- 61. Cozero complemented -/
class CozeroComplementedSpace (X : Type*) [TopologicalSpace X] : Prop where
  cozero_complemented : ∀ s : Set X, IsCozero s → ∃ t : Set X, IsCozero t ∧ Dense (s ∪ t)

end UnstablePiBase
