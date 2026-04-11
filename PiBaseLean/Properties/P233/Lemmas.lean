module

public import PiBaseLean.Properties.P233.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set

variable {X : Type*} [TopologicalSpace X]

/-- If `s` is a path-connected set containing `y` and `y` lies in the path component of `y`,
`s` is contained in the path component of `x`. -/
lemma _root_.IsPathConnected.subset_pathComponent_of_mem {x y : X} {s : Set X}
    (hs : IsPathConnected s) (ys : y ∈ s) (xy : y ∈ pathComponent x) : s ⊆ pathComponent x :=
  pathComponent_congr xy ▸ hs.subset_pathComponent ys

--to mathlib
/-- In a path connected space, all path components are the entire space. -/
theorem _root_.PathconnectedSpace.connectedComponent_eq_univ [PathConnectedSpace X] (x : X) :
    pathComponent x = univ :=
  subset_antisymm (subset_univ _) (isPathConnected_univ.subset_pathComponent trivial)

variable (X)

/-- A space has open connected components iff each point has a connected neighborhood. -/
theorem hasOpenPathComponents_iff_ex_connected_nbhd :
    HasOpenPathComponents X ↔ ∀ x : X, ∃ s ∈ 𝓝 x, IsPathConnected s := by
  refine ⟨fun h x ↦ ?_, fun h ↦ { component_open := fun x ↦ ?_ }⟩
  · refine ⟨pathComponent x, ?_, isPathConnected_pathComponent⟩
    exact (IsOpen.mem_nhds_iff <| h.component_open x).mpr <| mem_pathComponent_self x
  apply isOpen_iff_mem_nhds.mpr fun y hy ↦ ?_
  obtain ⟨s, sy, hs⟩ := h y
  exact mem_of_superset sy <| hs.subset_pathComponent_of_mem (mem_of_mem_nhds sy) hy

section Meta

end Meta

end PiBase
