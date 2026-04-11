module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P204.Defs
public import PiBaseLean.Properties.P205.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T635: P205 (CutPointSpace) => P204 (HasACutPoint) -/
instance instHasACutPointOfCutPointSpace (X : Type u)
    [TopologicalSpace X] [h : CutPointSpace X] :
    HasACutPoint X :=
  have : Nonempty X := by infer_instance
  ⟨this.some, h.all_cut this.some⟩

end PiBase

namespace PiBase.Formal

theorem T635 : P205 ≤ P204 := fun X _ ↦ @instHasACutPointOfCutPointSpace X _

end PiBase.Formal
