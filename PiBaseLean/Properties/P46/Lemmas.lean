module

public import PiBaseLean.Properties.P46.Defs
public import Mathlib.Topology.Connected.PathConnected

@[expose] public section

namespace PiBase

open Topology Filter Set

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
        hf.comp <| Continuous.subtype_mk (by fun_prop) fun x ↦ Icc.instMul._proof_1 x r
    }
    exact ⟨g, by simp [g], by simp [g]⟩
  exact Nonempty.elim this fun a ↦ h (id (Joined.symm this))

/-- A space is totally path disconnected iff all of its path components are singletons. -/
theorem totallyPathDisconnectedSpace_iff_pathComponents_eq_singleton :
    TotallyPathDisconnectedSpace X ↔ ∀ x : X, pathComponent x = {x} := by
  rw  [totallyPathDisconnectedSpace_iff_joined]
  refine ⟨fun h x ↦ ?_, fun h x y xy ↦ ?_⟩
  · ext y
    refine ⟨fun hy ↦ ?_, fun xy ↦ by simp_all⟩
    simp only [mem_singleton_iff]
    exact h hy.symm
  have : y ∈ ({x} : Set X) := h x ▸ xy
  simp_all

section Meta

end Meta

end PiBase
