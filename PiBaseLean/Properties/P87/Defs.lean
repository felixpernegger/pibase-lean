import Mathlib.Algebra.Group.TransferInstance
import Mathlib.Topology.Algebra.Group.Defs
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 87. Has Group Topology -/
class HasGroupTopology (X : Type*) [TopologicalSpace X] : Prop where
  has_group_topology : ∃ (_ : Group X), IsTopologicalGroup X

end PiBase

namespace PiBase.Formal

def P87 : Property where
  toPred := HasGroupTopology
  well_defined' {_ Y} _ _ φ h := by
    rcases h with ⟨G, h⟩
    letI H := φ.symm.toEquiv.group
    refine ⟨H, @IsTopologicalGroup.mk Y _ H
      ⟨(?_ : Continuous fun (p : Y × Y) ↦ φ (φ.symm p.1 * φ.symm p.2))⟩
      ⟨(?_ : Continuous fun p ↦ φ (φ.symm p)⁻¹)⟩⟩ <;> fun_prop

end PiBase.Formal
