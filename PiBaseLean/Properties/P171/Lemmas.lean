module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P171.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.k2T2Space : WellDefined K2T2Space :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun K _ f hT2 hComp hCont => ?_⟩
    -- Transport along `φ.symm` componentwise: `f k` is diagonal in `Y` iff its
    -- image under `Prod.map φ.symm φ.symm` is diagonal in `X`, since `φ.symm` is injective.
    have hg : Continuous (Prod.map φ.symm φ.symm ∘ f) :=
      (φ.symm.continuous.prodMap φ.symm.continuous).comp hCont
    have hclosed := h.closed_continuous (Prod.map φ.symm φ.symm ∘ f) hT2 hComp hg
    have h_eq : (Prod.map φ.symm φ.symm ∘ f) ⁻¹' (diagonal X) = f ⁻¹' (diagonal Y) := by
      ext k
      constructor
      · intro hk
        have hk' : φ.symm (f k).1 = φ.symm (f k).2 := hk
        exact φ.symm.injective hk'
      · intro hk
        have hk' : (f k).1 = (f k).2 := hk
        change φ.symm (f k).1 = φ.symm (f k).2
        rw [hk']
    exact h_eq ▸ hclosed

end PiBase
