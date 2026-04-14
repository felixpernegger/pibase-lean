module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P185.Defs

@[expose] public section

namespace PiBase

universe u

open Topology Filter Set Function TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

--to mathlib
/-- A set is open iff its image in the Kolmogorov quotient is open and saturated. -/
theorem SeparationQuotient.isOpen_iff (s : Set X) :
    IsOpen s ↔ (IsOpen (SeparationQuotient.mk '' s) ∧
      SeparationQuotient.mk ⁻¹' (SeparationQuotient.mk '' s) = s) := by
  refine ⟨fun hs ↦ ?_, fun  ⟨hs, hs'⟩ ↦ ?_⟩
  · exact ⟨SeparationQuotient.isOpenMap_mk s hs, SeparationQuotient.preimage_image_mk_open hs⟩
  · exact hs' ▸ isOpen_coinduced.mp hs

--to mathlib
/-- A set is clopen iff its image in the Kolmogorov quotient is open and saturated. -/
theorem SeparationQuotient.isClosed_iff (s : Set X) :
    IsClosed s ↔ (IsClosed (SeparationQuotient.mk '' s) ∧
      SeparationQuotient.mk ⁻¹' (SeparationQuotient.mk '' s) = s) := by
  refine ⟨fun hs ↦ ?_, fun  ⟨hs, hs'⟩ ↦ ?_⟩
  · exact ⟨SeparationQuotient.isClosedMap_mk s hs, SeparationQuotient.preimage_image_mk_closed hs⟩
  · exact hs' ▸ isClosed_coinduced.mp hs

/-- A space has partition topology iff every set is open iff it is saturated. -/
theorem partitionTopology_iff_isOpen_iff_saturated (X : Type u) [TopologicalSpace X] :
    PartitionTopology X ↔ (∀ s : Set X, IsOpen s ↔
      SeparationQuotient.mk ⁻¹' (SeparationQuotient.mk '' s) = s) := by
  refine ⟨fun h s ↦ ?_, fun h ↦ ?_⟩
  · rw [SeparationQuotient.isOpen_iff]
    simp [h.quotient_discrete]
  · apply PartitionTopology.mk
    refine discreteTopology_iff_forall_isOpen.mpr ?_
    intro s
    rw [← image_preimage_eq s SeparationQuotient.surjective_mk]
    apply SeparationQuotient.isOpenMap_mk
    rw [h, preimage_image_preimage]

/-- A space has partition topology iff every set is clopen iff it is saturated. -/
theorem partitionTopology_iff_isClosed_iff_saturated (X : Type u) [TopologicalSpace X] :
    PartitionTopology X ↔ (∀ s : Set X, IsClosed s ↔
      SeparationQuotient.mk ⁻¹' (SeparationQuotient.mk '' s) = s) := by
  refine ⟨fun h s ↦ ?_, fun h ↦ ?_⟩
  · rw [SeparationQuotient.isClosed_iff]
    simp [h.quotient_discrete]
  · apply PartitionTopology.mk
    refine discreteTopology_iff_forall_isClosed.mpr ?_
    intro s
    rw [← image_preimage_eq s SeparationQuotient.surjective_mk]
    apply SeparationQuotient.isClosedMap_mk
    rw [h, preimage_image_preimage]

theorem partitionTopology_iff_isOpen_iff_isClosed {X : Type u} [TopologicalSpace X]
    [h : PartitionTopology X] (s : Set X) : IsOpen s ↔ IsClosed s := by
  rw [SeparationQuotient.isOpen_iff, SeparationQuotient.isClosed_iff]
  simp [h.quotient_discrete]

theorem PartitionTopology.inseparable_open (X : Type u) [TopologicalSpace X]
    [h : PartitionTopology X] (x : X) : IsOpen {y | Inseparable x y} := by
  rw [(partitionTopology_iff_isOpen_iff_saturated X).1 h]
  ext y
  simp only [mem_preimage, mem_image, mem_setOf_eq, SeparationQuotient.mk_eq_mk]
  exact ⟨fun ⟨_, xz, zy⟩ ↦ xz.trans zy, fun h ↦ ⟨x, .refl x, h⟩⟩

theorem PartitionTopology.inseparable_closed (X : Type u) [TopologicalSpace X]
    [h : PartitionTopology X] (x : X) : IsClosed {y | Inseparable x y} :=
  (partitionTopology_iff_isOpen_iff_isClosed {y | Inseparable x y}).mp <| inseparable_open X x

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.partitionTopology : WellDefined PartitionTopology :=
  sorry

end Meta

end PiBase
