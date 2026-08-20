module

public import PiBaseLean.AdditionalDefs.Constructions
public import Mathlib.Topology.Connected.Basic
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function

namespace PiBase

/- 204. Has a cut point -/
class HasACutPoint (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  ex_cut : ∃ p : X, IsCutPoint p

end PiBase
