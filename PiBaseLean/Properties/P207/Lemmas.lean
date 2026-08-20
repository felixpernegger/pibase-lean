module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P207.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.stronglyCollectionwiseNormalSpace :
    WellDefined StronglyCollectionwiseNormalSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro sY hsY_diag hsY_open
    -- Transport along the homeomorphism `φ ×ₜ φ` by taking preimages, which keeps both
    -- openness and membership computations definitional.
    have hg : Continuous (Prod.map (φ : X → Y) φ) := φ.continuous.prodMap φ.continuous
    have hf : Continuous (Prod.map (φ.symm : Y → X) φ.symm) :=
      φ.symm.continuous.prodMap φ.symm.continuous
    have hsX_diag : diagonal X ⊆ Prod.map (φ : X → Y) φ ⁻¹' sY :=
      diagonal_subset_iff.2 fun x => hsY_diag (mem_diagonal _)
    obtain ⟨tX, htX_diag, htX_open, htX_comp⟩ :=
      h.subset_diagonal hsX_diag (hg.isOpen_preimage _ hsY_open)
    refine ⟨Prod.map (φ.symm : Y → X) φ.symm ⁻¹' tX,
      diagonal_subset_iff.2 fun y => htX_diag (mem_diagonal _),
      hf.isOpen_preimage _ htX_open, ?_⟩
    rintro ⟨y₁, y₂⟩ ⟨y, hy₁, hy₂⟩
    have hmem : (φ.symm y₁, φ.symm y₂) ∈ Prod.map (φ : X → Y) φ ⁻¹' sY :=
      htX_comp ⟨φ.symm y, hy₁, hy₂⟩
    simpa using hmem

end Meta

end PiBase
