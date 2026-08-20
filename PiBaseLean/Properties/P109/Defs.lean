module

public import Mathlib.Topology.Sets.Opens
public import Mathlib.Topology.Separation.Basic
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 109. Monotonically normal -/
class MonotonicallyNormalSpace (X : Type*) [TopologicalSpace X] : Prop extends T1Space X where
  monotonically_normal : ∃ μ : (x : X) → (s : Opens X) → (hs : x ∈ s) → Opens X,
    ∀ (x : X) (s : Opens X) (hs : x ∈ s), x ∈ μ x s hs ∧
      ∀ (x y : X) (u v : Opens X) (hu : x ∈ u) (hv : y ∈ v),
        (↑(μ x u hu) : Set X) ∩ ↑(μ y v hv) ≠ ∅ → x ∈ v ∨ y ∈ u

end PiBase

namespace PiBase.Formal

def P109 : Property where
  toPred := MonotonicallyNormalSpace
  well_defined {X Y} _ _ φ h := by
    obtain ⟨μX, hμ⟩ := h.monotonically_normal
    have hT1X : T1Space X := h.toT1Space
    have hT1Y : T1Space Y := φ.t1Space
    -- Helper: condition extracted from hμ
    have hCond : ∀ (x y : X) (u v : Opens X) (hu : x ∈ u) (hv : y ∈ v),
        (↑(μX x u hu) : Set X) ∩ ↑(μX y v hv) ≠ ∅ → x ∈ v ∨ y ∈ u := by
      intro x y u v hu hv hInter
      have hs : x ∈ (⊤ : Opens X) := by
        simp
      exact (hμ x ⊤ hs).2 x y u v hu hv hInter
    have hMem : ∀ (x : X) (s : Opens X) (hs : x ∈ s), x ∈ (μX x s hs : Set X) := by
      intro x s hs
      exact (hμ x s hs).1
    -- Define μY
    let μY : (y : Y) → (t : Opens Y) → y ∈ t → Opens Y := fun y t ht =>
      let sX : Opens X := ⟨φ ⁻¹' (t : Set Y), t.isOpen.preimage φ.continuous⟩
      have hsX : φ.symm y ∈ sX := by
        show φ.symm y ∈ φ ⁻¹' (t : Set Y)
        simp [ht]
      let uX := μX (φ.symm y) sX hsX
      ⟨φ '' (uX : Set X), φ.isOpenMap _ uX.isOpen⟩
    -- Prove monotonically normal for Y
    refine ⟨⟨μY, ?_⟩⟩
    intro y t ht
    constructor
    · -- y ∈ μY y t ht
      let sX : Opens X := ⟨φ ⁻¹' (t : Set Y), t.isOpen.preimage φ.continuous⟩
      have hsX : φ.symm y ∈ sX := by
        show φ.symm y ∈ φ ⁻¹' (t : Set Y)
        simp [ht]
      have hmemX : φ.symm y ∈ (μX (φ.symm y) sX hsX : Set X) := hMem _ _ hsX
      show y ∈ (μY y t ht : Set Y)
      show y ∈ φ '' (μX (φ.symm y) sX hsX : Set X)
      exact ⟨φ.symm y, hmemX, φ.apply_symm_apply y⟩
    · -- monotonicity condition
      intro y1 y2 u v hu hv hInter
      -- Unfold μY
      let sU : Opens X := ⟨φ ⁻¹' (u : Set Y), u.isOpen.preimage φ.continuous⟩
      have hsU : φ.symm y1 ∈ sU := by show φ.symm y1 ∈ φ ⁻¹' (u : Set Y); simp [hu]
      let sV : Opens X := ⟨φ ⁻¹' (v : Set Y), v.isOpen.preimage φ.continuous⟩
      have hsV : φ.symm y2 ∈ sV := by show φ.symm y2 ∈ φ ⁻¹' (v : Set Y); simp [hv]
      let uX := μX (φ.symm y1) sU hsU
      let vX := μX (φ.symm y2) sV hsV
      have hInterX : (uX : Set X) ∩ (vX : Set X) ≠ ∅ := by
        have hInter' : ((μY y1 u hu : Set Y) ∩ (μY y2 v hv : Set Y)).Nonempty :=
          Set.nonempty_iff_ne_empty.mpr hInter
        obtain ⟨z, hz⟩ := hInter'
        have hz1 : z ∈ φ '' (uX : Set X) := hz.1
        have hz2 : z ∈ φ '' (vX : Set X) := hz.2
        obtain ⟨x1, hx1, rfl⟩ := hz1
        obtain ⟨x2, hx2, heq⟩ := hz2
        have heq' : φ x1 = φ x2 := heq.symm
        have hx1_eq : x1 = x2 := φ.injective heq'
        exact Set.nonempty_iff_ne_empty.mp ⟨x1, hx1, hx1_eq ▸ hx2⟩
      have hOr := hCond (φ.symm y1) (φ.symm y2) sU sV hsU hsV hInterX
      rcases hOr with h1 | h2
      · left
        show y1 ∈ (v : Set Y)
        have : φ.symm y1 ∈ φ ⁻¹' (v : Set Y) := h1
        simp at this
        exact this
      · right
        show y2 ∈ (u : Set Y)
        have : φ.symm y2 ∈ φ ⁻¹' (u : Set Y) := h2
        simp at this
        exact this

end PiBase.Formal
