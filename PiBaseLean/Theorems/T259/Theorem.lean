module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P182.Bundled
public import PiBaseLean.Properties.P57.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T259: P57 (Countable) => P182 (HasCountableNetwork)

The singletons form a network: `x ∈ {x} ⊆ s` for every neighbourhood `s` of `x`, and a
network may consist of arbitrary sets, not necessarily open ones. They are indexed by `ℕ`
through an injection `e : X → ℕ`, with `n` indexing the fibre of `e` over `n` — a singleton
when `n` is in the range of `e`, and empty otherwise. -/
theorem instHasCountableNetworkOfCountable {X : Type u} [TopologicalSpace X] [Countable X] :
    HasCountableNetwork X := by
  obtain ⟨e, he⟩ := Countable.exists_injective_nat X
  refine ⟨ℕ, fun n ↦ {x | e x = n}, inferInstance, fun x s hs ↦ ⟨e x, rfl, ?_⟩⟩
  intro y hy
  rw [he (hy : e y = e x)]
  exact mem_of_mem_nhds hs

end PiBase

namespace PiBase.Formal

theorem T259 : P57 ≤ P182 := fun X _ h ↦ @instHasCountableNetworkOfCountable X _ h

end PiBase.Formal
