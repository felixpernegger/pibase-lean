module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P37.Defs
public import PiBaseLean.Properties.P46.Defs
public import PiBaseLean.Properties.P125.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T88: P37 (PrepathConnectedSpace) + P125 (Nontrivial) =>
P46 (¬TotallyPathDisconnectedSpace) -/
theorem instNotTotallyPathDisconnectedSpaceOfPrepathConnectedSpaceOfNontrivial (X : Type u)
    [TopologicalSpace X] [h : PrepathConnectedSpace X] [h' : Nontrivial X] :
    ¬ TotallyPathDisconnectedSpace X := by
  contrapose! h'
  refine {allEq := fun x y ↦ ?_}
  obtain ⟨f, fx, fy⟩ := h.joined x y
  obtain ⟨z, hz⟩ := h'.totally_path_disconnected f f.continuous
  rw [ContinuousMap.toFun_eq_coe.trans hz] at fx fy
  simp_all

end PiBase

namespace PiBase.Formal

theorem T88 : P37 ⊓ P125 ≤ P46ᶜ := fun X _ ⟨h1, h2⟩ ↦
  @instNotTotallyPathDisconnectedSpaceOfPrepathConnectedSpaceOfNontrivial X _ h1 h2

end PiBase.Formal
