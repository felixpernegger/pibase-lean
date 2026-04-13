module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P30.Defs
public import Mathlib.Topology.Connected.PathConnected

@[expose] public section

universe u v

namespace PiBase

open Topology Filter Set TopologicalSpace

variable {X : Type u} {Y : Type v} [t : TopologicalSpace X] [s : TopologicalSpace Y]

section Meta

theorem WellDefined.paracompactSpace : WellDefined ParacompactSpace :=
  fun {_ _} _ _ h hX ↦ (Homeomorph.paracompactSpace_iff h.some).1 hX

end Meta

end PiBase
