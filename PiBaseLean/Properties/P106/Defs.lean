import Mathlib.Topology.GDelta.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 106. Has a Gδ diagonal -/
class HasGδDiagonal (X : Type*) [TopologicalSpace X] : Prop where
  has_g_delta_diagonal : IsGδ (diagonal X)

end PiBase

namespace PiBase.Formal

def P106 : Property where
  toPred := HasGδDiagonal
  well_defined {X Y} _ _ φ h := by
    constructor
    letI Φ : Y × Y ≃ₜ X × X := φ.symm.prodCongr φ.symm
    convert isGδ_induced Φ.continuous h.has_g_delta_diagonal
    simp [Φ, diagonal]

end PiBase.Formal
