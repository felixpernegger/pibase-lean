module

public import Mathlib
public import PiBaseLean.Properties.P234.Defs

@[expose] public section

namespace PiBase

open Topology Filter

variable {X : Type*} [TopologicalSpace X]

/-- If `s` is a connected set containing `y` and `y` lies in the connected component of `y`,
`s` is contained in the connected component of `x`. -/
lemma _root_.IsConnected.subset_connectedComponent_of_mem {x y : X} {s : Set X} (hs : IsConnected s)
    (ys : y ∈ s) (xy : y ∈ connectedComponent x) : s ⊆ connectedComponent x :=
  connectedComponent_eq_iff_mem.mpr xy ▸ hs.subset_connectedComponent ys

variable (X)

/-- A space has open connected components iff each point has a connected neighborhood. -/
theorem hasOpenConnectedComponents_iff_ex_connected_nbhd :
    HasOpenConnectedComponents X ↔ ∀ x : X, ∃ s ∈ 𝓝 x, IsConnected s := by
  refine ⟨fun h x ↦ ?_, fun h ↦ { component_open := fun x ↦ ?_ }⟩
  · refine ⟨connectedComponent x, ?_, isConnected_connectedComponent⟩
    exact (IsOpen.mem_nhds_iff <| h.component_open x).mpr mem_connectedComponent
  apply isOpen_iff_mem_nhds.mpr fun y hy ↦ ?_
  obtain ⟨s, sy, hs⟩ := h y
  exact mem_of_superset sy <| hs.subset_connectedComponent_of_mem (mem_of_mem_nhds sy) hy

section Meta

end Meta

end PiBase
