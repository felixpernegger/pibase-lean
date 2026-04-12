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

open Filter Function Set Topology

variable {X Y Z : Type*} [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace Z]

--TODO: Insert this everywhere its applied (a lot of places)
--TODO: Make notation for this?
/-- A proposition for two spaces being homeomorphic. -/
abbrev IsHomeo (X : Type u) (Y : Type v) [TopologicalSpace X] [TopologicalSpace Y] : Prop :=
  Nonempty (X ≃ₜ Y)

/-- If there is a homeomorphism between two spaces, then they are homeomorph. -/
theorem Homeomorph.isHomeo (φ : X ≃ₜ Y) : IsHomeo X Y := .intro φ

/-- Every space is homeomorph to itself. -/
theorem IsHomeo.refl : IsHomeo X X := .intro <| Homeomorph.refl X

/-- If `X` is homeomorph to `Y`, `Y` is homeomorph to `X´. -/
theorem IsHomeo.symm (h : IsHomeo X Y) : IsHomeo Y X := .intro <| .symm h.some

/-- If `X` is homeomorph to `Y` and `Y´ is homeomorph to `Z`, then `X` is homeomorph to `Z`. -/
theorem IsHomeo.trans (xy : IsHomeo X Y) (yz : IsHomeo Y Z) :
    IsHomeo X Z := .intro <| xy.some.trans yz.some

/-- A space `X` is homeomorph to `univ : Set X`. -/
theorem IsHomeo.Set.univ (X : Type u) [TopologicalSpace X] : IsHomeo (@univ X) X :=
    .intro <| Homeomorph.Set.univ X

theorem IsHomeo.funUnique (ι X : Type*) [Unique ι] [TopologicalSpace X] :
  IsHomeo (ι → X) X := .intro <| _root_.Homeomorph.funUnique ι X

theorem IsHomeo.subset_preimage {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y]
    (f : X ≃ₜ Y) (s : Set Y) : IsHomeo (f ⁻¹' s) s := by
  refine Homeomorph.isHomeo (f.isEmbedding.homeomorphOfSubsetRange ?_)
  exact Homeomorph.range_coe f ▸ subset_univ s

theorem IsHomeo.piCongrRight {ι : Type*} {Y₁ Y₂ : ι → Type u} [∀ i, TopologicalSpace (Y₁ i)]
    [∀ i, TopologicalSpace (Y₂ i)] (F : ∀ i, Y₁ i ≃ₜ Y₂ i) : IsHomeo (∀ i, Y₁ i) (∀ i, Y₂ i) :=
  .intro (Homeomorph.piCongrRight F)

--TODO: `Property` should probably use this
/-- We say a property of topological spaces is well-defined,
if it is preserved by homeomorphisms.

Note: This suffers from universe issues, so it should not be used in isolation.
However it is strong enough to prove some "meta"-theorems, i.e. Hereditary => Property (see below)

A proof that some property `Ex` (defined on all universes, which is almost always the case)
is well-defined should first have that `Ex` is preserved by
homeomorphisms over arbitrary universes (which we can not properly quantify),
i.e. a theorem `Homeomorph.Ex`. Then proving that `Ex` is well-defined can always
be done in the following way:

theorem WellDefined.ex : WellDefined Ex :=
  fun {_ _} _ _ h _ ↦ Homeomorph.ex h.some
-/
abbrev WellDefined (P : (X : Type u) → [TopologicalSpace X] → Prop) : Prop :=
  ∀ {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y],
    IsHomeo X Y → P X → P Y

/-- A well defined property `P` holds for `X` iff it holds for `univ : Set X`. -/
theorem WellDefined.Set.univ {P : (X : Type u) → [TopologicalSpace X] → Prop} (hP : WellDefined P)
    {X : Type u} [TopologicalSpace X] :
    P X ↔ P (@univ X) :=
  ⟨fun h ↦ hP (IsHomeo.Set.univ X).symm h, fun h ↦ hP (IsHomeo.Set.univ X) h⟩

/-- A collection of sets which is the countable union of collection of sets
which have some property. (I.e. sigma locally finite) -/
def Sigma {X : Type v} [TopologicalSpace X] (P : {α : Type u} → (α → Set X) → Prop)
    {ι : Type u} (f : ι → Set X) :=
  ∃ (ω : Type u) (r : ω → Set ι), Countable ω ∧ (⋃ i : ω, r i = univ) ∧
    ∀ i : ω, P (fun (j : r i) ↦ f j.val)

--TODO : Sigma Sigma P = Sigma P (?)

/-- A collection of sets with a well defined property also has the sigma version of the property. -/
theorem property_to_sigma {P : {α : Type u} → (α → Set X) → Prop}
    (hP : ∀ {α β : Type u} (l : α → Set X) (e : β ≃ α), P l → P (l ∘ e))
    {ι : Type u} {f : ι → Set X} (h : P f) : Sigma P f := by
  refine ⟨ULift (Fin 1), fun _ ↦ univ, instCountableULift, iUnion_const univ, fun i ↦ ?_⟩
  exact hP f (Equiv.Set.univ ι) h

/-- For a property P on topological spaces, we say Omega P, is every power of a space satisfies P -/
def Omega (P : (Y : Type u) → [TopologicalSpace Y] → Prop) (X : Type u) [TopologicalSpace X] :
    Prop := ∀ n : ℕ, P (Fin n → X)

--TODO: Put this in mathlib, there is only another (in my opinion worse) version
/-- A empty set is a topological space (with a unique topology). -/
instance instTopologicalSpaceOfIsEmpty (α : Type u) [IsEmpty α] : TopologicalSpace α where
  IsOpen := fun _ ↦ True
  isOpen_univ := trivial
  isOpen_inter _ _ _ _ := trivial
  isOpen_sUnion _ _ := trivial

/-- If `Omega P X` holds, then `P X` holds for well defined properties `P`. -/
theorem Omega.toProperty {Z : Type u} [TopologicalSpace Z]
    {P : (X : Type u) → [TopologicalSpace X] → Prop}
    (hP : WellDefined P) (hZ : Omega P Z) : P Z := hP (IsHomeo.funUnique (Fin 1) Z) <| hZ 1

/-- If `P` is a well-defined property, `Omega P` is as well.
Note this is likely not too useful in practice, as we wants to prove
the stronger version that `Omega P` is preserved by homeomorphisms. -/
theorem Omega.wellDefined {P : (X : Type u) → [TopologicalSpace X] → Prop}
    (h : WellDefined P) : WellDefined (Omega P) :=
  fun {_ _} _ _ XY hX n ↦ h (IsHomeo.piCongrRight fun _ ↦ XY.some) (hX n)

--TODO: Omega P X for some nonempty X implies P holds for singleton space
--TODO: Omega Omega P = Omega P
--TODO (though it's doubtable this actually saves time):
--If P X => Q X, Omega P X => Omega Q X

/-- For a property `P` of topological spaces, `Hereditarily P` means `P` holds for all subspaces. -/
def Hereditarily (P : (Y : Type u) → [TopologicalSpace Y] → Prop)
    (X : Type u) [TopologicalSpace X] : Prop := ∀ s : Set X, P s

/-- If `P` is a well-defined property, `Hereditarily P` is as well.
Note this is likely not too useful in practice, as we wants to prove
the stronger version that `Hereditarily P` is preserved by homeomorphisms. -/
theorem Hereditarily.wellDefined {P : (X : Type u) → [TopologicalSpace X] → Prop}
    (h : WellDefined P) : WellDefined (Hereditarily P) :=
  fun {_ _} _ _ XY hX s ↦ h (IsHomeo.subset_preimage (Nonempty.some XY) s) (hX <| XY.some ⁻¹' s)

--TODO: Hereditarily Hereditarily P = Hereditarily P
--TODO (though it's doubtable this actually saves time):
--If P X => Q X, Hereditarily P X => Hereditarily Q X

--TODO: better name?
/-- For a well defined property `P`, `Hereditarily P X` implies `P X` -/
theorem Hereditarily.toProperty {Z : Type u} [TopologicalSpace Z]
    {P : (X : Type u) → [TopologicalSpace X] → Prop}
    (hP : WellDefined P) (hZ : Hereditarily P Z) : P Z :=
  hP (IsHomeo.Set.univ Z) <| hZ univ

/-- For a property `P`, `Locally P` means every point has a neighborhood basis satisfying `P`.
*Note*: Usage of `Locally` is sometimes inconsistent in the π-base. -/
def Locally (P : (Y : Type u) → [TopologicalSpace Y] → Prop)
    (X : Type u) [TopologicalSpace X] : Prop :=
  ∀ x : X, (𝓝 x).HasBasis (fun (s : Set X) => s ∈ 𝓝 x ∧ P s) id

/-- For a property `P`, `WeaklyLocally P` means every point has a neighborhood satisfying `P`.
*Note*: Usage of `WeaklyLocally` is sometimes inconsistent in the π-base. -/
def WeaklyLocally (P : (Y : Type u) → [TopologicalSpace Y] → Prop)
    (X : Type u) [TopologicalSpace X] : Prop := ∀ x : X, ∃ s ∈ 𝓝 x, P s

/-

/-- `Locally P` implies `WeaklyLocally P`. -/
theorem Locally.weaklyLocally {Z : Type u} [TopologicalSpace Z]
    {P : (X : Type u) → [TopologicalSpace X] → Prop}
    (hZ : Locally P Z) : WeaklyLocally P Z := by
  intro x
  sorry

-/

end PiBase
