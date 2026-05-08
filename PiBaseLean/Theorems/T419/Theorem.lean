module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P169.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T419: P169 (SemiT2Space) => P2 (T1Space) -/
instance instT1SpaceOfSemiT2Space (X : Type u)
    [TopologicalSpace X] [h : SemiT2Space X] :
    T1Space X := by
  apply (t1Space_iff_exists_open).mpr (fun x y xy ↦ ?_)
  obtain ⟨s, hs, xs, ys⟩ := h.ex_regular_open xy
  exact ⟨s, hs.isOpen, xs, ys⟩

end PiBase

namespace PiBase.Formal

theorem T419 : P169 ≤ P2 := fun X _ ↦ @instT1SpaceOfSemiT2Space X _

end PiBase.Formal
