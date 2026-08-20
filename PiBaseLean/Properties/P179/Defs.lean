module

public import PiBaseLean.Properties.P183.Defs
public import Mathlib.Topology.Separation.Regular
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 179. ℵ₀-space -/
class AlephZeroSpace (X : Type u) [TopologicalSpace X] : Prop extends
    T3Space X, HasCountableKNetwork X

end PiBase
