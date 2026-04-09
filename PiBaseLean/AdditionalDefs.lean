module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup
public import Mathlib.Data.Set.Card
public import Mathlib.SetTheory.Ordinal.Basic
public import Mathlib.Topology.Sets.OpenCover

@[expose] public section

universe u v

/-! This file contains additional definitions which are useful for properties and theorems. -/

namespace PiBase

namespace AdditionalDefs

open Filter Function Set Topology TopologicalSpace

variable
  {X Y ι ι' α X : Type*} [TopologicalSpace X] [TopologicalSpace Y] {f g : ι → Set X}

def IsInjPathConnected (s : Set X) :=
  Pairwise fun x y : X ↦ x ∈ s → y ∈ s → ∃ f : Path x y, Injective f ∧ range f ⊆ s

theorem IsInjPathConnected.isPathConnected {s : Set X} (h : IsInjPathConnected s)
    (hs : s.Nonempty) : IsPathConnected s := by
  rw [isPathConnected_iff]
  refine ⟨hs, fun x xs y ys ↦ ?_⟩
  rcases eq_or_ne x y with xy|xy
  · exact xy ▸ JoinedIn.refl xs
  obtain ⟨f, f_inj, fs⟩ := h xy xs ys
  exact ⟨f, fun t ↦ fs (by simp)⟩

def PointFiniteAt (U : ι → Set X) (x : X) :=
  { i | x ∈ U i }.Finite

def PointFinite (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Finite

def PointCountable (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Countable

def IsZero {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0} = s

def IsCozero {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0}ᶜ = s

def IsRelativelyCompact {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ {ι : Type u} (U : ι → Set X),
    ∃ t : Set ι, t.Finite ∧ s ⊆ ⋃ i ∈ t, U i

def IsDiscreteFamily {X : Type u} {ι : Type u} [TopologicalSpace X] (F : ι → Set X) : Prop :=
  ∀ x : X, ∃ U ∈ 𝓝 x, {i : ι | F i ∩ U ≠ ∅}.encard ≤ 1

/-- An omega cover -/
def IsOmegaCover {X ι : Type*} [TopologicalSpace X] (f : ι → Opens X) : Prop :=
  IsOpenCover f ∧ ⊤ ∉ range f ∧ ∀ s : Finset X, ∃ i : ι, (↑s : Set X) ⊆ (↑(f i) : Set X)

--TODO: Notation Σ' for this?
/-- Sigma product (of topological spaces).
Not to be confused with the disjoint union (topological sum). -/
def SigmaProduct {ι : Type*} {Y : ι → Type u} (x : (i : ι) → Y i) : Set ((i : ι) → Y i) :=
  {s : (i : ι) → Y i | {i : ι | s i ≠ x i}.Countable}

def IsRetraction {X : Type u} [TopologicalSpace X] (A : Set X) : Prop :=
  ∃ f : C(X, X), f.comp f = f ∧ A = Set.range f

/-- Star of an open cover. -/
def CoverStar {X ι : Type*} (U : ι → Set X) [TopologicalSpace X] (x : X) :
    Set X := ⋃ i : ι, ⋃ (_ : x ∈ U i), U i

/-- A star finite collection of sets. -/
def StarFinite {X ι : Type*} (U : ι → Set X) [TopologicalSpace X] : Prop :=
  ∀ i : ι, {j : ι | U i ∩ U j ≠ ∅}.Finite

variable (A : Set ℕ)

/-- A collection of sets which is the countable union of collection of sets
which have some property. (I.e. sigma locally finite) -/
def Sigma {X : Type v} [TopologicalSpace X] (P : {α : Type u} → (α → Set X) → Prop)
    {ι : Type u} (f : ι → Set X) :=
  ∃ (ω : Type u) (r : ω → Set ι), Countable ω ∧ (⋃ i : ω, r i = univ) ∧
    (∀ i : ω, P (fun (j : r i) ↦ f j.val))

/-- A collection of sets with a property also has the sigma version of the property. -/
theorem property_to_sigma
    {X : Type v} [TopologicalSpace X] {P : {α : Type u} → (α → Set X) → Prop}
    (hP : ∀ {α β : Type u} (l : α → Set X) (e : β ≃ α), P l → P (l ∘ e))
    {ι : Type u} {f : ι → Set X} (h : P f) : Sigma P f := by
  refine ⟨ULift (Fin 1), fun _ ↦ univ, instCountableULift, iUnion_const univ, fun i ↦ ?_⟩
  exact hP f (Equiv.Set.univ ι) h

def LocallyCountable {ι : Type u} (f : ι → Set X) :=
  ∀ x : X, ∃ t ∈ 𝓝 x, {i | (f i ∩ t).Nonempty}.Countable

def IsCutPoint (p : X) := ¬ IsConnected {p}ᶜ

/-- The image of the fundamental group of under f:X → Y at x : X is trivial. -/
def HasTrivialFundGroupImageAt (f : C(X, Y)) (x : X) : Prop :=
  ((FundamentalGroup.map f) x).range = ⊥

/-- A symmetric for of a set. -/
class Symmetric (α : Type u) extends Dist α where
  dist_self (x : α) : dist x x = 0
  dist_comm (x y : α) : dist x y = dist y x
  eq_of_dist_eq_zero : ∀ {x y : α}, dist x y = 0 → x = y

def Symmetric.ball {α : Type u} [Symmetric α] (a : α) (ε : ℝ) : Set α := {x : α | dist x a ≤ ε}

/-- A semimetric space -/
class SemimetricSpace (X : Type u) [TopologicalSpace X] extends Symmetric X where
  symmetric_nbhd (x : X) : (𝓝 x).HasBasis (fun ε => 0 < ε) (Symmetric.ball x)

/-- A symmetric space -/
class SymmetricSpace (X : Type u) [TopologicalSpace X] extends Symmetric X where
  isOpen_iff (s : Set X) : IsOpen s ↔ ∀ x ∈ s, ∃ ε > 0, Symmetric.ball x ε ⊆ s

/-- A network of a topological space. -/
def IsNetwork {X ι : Type*} [TopologicalSpace X] (f : ι → Set X) : Prop :=
  ∀ᵉ (x : X) (s ∈ 𝓝 x), ∃ i : ι, x ∈ f i ∧ f i ⊆ s

/-- A k-network of a topological space. -/
def IsKNetwork {X ι : Type*} [TopologicalSpace X] (f : ι → Set X) : Prop :=
  ∀ ⦃U K : Set X⦄, IsOpen U → IsCompact K → K ⊆ U → ∃ s : Set ι, K ⊆ ⋃ i ∈ s, f i ∧ ⋃ i ∈ s, f i ⊆ U

/-- K-cover of a topological space -/
def IsKCover {X ι : Type*} [TopologicalSpace X] (f : ι → Opens X) : Prop :=
  IsOpenCover f ∧ ⊤ ∉ range f ∧ ∀ ⦃K : Set X⦄, IsCompact K → ∃ i : ι, K ⊆ f i

/-- A set is called regular open if it is equal to the interior of its closure. -/
def IsRegularOpen {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  interior (closure s) = s

/-- For a property P on topological spaces, we say Omega P, is every power of a space satisfies P -/
def Omega (P : (Y : Type u) → [TopologicalSpace Y] → Prop)
    (X : Type u) [TopologicalSpace X] : Prop := ∀ n : ℕ, P (Fin n → X)

--TODO: Put this in mathlib, there is only another (in my opinion worse) version
/-- A empty set is a topologicalspace -/
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

open Cardinal Ordinal

/-- Spread of a topological space -/
noncomputable def Spread (X : Type u) [TopologicalSpace X] : Cardinal.{u} :=
  sSup {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsDiscrete D} + ℵ₀

/-- Spread of a topological space -/
noncomputable def Extent (X : Type u) [TopologicalSpace X] : Cardinal.{u} :=
  sSup {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsClosed D ∧ IsDiscrete D} + ℵ₀

/-- A radially closed set -/
def IsRadiallyClosed {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ x : X, (∃ (s : Ordinal.{u}) (f : Iio s → X), Tendsto f atTop (𝓝 x)) → x ∈ s

--TODO: limit of transfinite sequence must lie in closure

--TODO: Insert this everywhere its applied (a lot of places)
--TODO: Make notation for this?
abbrev IsHomeo (X : Type u) (Y : Type v) [TopologicalSpace X] [TopologicalSpace Y] : Prop :=
  Nonempty (X ≃ₜ Y)

theorem IsHomeo.refl (X : Type u) [TopologicalSpace X] : IsHomeo X X := .intro <| Homeomorph.refl X

theorem IsHomeo.symm (X : Type u) (Y : Type v) [TopologicalSpace X] [TopologicalSpace Y]
    (h : IsHomeo X Y) : IsHomeo Y X := .intro <| .symm h.some

theorem IsHomeo.trans {X Y Z : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    [TopologicalSpace Z] (xy : IsHomeo X Y) (yz : IsHomeo Y Z) :
    IsHomeo X Z := .intro <| xy.some.trans yz.some

end AdditionalDefs

end PiBase
