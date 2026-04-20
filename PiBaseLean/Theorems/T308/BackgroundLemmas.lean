module

public import PiBaseLean.Properties.P125.Defs
public import PiBaseLean.Properties.P135.Defs
public import PiBaseLean.Properties.P139.Defs
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

universe u

open Topology Set Function

open scoped Inseparable

namespace PiBase

--to mathlib
/-- A space is R₀, iff all "inseparable" components are closed. -/
theorem r0Space_iff_inseparableComponent_closed {X : Type u}
    [TopologicalSpace X] : R0Space X ↔ ∀ x : X, IsClosed (InseparableComponent x) := by
  rw [← SeparationQuotient.t1Space_iff]
  refine ⟨fun h x ↦ ?_, fun h ↦ ?_⟩
  · rw [SeparationQuotient.inseparableComponent_preimage]
    exact IsClosed.preimage SeparationQuotient.continuous_mk <| T1Space.t1 (SeparationQuotient.mk x)
  apply T1Space.mk fun x ↦ ?_
  obtain ⟨r, rfl⟩ := SeparationQuotient.surjective_mk x
  exact isClosed_coinduced.mpr <| SeparationQuotient.inseparableComponent_preimage r ▸ h r

theorem instSubsingletonOfPreconnectedSpaceOfR0SpaceOfHasAnIsolatedPoint (X : Type u)
    [TopologicalSpace X] [h : R0Space X] [h' : HasAnIsolatedPoint X] [h'' : PreconnectedSpace X] :
    Subsingleton X := by
  obtain ⟨p, hp⟩ := h'
  replace hp : IsClopen {p} :=
    ⟨inseparableComponent_of_open hp ▸ r0Space_iff_inseparableComponent_closed.1 h p, hp⟩
  rcases preconnectedSpace_iff_clopen.mp h'' {p} hp with h|h
  · exact (singleton_ne_empty p h).elim
  · exact (subsingleton_iff_singleton_univ p).mpr h.symm

end PiBase
