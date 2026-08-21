module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P234.Defs

@[expose] public section

namespace PiBase

universe u

open Topology Filter

variable {X : Type*} [TopologicalSpace X]

/-- If `s` is a connected set containing `y` and `y` lies in the connected component of `y`,
`s` is contained in the connected component of `x`. -/
lemma _root_.IsConnected.subset_connectedComponent_of_mem {x y : X} {s : Set X} (hs : IsConnected s)
    (ys : y ∈ s) (xy : y ∈ connectedComponent x) : s ⊆ connectedComponent x :=
  connectedComponent_eq_iff_mem.mpr xy ▸ hs.subset_connectedComponent ys

lemma HasOpenConnectedComponents.connectedComponent_nbhd [HasOpenConnectedComponents X] (x : X) :
    connectedComponent x ∈ 𝓝 x :=
  (IsOpen.mem_nhds_iff (component_open x)).mpr <| mem_connectedComponent

/-- In a space with open connected components, every connected component is clopen. -/
theorem HasOpenConnectedComponents.connectedComponent_isClopen
    [h : HasOpenConnectedComponents X] (x : X) :
    IsClopen (connectedComponent x) := by
  refine ⟨?_, h.component_open x⟩
  apply isOpen_compl_iff.mp <| isOpen_iff_mem_nhds.mpr (fun y hy ↦ ?_)
  apply Filter.sets_of_superset (𝓝 y) <| h.connectedComponent_nbhd y
  apply (connectedComponent_disjoint ?_).subset_compl_right
  contrapose! hy
  simp [← hy, mem_connectedComponent]

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

theorem WellDefined.hasOpenConnectedComponents :
    WellDefined (fun (X : Type u) => HasOpenConnectedComponents X) :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y
    apply isOpen_iff_mem_nhds.mpr
    intro z hz
    set w := φ.symm z with hw_def
    have hzw : z = φ w := (φ.apply_symm_apply z).symm
    have hw_mem : connectedComponent w ∈ nhds w :=
      (h.component_open w).mem_nhds mem_connectedComponent
    have hw_img_mem : φ '' connectedComponent w ∈ nhds z := by
      rw [hzw, ← φ.map_nhds_eq w]
      exact Filter.image_mem_map hw_mem
    refine Filter.mem_of_superset hw_img_mem ?_
    have h_conn : IsConnected (φ '' connectedComponent w) :=
      isConnected_connectedComponent.image φ φ.continuous.continuousOn
    have hz_mem : z ∈ φ '' connectedComponent w :=
      hzw ▸ Set.mem_image_of_mem φ mem_connectedComponent
    have h_sub_z : φ '' connectedComponent w ⊆ connectedComponent z :=
      h_conn.subset_connectedComponent hz_mem
    rwa [connectedComponent_eq_iff_mem.mpr hz] at h_sub_z

end PiBase
