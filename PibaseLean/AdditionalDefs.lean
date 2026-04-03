import Mathlib.Data.Set.Card
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import Mathlib.Topology.Path
import Mathlib.Topology.Connected.PathConnected

universe u

/-! This file contains additional definitions which are useful for properties and theorems. -/

namespace Topology

namespace PiBase

namespace AdditionalDefs

open Filter Function Set Topology TopologicalSpace

variable
  {X Y ι ι' α X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y] {f g : ι → Set X}

def IsInjPathConnected (s : Set X) :=
  Pairwise fun x y : X ↦ x ∈ s → y ∈ s → ∃ f : Path x y, Injective f ∧ range f ⊆ s

theorem IsInjPathConnected.isPathConnected {s : Set X} (h : IsInjPathConnected s)
    (hs : s.Nonempty) : IsPathConnected s := by
  rw [isPathConnected_iff]
  refine ⟨hs, fun x xs y ys ↦ ?_⟩
  rcases eq_or_ne x y with xy|xy
  · exact xy ▸ JoinedIn.refl xs
  obtain ⟨f, f_inj, fs⟩ := h xy xs ys
  exact ⟨f, fun t ↦ by apply fs; simp⟩

def PointFinite (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Finite

def PointCountable (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Countable

def IsCozero {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0}ᶜ = s

def IsRelativelyCompact {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ {ι : Type u} (U : ι → Set X),
    ∃ t : Set ι, t.Finite ∧ s ⊆ ⋃ i ∈ t, U i

def IsDiscreteFamily {X : Type u} {ι : Type u} [TopologicalSpace X] (F : ι → Set X) : Prop :=
  ∀ x : X, ∃ U ∈ 𝓝 x, {i : ι | F i ∩ U ≠ ∅}.encard ≤ 1

def SigmaProduct {ι : Type*} {Y : ι → Type u} (x : (i : ι) → Y i) : Set ((i : ι) → Y i) :=
  {s : (i : ι) → Y i | {i : ι | s i ≠ x i}.Countable}

def IsRetraction {X : Type u} [TopologicalSpace X] {A : Set X} (f : X → A) : Prop :=
  Continuous f ∧ ∀ a ∈ A, f a = a

def IsRetract {X : Type u} [TopologicalSpace X] (A : Set X) : Prop :=
  ∃ f : X → A, IsRetraction f

variable (A : Set ℕ)

def LocallyCountable (f : ι → Set X) :=
  ∀ x : X, ∃ t ∈ 𝓝 x, { i | (f i ∩ t).Nonempty }.Finite

end AdditionalDefs

end PiBase

end Topology
