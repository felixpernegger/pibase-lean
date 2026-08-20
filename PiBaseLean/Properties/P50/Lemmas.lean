module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P50.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.zeroDimensionalSpace : WellDefined ZeroDimensionalSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    rcases h.zero_dimensional with ⟨B, Bβ, Bc⟩
    refine ⟨Set.image φ '' B, Bβ.isQuotientMap φ.isQuotientMap φ.isOpenMap, ?_⟩
    rintro _ ⟨s, sB, rfl⟩
    have hc : IsClopen s := Bc s sB
    -- IsClopen = IsClosed ∧ IsOpen, so order is ⟨closed, open⟩
    exact ⟨φ.isClosedMap _ hc.1, φ.isOpenMap _ hc.2⟩

end Meta

end PiBase
