module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P37.Defs

@[expose] public section

namespace PiBase

variable (X : Type*) [TopologicalSpace X]

/-- A nonempty, prepathconnected space is connected. -/
instance instPathConnectedSpaceOfPrepathConnectedSpaceOfNonempty [h : PrepathConnectedSpace X]
    [h' : Nonempty X] : PathConnectedSpace X where
  nonempty := h'
  joined := h.joined

/-- A pathconnectespace is prepathconnected. -/
theorem PathconnectedSpace.PrepathConnectedSpace [h : PathConnectedSpace X] :
    PrepathConnectedSpace X where
  joined := h.joined

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.prepathConnectedSpace : WellDefined PrepathConnectedSpace :=
  fun {_ _} _ _ φ h => by
    refine ⟨fun x y => (h.joined (φ.some.symm x) (φ.some.symm y)).elim fun p => ⟨?_⟩⟩
    convert p.map φ.some.continuous <;> simp only [Homeomorph.apply_symm_apply]

theorem Homeomorph.prepathConnectedSpace [h : PrepathConnectedSpace X] (f : X ≃ₜ Y) :
    PrepathConnectedSpace Y := by
  refine ⟨fun x y => (h.joined (f.symm x) (f.symm y)).elim fun p => ⟨?_⟩⟩
  convert p.map f.continuous <;> simp only [Homeomorph.apply_symm_apply]

end PiBase
