module

public import Mathlib.Topology.Connected.PathConnected
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P46.Defs

@[expose] public section

namespace PiBase

open Set

variable (X : Type*) [TopologicalSpace X]

/-- A space is totally path disconnected iff all no two different point are joined. -/
theorem totallyPathDisconnectedSpace_iff_joined :
    TotallyPathDisconnectedSpace X ↔ ∀ ⦃x y : X⦄, Joined x y → x = y := by
  refine ⟨fun h x y xy ↦ ?_, fun h ↦ ?_⟩
  · obtain ⟨p, px, py⟩ := xy
    obtain ⟨z, hz⟩ := h.totally_path_disconnected p.toFun p.continuous_toFun
    simp_all
  refine { totally_path_disconnected f hf := ?_ }
  refine ⟨f 0, ?_⟩
  ext r
  simp only [Function.const_apply]
  have : Joined (f 0) (f r) := by
    let g : C(unitInterval, X) :={
      toFun l := f (l * r)
      continuous_toFun :=
        hf.comp <| Continuous.subtype_mk (by fun_prop) fun x ↦ by
          obtain ⟨x, xl, lx⟩ := x
          obtain ⟨r, rl, lr⟩ := r
          simp only [mem_Icc]
          exact ⟨mul_nonneg xl rl, mul_le_one₀ lx rl lr⟩
    }
    exact ⟨g, by simp [g], by simp [g]⟩
  exact Nonempty.elim this fun a ↦ h (id (Joined.symm this))

/-- A space is totally path disconnected iff all of its path components are singletons. -/
theorem totallyPathDisconnectedSpace_iff_pathComponent_singleton :
    TotallyPathDisconnectedSpace X ↔ ∀ x : X, pathComponent x = {x} := by
  rw  [totallyPathDisconnectedSpace_iff_joined]
  refine ⟨fun h x ↦ ?_, fun h x y xy ↦ ?_⟩
  · ext y
    refine ⟨fun hy ↦ ?_, fun xy ↦ by simp_all⟩
    simp only [mem_singleton_iff]
    exact h hy.symm
  have : y ∈ ({x} : Set X) := h x ▸ xy
  simp_all

theorem WellDefined.totallyPathDisconnectedSpace : WellDefined TotallyPathDisconnectedSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro f hf
    -- compose arbitrary path into Y with φ.symm to get path into X
    have hcomp : Continuous (fun t : Icc (0 : ℝ) 1 => φ.symm (f t)) :=
      φ.symm.continuous.comp hf
    -- apply totally path disconnected in X to get constant
    obtain ⟨x, hx⟩ := h.totally_path_disconnected (fun t => φ.symm (f t)) hcomp
    refine ⟨φ x, ?_⟩
    ext t
    simp only [Function.const_apply]
    -- extract pointwise equality from hx : (φ.symm ∘ f) = const x
    have hxt : φ.symm (f t) = x := by
      have := congrFun hx t
      simpa [Function.const_apply] using this
    -- push constant through φ : f t = φ (φ.symm (f t)) = φ x
    calc f t = φ (φ.symm (f t)) := (φ.apply_symm_apply (f t)).symm
      _ = φ x := by rw [hxt]

end PiBase
