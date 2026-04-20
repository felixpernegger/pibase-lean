module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P73.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem soberSpace_iff_ex_unique_generic :
    SoberSpace X ↔ ∀ S : Set X, IsIrreducible S → IsClosed S → ∃! (x : X), IsGenericPoint x S := by
  refine ⟨fun h S Si Sc ↦ ?_, fun h ↦ ?_⟩
  · obtain ⟨p, hp⟩ := h.sober Si Sc
    refine ⟨p, hp, ?_⟩
    intro _ hq
    apply (t0Space_iff_inseparable X).mp h.toT0Space
    exact IsGenericPoint.inseparable hq hp
  refine { toQuasiSober := (quasiSober_iff X).mpr ?_, toT0Space := ?_ }
  · intro S Si Sc
    obtain ⟨x, hx, _⟩ := h S Si Sc
    exact ⟨x, hx⟩
  refine (t0Space_iff_inseparable X).mpr (fun x y xy ↦ ?_)
  have px : IsGenericPoint x (closure {x}) := isGenericPoint_closure
  have py : IsGenericPoint y (closure {x}) := by
    rw [inseparable_iff_closure_eq.mp xy]
    exact isGenericPoint_closure
  exact (h (closure {x}) isIrreducible_singleton.closure isClosed_closure).unique px py

theorem WellDefined.soberSpace : WellDefined SoberSpace :=
  sorry

end Meta

end PiBase
