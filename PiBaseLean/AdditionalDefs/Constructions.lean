module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup
public import Mathlib.Topology.GDelta.MetrizableSpace
public import Mathlib.Topology.Metrizable.Uniformity

@[expose] public section

universe u

/-! This file contains additional general constructions around topological spaces
which are useful for properties and theorems. -/

namespace PiBase

open Set Filter Function Topology

variable {X Y ι : Type*} [TopologicalSpace X] [TopologicalSpace Y]

/-- We call a set `s : Set X` in a topological space *zero*, if there is a continuous function
`f : X → ℝ` such that `f ⁻¹' {0} = s` -/
def IsZero (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0} = s

/-- We call a set `s : Set X` in a topological space *cozero*, if there is a continuous function
`f : X → ℝ` such that `f ⁻¹' {0}ᶜ = s` -/
def IsCozero (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0}ᶜ = s

/-- A cozero set is open. -/
theorem IsCozero.isOpen {s : Set X} (hs : IsCozero s) : IsOpen s := by
  obtain ⟨f, hf⟩ := hs
  rw [← hf]
  apply Continuous.isOpen_preimage f.continuous_toFun {0}ᶜ
  simp

def IsRelativelyCompact {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ {ι : Type u} (U : ι → Set X),
    ∃ t : Finset ι, s ⊆ ⋃ i ∈ t, U i

--TODO: Notation Σ' for this?
/-- Σ-product (of topological spaces).
Not to be confused with the disjoint union (topological sum). -/
def SigmaProduct {Y : ι → Type u} (x : (i : ι) → Y i) : Set ((i : ι) → Y i) :=
  {s : (i : ι) → Y i | {i : ι | s i ≠ x i}.Countable}

/-- A set `s : Set X` is called a *retract*, if there is a continuous map `f : X → s` such that
`∀ x ∈ s, f x = x` -/
def IsRetract {X : Type u} [TopologicalSpace X] (A : Set X) : Prop :=
  ∃ f : C(X, X), f.comp f = f ∧ A = Set.range f

/-- A set is called regular open if it is equal to the interior of its closure. -/
def IsRegularOpen (s : Set X) : Prop :=
  interior (closure s) = s

/-- A regular open set is open -/
theorem IsRegularOpen.isOpen {s : Set X} (hs : IsRegularOpen s) : IsOpen s := hs ▸ isOpen_interior

--TODO: Better to require `X` connected in this def?
/-- A point *cut point* `p` in a space, is a space such that `X \ {p}` is disconnected. -/
def IsCutPoint (p : X) := ¬ IsPreconnected {p}ᶜ

/-- The inseperable component of `x : X` are the points inseparable to that point. -/
def InseparableComponent (x : X) : Set X :=
  {y | Inseparable x y}

@[simp]
theorem mem_self_inseparableComponent (x : X) : x ∈ InseparableComponent x :=
  SeparationQuotient.mk_eq_mk.mp rfl

@[simp]
theorem inseparableComponent_nonempty {x : X} : (InseparableComponent x).Nonempty :=
  .intro x <| mem_self_inseparableComponent x

theorem inseparableComponent_eq {x y : X} (h : Inseparable x y) :
    InseparableComponent x = InseparableComponent y := by
  ext
  exact ⟨fun xz ↦ h.symm.trans xz, fun yz ↦ h.trans yz⟩

/-- A space is T₀ iff all its inseparable components are trivial. -/
theorem t0Space_iff_inseparableComponent_eq_singleton : T0Space X ↔
    ∀ x : X, InseparableComponent x = {x} := by
  simp_rw [t0Space_iff_inseparable, InseparableComponent, Set.ext_iff, mem_singleton_iff]
  refine forall_congr' fun _ ↦ forall_congr' fun _ ↦ ⟨fun h ↦ ?_, by tauto⟩
  exact ⟨fun h' ↦ (h h').symm, fun h ↦ h ▸ mem_setOf.mpr rfl⟩

theorem T0Space.inseparableComponent_singleton [h : T0Space X] (x : X) :
    InseparableComponent x = {x} := t0Space_iff_inseparableComponent_eq_singleton.mp h x

theorem SeparationQuotient.inseparableComponent_preimage (x : X) :
    InseparableComponent x = SeparationQuotient.mk ⁻¹' {SeparationQuotient.mk x} := by
  ext
  simp only [InseparableComponent, mem_setOf_eq, mem_preimage, mem_singleton_iff,
    SeparationQuotient.mk_eq_mk]
  exact ⟨fun h ↦ h.symm, fun h ↦ h.symm⟩

theorem inseparableComponent_of_open {x : X} (h : IsOpen {x}) :
    InseparableComponent x = {x} := by
  ext y
  exact ⟨fun e ↦ (Inseparable.mem_open_iff e h).mp rfl, fun h ↦ h ▸ mem_self_inseparableComponent y⟩

theorem inseparableComponent_of_closed {x : X} (h : IsClosed {x}) :
    InseparableComponent x = {x} := by
  ext y
  refine ⟨fun e ↦ ?_, fun h ↦ h ▸ mem_self_inseparableComponent y⟩
  exact (Inseparable.mem_closed_iff e h).mp rfl

theorem inseparableComponent_subset_open {x : X} {s : Set X} (hs : IsOpen s) (xs : x ∈ s) :
    InseparableComponent x ⊆ s := fun _ h ↦ (Inseparable.mem_open_iff h hs).mp xs

theorem inseparableComponent_subset_closed {x : X} {s : Set X} (hs : IsClosed s) (xs : x ∈ s) :
    InseparableComponent x ⊆ s := fun _ h ↦ (Inseparable.mem_closed_iff h hs).mp xs

/-- The inseparable component is irreducible. -/
theorem IsIrreducible.inseparableComponent (x : X) : IsIrreducible (InseparableComponent x) := by
  refine ⟨inseparableComponent_nonempty, ?_⟩
  intro U V Uo Vo Ux Vx
  refine ⟨x, ?_, ?_, ?_⟩
  · exact mem_self_inseparableComponent x
  · obtain ⟨_, px, pU⟩ := Ux
    exact (Inseparable.mem_open_iff px Uo).mpr pU
  · obtain ⟨_, px, pV⟩ := Vx
    exact (Inseparable.mem_open_iff px Vo).mpr pV

--to mathlib
theorem subsingleton_iff_singleton_univ {α : Type u} (a : α) :
    Subsingleton α ↔ univ = {a} := by
  rw [← subsingleton_univ_iff, subsingleton_iff_singleton (mem_univ a)]
section Symmetric --TODO: If we get significantly more, make this its own file

/-- A symmetric for of a set. -/
class Symmetric (α : Type u) extends Dist α where
  dist_self (x : α) : dist x x = 0
  dist_comm (x y : α) : dist x y = dist y x
  eq_of_dist_eq_zero : ∀ {x y : α}, dist x y = 0 → x = y

/-- A ball for a symmetric. -/
def Symmetric.ball [Symmetric ι] (i : ι) (ε : ℝ) : Set ι := {x : ι | dist x i ≤ ε}

/-- A semimetric space -/
class SemimetricSpace (X : Type u) [TopologicalSpace X] extends Symmetric X where
  symmetric_nbhd (x : X) : (𝓝 x).HasBasis (fun ε => 0 < ε) (Symmetric.ball x)

/-- A symmetric space -/
class SymmetricSpace (X : Type u) [TopologicalSpace X] extends Symmetric X where
  isOpen_iff (s : Set X) : IsOpen s ↔ ∀ x ∈ s, ∃ ε > 0, Symmetric.ball x ε ⊆ s

/-- Every semimetric space is a symmetric space. -/
abbrev SemimetricSpace.symmetricSpace (X : Type u) [TopologicalSpace X] [h : SemimetricSpace X] :
    SymmetricSpace X where
  isOpen_iff s := by
    refine ⟨fun hs ↦ ?_, fun hs ↦ ?_⟩
    · exact fun x xs ↦ (hasBasis_iff.1 (h.symmetric_nbhd x) s).mp <| (IsOpen.mem_nhds_iff hs).mpr xs
    · exact isOpen_iff_mem_nhds.2 (fun x xs ↦ ((hasBasis_iff).1 (h.symmetric_nbhd x) s).2 (hs x xs))

end Symmetric

section Path --TODO: If we get significantly more, make this its own file

/-- A set `s : Set X` is called injectively path connected,
if for any two point in `s` there is an injective path in `x` joining them. -/
def IsInjPathConnected (s : Set X) :=
  Pairwise fun x y : X ↦ x ∈ s → y ∈ s → ∃ f : Path x y, Injective f ∧ range f ⊆ s

/-- An injectively path connected set is path connected. -/
theorem IsInjPathConnected.isPathConnected {s : Set X} (h : IsInjPathConnected s)
    (hs : s.Nonempty) : IsPathConnected s := by
  rw [isPathConnected_iff]
  refine ⟨hs, fun x xs y ys ↦ ?_⟩
  rcases eq_or_ne x y with xy|xy
  · exact xy ▸ JoinedIn.refl xs
  obtain ⟨f, f_inj, fs⟩ := h xy xs ys
  exact ⟨f, fun t ↦ fs (by simp)⟩

/-- A proposition for when the image of the fundamental group at `x : X` under
`f: X → Y` is trivial. -/
def HasTrivialFundGroupImageAt (f : C(X, Y)) (x : X) : Prop :=
  ((FundamentalGroup.map f) x).range = ⊥

end Path

end PiBase
