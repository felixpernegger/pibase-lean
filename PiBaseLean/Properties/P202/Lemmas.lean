module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P202.Defs

@[expose] public section

namespace PiBase

open Topology

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasPointWithUniqueNeighborhood : WellDefined HasPointWithUniqueNeighborhood :=
  fun {X Y} _ _ φ h => by
    obtain ⟨p, hp⟩ := h.ex_point_unique_nbhd
    refine ⟨⟨φ.some p, ?_⟩⟩
    have h_map : Filter.map φ.some (𝓝 p) = 𝓝 (φ.some p) := φ.some.map_nhds_eq p
    have h_top : Filter.map φ.some (⊤ : Filter X) = ⊤ :=
      Function.Surjective.filter_map_top φ.some.surjective
    calc 𝓝 (φ.some p) = Filter.map φ.some (𝓝 p) := h_map.symm
      _ = Filter.map φ.some ⊤ := by rw [hp]
      _ = ⊤ := h_top

end PiBase
