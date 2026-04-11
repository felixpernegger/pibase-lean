module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 200. Simply connected -/
class PresimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  presimplyconnected : IsEmpty X ∨ SimplyConnectedSpace X

open Topology Filter

variable (X : Type*) [TopologicalSpace X]

/-- A nonempty, pre simply connected space is connected. -/
instance instSimplyConnectedSpaceOfPresimplyConnectedSpaceOfNonempty [h : PresimplyConnectedSpace X]
    [h' : Nonempty X] : SimplyConnectedSpace X := by
  rcases h.presimplyconnected with h|h
  · have : ContractibleSpace X := by infer_instance
    exact SimplyConnectedSpace.ofContractible X
  · exact h

/-- A simply connected space is pre simply connected. -/
theorem SimplyConnectedSpace.presimplyConnectedSpace [h : SimplyConnectedSpace X] :
    PresimplyConnectedSpace X where
  presimplyconnected := .inr h

section Meta

end Meta

end PiBase
