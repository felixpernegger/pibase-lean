module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P27.Defs
public import PiBaseLean.Properties.P28.Defs
public import Mathlib.Topology.Bases

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem T270: P27 (SecondCountableTopology) => P28 (FirstCountableTopology) -/
#check SecondCountableTopology.to_firstCountableTopology

end PiBase

namespace PiBase.Formal

theorem T270 : P27 ≤ P28 := fun X _ _ ↦ by
  simp_all only [P27, P28]
  infer_instance

end PiBase.Formal
