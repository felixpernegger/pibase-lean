module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P38.Lemmas
public import PiBaseLean.Properties.P43.Defs
public import PiBaseLean.Properties.P96.Defs
public import PiBaseLean.Theorems.T703.Theorem

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T704: P96 (LocallyArcConnectedSpace) => P43 (LocallyInjPathConnectedSpace) -/
instance instLocallyInjPathConnectedSpaceOfLocallyArcConnectedSpace (X : Type u)
    [TopologicalSpace X] [h : LocallyArcConnectedSpace X] :
    LocallyInjPathConnectedSpace X where
  inj_path_connected_basis x := by
    apply hasBasis_self.mpr (fun t ht ↦ ?_)
    obtain ⟨r, rx, hr, rt⟩ := hasBasis_self.mp (h.arc_connected_basis x) t ht
    refine ⟨r, rx, ?_, rt⟩
    rw [isInjPathConnected_iff_injPathConnectedSpace]
    infer_instance

end PiBase

namespace PiBase.Formal

theorem T704 : P96 ≤ P43 :=
  fun X _ ↦ @instLocallyInjPathConnectedSpaceOfLocallyArcConnectedSpace X _

end PiBase.Formal
