module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P38.Bundled
public import PiBaseLean.Properties.P43.Bundled
public import PiBaseLean.Properties.P96.Bundled
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
    suffices (𝓝 x).HasBasis (fun s ↦ s ∈ 𝓝 x ∧ IsOpen s ∧ IsInjPathConnected s) id by
      convert this using 1
      ext s
      simp only [and_congr_left_iff, and_imp]
      intro hs _
      exact (IsOpen.mem_nhds_iff hs).symm
    apply hasBasis_self.mpr (fun t ht ↦ ?_)
    have : (𝓝 x).HasBasis (fun s ↦ s ∈ 𝓝 x ∧ IsOpen s ∧ ArcConnectedSpace ↑s) id := by
      convert h.arc_connected_basis x using 1
      ext s
      simp only [and_congr_left_iff, and_imp]
      intro hs _
      exact IsOpen.mem_nhds_iff hs
    obtain ⟨r, rx, ⟨hr, ri⟩, rt⟩ := hasBasis_self.mp this t ht
    refine ⟨r, rx, ⟨hr, ?_⟩, rt⟩
    rw [isInjPathConnected_iff_injPathConnectedSpace]
    infer_instance

end PiBase

namespace PiBase.Formal

theorem T704 : P96 ≤ P43 :=
  fun X _ ↦ @instLocallyInjPathConnectedSpaceOfLocallyArcConnectedSpace X _

end PiBase.Formal
