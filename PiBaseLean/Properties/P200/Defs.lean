module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 200. Simply connected -/
class PresimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  presimplyconnected : IsEmpty X ∨ SimplyConnectedSpace X

end PiBase

namespace PiBase.Formal

def P200 : Property where
  toPred := PresimplyConnectedSpace
  well_defined φ h := by
    refine ⟨h.presimplyconnected.imp ?_ ?_⟩
    · exact fun _ ↦ φ.symm.toEquiv.isEmpty
    · exact fun _ ↦ φ.symm.toHomotopyEquiv.simplyConnectedSpace

end PiBase.Formal
