module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup
public import Mathlib.Data.Set.Card
public import Mathlib.SetTheory.Ordinal.Basic
public import Mathlib.Topology.Sets.OpenCover

@[expose] public section

universe u v

/-! This file contains additional "meta" definitions and statemtns about topological properties
which are useful for properties and theorems. -/

namespace PiBase

namespace AdditionalDefs

open Filter Function Set Topology

variable {X Y Z : Type*} [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace Z]

/-- A collection of sets which is the countable union of collection of sets
which have some property. (I.e. sigma locally finite) -/
def Sigma {X : Type v} [TopologicalSpace X] (P : {α : Type u} → (α → Set X) → Prop)
    {ι : Type u} (f : ι → Set X) :=
  ∃ (ω : Type u) (r : ω → Set ι), Countable ω ∧ (⋃ i : ω, r i = univ) ∧
    (∀ i : ω, P (fun (j : r i) ↦ f j.val))

/-- A collection of sets with a well defined property also has the sigma version of the property. -/
theorem property_to_sigma {P : {α : Type u} → (α → Set X) → Prop}
    (hP : ∀ {α β : Type u} (l : α → Set X) (e : β ≃ α), P l → P (l ∘ e))
    {ι : Type u} {f : ι → Set X} (h : P f) : Sigma P f := by
  refine ⟨ULift (Fin 1), fun _ ↦ univ, instCountableULift, iUnion_const univ, fun i ↦ ?_⟩
  exact hP f (Equiv.Set.univ ι) h

/-- For a property P on topological spaces, we say Omega P, is every power of a space satisfies P -/
def Omega (P : (Y : Type u) → [TopologicalSpace Y] → Prop)
    (X : Type u) [TopologicalSpace X] : Prop := ∀ n : ℕ, P (Fin n → X)

--TODO: Put this in mathlib, there is only another (in my opinion worse) version
/-- A empty set is a topological space (with a unique topology). -/
instance instTopologicalSpaceOfIsEmpty (α : Type u) [IsEmpty α] : TopologicalSpace α where
  IsOpen := fun _ ↦ True
  isOpen_univ := trivial
  isOpen_inter _ _ _ _ := trivial
  isOpen_sUnion _ _ := trivial

/-- If Omega P X holds, then P X holds for well defined properties. -/
theorem omega_id {Z : Type u} [TopologicalSpace Z] (P : (X : Type u) → [TopologicalSpace X] → Prop)
    (hP : ∀ {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y]
    (_ : X ≃ₜ Y), P X → P Y) (hZ : Omega P Z) : P Z := hP (Homeomorph.funUnique (Fin 1) Z) <| hZ 1

--TODO: Omega P X for some nonempty X implies P holds for singleton space

/-- A *radially closed* set is a set such that all limits of transfinite of sequences in the set lie
in the set themselves -/
def IsRadiallyClosed {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ x : X, (∃ (s : Ordinal.{u}) (f : Iio s → X), Tendsto f atTop (𝓝 x)) → x ∈ s

--TODO: limit of transfinite sequence must lie in closure

--TODO: Insert this everywhere its applied (a lot of places)
--TODO: Make notation for this?
/-- A proposition for two spaces being homeomorphic. -/
abbrev IsHomeo (X : Type u) (Y : Type v) [TopologicalSpace X] [TopologicalSpace Y] : Prop :=
  Nonempty (X ≃ₜ Y)

/-- Every space is homeomorph to itself. -/
theorem IsHomeo.refl : IsHomeo X X := .intro <| Homeomorph.refl X

/-- If `X` is homeomorph to `Y`, `Y` is homeomorph to `X´. -/
theorem IsHomeo.symm (h : IsHomeo X Y) : IsHomeo Y X := .intro <| .symm h.some

/-- If `X` is homeomorph to `Y` and `Y´ is homeomorph to `Z`, then `X` is homeomorph to `Z`. -/
theorem IsHomeo.trans (xy : IsHomeo X Y) (yz : IsHomeo Y Z) :
    IsHomeo X Z := .intro <| xy.some.trans yz.some

end AdditionalDefs

end PiBase
