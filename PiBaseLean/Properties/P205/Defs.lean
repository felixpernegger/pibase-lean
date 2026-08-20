module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.Connected.Basic
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function

namespace PiBase

/- 205. Cut point space -/
class CutPointSpace (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  all_cut (p : X) : IsCutPoint p

end PiBase

namespace PiBase.Formal

def P205 : Property where
  toPred := CutPointSpace
  well_defined φ h := {
    toConnectedSpace := (Homeomorph.connectedSpace_iff φ).mp h.toConnectedSpace
    all_cut := fun q ↦ by
      simpa using PiBase.Homeomorph.isCutPoint φ (h.all_cut (φ.symm q))
  }

end PiBase.Formal
