module

public import Mathlib.Topology.Sets.OpenCover
public import Mathlib.Data.Set.Card

@[expose] public section

/-! This file contains additional definitions and statements around covers of topological spaces
which are useful for properties and theorems. -/

namespace PiBase

open Function Set Topology TopologicalSpace

variable {X ι : Type*}

/-- A collection of sets is called *point finite at a point `x`*
if it meets `x` only finitely many times. -/
def PointFiniteAt (U : ι → Set X) (x : X) :=
  { i | x ∈ U i }.Finite

/-- A collection of sets is called *point finite* if it is point finite at each point. -/
def PointFinite (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Finite

/-- A collection of sets is called *point countable*
if it meets every point only countably many times. -/
def PointCountable (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Countable

/-- Star of an open cover. -/
def CoverStar (U : ι → Set X) (x : X) :
    Set X := ⋃ i : ι, ⋃ (_ : x ∈ U i), U i

/-- A collection of sets is called *star finite*
if each member of the collection only meets finitely many other member. -/
def StarFinite (U : ι → Set X) : Prop :=
  ∀ i : ι, {j : ι | (U j ∩ U i).Nonempty}.Finite

/-- A point finite collection of sets is point countable. -/
theorem PointFinite.pointCountable {U : ι → Set X} (h : PointFinite U) : PointCountable U :=
  fun x ↦ (h x).countable

/-- A finite family of sets is star finite. -/
theorem Finite.starFinite (U : ι → Set X) (h : Finite ι) : StarFinite U :=
  fun _ ↦ toFinite _

/-- A finite family of sets is locally finite. -/
theorem Finite.locallyFinite [TopologicalSpace X] (U : ι → Set X) (h : Finite ι) :
    LocallyFinite U := fun _ ↦ ⟨univ, Filter.univ_mem, toFinite {i | (U i ∩ univ).Nonempty}⟩

/-- A star finite collection of sets is point finite. -/
theorem StarFinite.PointFinite {U : ι → Set X} (h : StarFinite U) : PointFinite U := by
  intro x
  by_cases! hx : {i : ι | x ∈ U i}.Nonempty
  · obtain ⟨i, hi⟩ := hx
    exact (h i).subset <| fun _ h' ↦ ⟨x, h', hi⟩
  · exact hx ▸ finite_empty

variable [TopologicalSpace X]

/-- A family of sets in `Set X` is locally finite if at every point `x : X`,
there is a neighborhood of `x` which meets only countably many sets in the family. -/
def LocallyCountable (U : ι → Set X) :=
  ∀ x : X, ∃ t ∈ 𝓝 x, {i | (U i ∩ t).Nonempty}.Countable

/-- A countable family of sets is locally countable. -/
theorem Countable.locallyCountable (U : ι → Set X) (h : Countable ι) : LocallyCountable U :=
  fun _ ↦ ⟨univ, Filter.univ_mem, to_countable {i | (U i ∩ univ).Nonempty}⟩

/-- A locally finite collection of sets is locally countable. -/
theorem LocallyFinite.locallyCountable {U : ι → Set X} (h : LocallyFinite U) :
    LocallyCountable U := fun x ↦
  let ⟨t, tx, ht⟩ := h x
  ⟨t, tx, ht.countable⟩

/-- A discrete family of sets. -/
def IsDiscreteFamily (F : ι → Set X) : Prop :=
  ∀ x : X, ∃ U ∈ 𝓝 x, {i : ι | (F i ∩ U).Nonempty}.encard ≤ 1

/-- An omega cover of a space. -/
def IsOmegaCover (f : ι → Opens X) : Prop :=
  IsOpenCover f ∧ ⊤ ∉ range f ∧ ∀ s : Finset X, ∃ i : ι, (↑s : Set X) ⊆ (↑(f i) : Set X)

/-- A locally finite collection of sets is point finite. -/
theorem LocallyFinite.PointFinite {U : ι → Set X} (h : LocallyFinite U) : PointFinite U :=
  LocallyFinite.point_finite h

/-- A star finite open cover is locally finite. -/
theorem StarFinite.locallyFinite {U : ι → Set X} (h : StarFinite U)
    (U_open : ∀ (a : ι), IsOpen (U a)) (U_cover : ⋃ (a : ι), U a = univ) : LocallyFinite U := by
  intro x
  obtain ⟨s, ⟨⟨i, hi⟩, xs⟩⟩ := U_cover ▸ mem_univ x
  dsimp at hi
  exact ⟨U i, (IsOpen.mem_nhds_iff (U_open i)).mpr <| hi ▸ xs, h i⟩

--TODO: Add to mathlib
instance _root.Countable.Set.countable_sep (s : Set ι) (p : ι → Prop) [h : Countable s] :
    Countable ({ a ∈ s | p a } : Set ι) := by
  obtain ⟨f, hf⟩ := (countable_iff_exists_injective s).mp h
  refine (countable_iff_exists_injective ↑{a | a ∈ s ∧ p a}).mpr ?_
  refine ⟨fun x ↦ f ⟨x.val, x.2.1⟩, ?_⟩
  apply Injective.comp hf
  intro x y xy
  simp only [mem_setOf_eq, Subtype.mk.injEq] at xy
  ext
  exact xy

--TODO: Add to mathlib
theorem _root_.Countable.subset {s : Set ι} (hs : s.Countable) {t : Set ι} (h : t ⊆ s) :
    t.Countable := by
  have := hs.to_subtype
  rw [← sep_eq_of_subset h]
  change Countable {x | x ∈ s ∧ x ∈ t}
  infer_instance

--to mathlib
theorem _root_.Set.Countable.diff {α : Type u} {s t : Set α} (hs : s.Countable) :
    (s \ t).Countable := Countable.subset hs diff_subset

/-- A locally countable collection of sets is point countable. -/
theorem LocallyCountable.pointCountable {U : ι → Set X} (h : LocallyCountable U) :
    PointCountable U := fun x ↦ by
  obtain ⟨t, hxt, ht⟩ := h x
  exact Countable.subset ht <| fun _ h ↦ ⟨x, h, mem_of_mem_nhds hxt⟩

/-- A network of a topological space. -/
def IsNetwork (f : ι → Set X) : Prop :=
  ∀ᵉ (x : X) (s ∈ 𝓝 x), ∃ i : ι, x ∈ f i ∧ f i ⊆ s

/-- A k-network of a topological space. -/
def IsKNetwork (f : ι → Set X) : Prop :=
  ∀ U K : Set X, IsOpen U → IsCompact K → K ⊆ U → ∃ s : Set ι, K ⊆ ⋃ i ∈ s, f i ∧ ⋃ i ∈ s, f i ⊆ U

/-- Every k-network is a network -/
theorem IsKNetwork.isNetwork {f : ι → Set X} (h : IsKNetwork f) : IsNetwork f := by
  intro x s sx
  obtain ⟨t, xt, ft⟩ := h (interior s) {x} isOpen_interior isCompact_singleton
    (by simp [mem_interior_iff_mem_nhds.mpr sx])
  simp only [singleton_subset_iff, mem_iUnion, exists_prop] at xt
  obtain ⟨i, it, xi⟩ := xt
  refine ⟨i, xi, ?_⟩
  calc
    f i ⊆ ⋃ i ∈ t, f i := by exact subset_iUnion₂_of_subset i it <| .refl (f i)
      _ ⊆ interior s := ft
      _ ⊆ s := interior_subset

/-- K-cover of a topological space -/
def IsKCover (f : ι → Opens X) : Prop :=
  IsOpenCover f ∧ ⊤ ∉ range f ∧ ∀ ⦃K : Set X⦄, IsCompact K → ∃ i : ι, K ⊆ f i

end PiBase
