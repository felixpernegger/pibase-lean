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

--to mathlib
/-- Two points are joined iff there path components are the same. -/
theorem _root_.pathComponent_eq_iff_joined (x y : X) :
    pathComponent x = pathComponent y ↔ Joined x y := by
  refine ⟨fun h ↦ ?_, fun h ↦ ?_⟩
  · exact mem_pathComponent_iff.mp <| h ▸ mem_pathComponent_self y
  exact pathComponent_congr (id h.symm)

lemma HasOpenPathComponents.pathComponent_nbhd [HasOpenPathComponents X] (x : X) :
    pathComponent x ∈ 𝓝 x :=
  (IsOpen.mem_nhds_iff (component_open x)).mpr <| mem_pathComponent_self x

--to mathlib, golf
/-- Two different path components are disjoint. -/
theorem _root_.pathComponent_disjoint {x y : X} (h : pathComponent x ≠ pathComponent y) :
    Disjoint (pathComponent x) (pathComponent y) := by
  apply Set.disjoint_left.2 (fun z hz ↦ ?_)
  contrapose! h
  exact (pathComponent_eq_iff_joined x y).mpr <| hz.trans h.symm

/-- In a space with open path components, every path component is clopen. -/
theorem HasOpenPathComponents.pathComponent_isClopen [h : HasOpenPathComponents X] (x : X) :
    IsClopen (pathComponent x) := by
  refine ⟨?_, h.component_open x⟩
  apply isOpen_compl_iff.mp <| isOpen_iff_mem_nhds.mpr (fun y hy ↦ ?_)
  apply Filter.sets_of_superset (𝓝 y) <| h.pathComponent_nbhd y
  apply (pathComponent_disjoint ?_).subset_compl_right
  contrapose! hy
  simp [← hy]

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
