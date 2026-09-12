module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P39.Bundled
public import PiBaseLean.Properties.P201.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- a generic point lies in every nonempty open set -/
theorem mem_of_isGenericPoint {p : X} (hp : IsGenericPoint p Set.univ)
    {U : Set X} (hU : IsOpen U) (hne : U.Nonempty) : p ∈ U := by
  obtain ⟨x, hx⟩ := hne
  have : x ∈ closure ({p} : Set X) := by rw [hp]; trivial
  obtain ⟨y, hyU, hy⟩ := mem_closure_iff.1 this U hU hx
  rwa [← (mem_singleton_iff.1 hy)]

/-- Theorem T593: P201 ≤ P39

A generic point lies in every nonempty open set, so any two nonempty open sets meet, at `p`. -/
theorem instPreirreducibleSpaceOfHasGenericPoint [h : HasGenericPoint X] :
    PreirreducibleSpace X := by
  obtain ⟨p, hp⟩ := h.ex_generic_point
  refine ⟨fun u v hu hv ⟨a, _, hau⟩ ⟨b, _, hbv⟩ ↦ ⟨p, trivial, ?_, ?_⟩⟩
  · exact mem_of_isGenericPoint hp hu ⟨a, hau⟩
  · exact mem_of_isGenericPoint hp hv ⟨b, hbv⟩

end PiBase

namespace PiBase.Formal

theorem T593 : P201 ≤ P39 := fun X _ h ↦ @instPreirreducibleSpaceOfHasGenericPoint X _ h

end PiBase.Formal
