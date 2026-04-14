module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P121.Defs
public import PiBaseLean.Properties.P185.Lemmas
public import Mathlib.Topology.Metrizable.Uniformity

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

universe u

section Meta

--inline this
lemma pseudoMetrizableSpace_iff_exists_pseudoMetric (X : Type u) [τ : TopologicalSpace X] :
    PseudoMetrizableSpace X ↔
      ∃ (t : PseudoMetricSpace X), t.toUniformSpace.toTopologicalSpace = τ := by
  refine ⟨fun h ↦ ⟨pseudoMetrizableSpacePseudoMetric X, rfl⟩, fun ⟨t, th⟩ ↦ ?_⟩
  rw [← th]
  exact UniformSpace.pseudoMetrizableSpace

lemma metrizableSpace_iff_exists_metric (X : Type u) [τ : TopologicalSpace X] :
    MetrizableSpace X ↔
      ∃ (t : MetricSpace X), t.toUniformSpace.toTopologicalSpace = τ := by
  refine ⟨fun h ↦ ?_, fun ⟨t, th⟩ ↦ ?_⟩
  · refine ⟨metrizableSpaceMetric X, ?_⟩
    rfl
  · rw [← th]
    apply @PseudoMetrizableSpace.toMetrizableSpace X
      <| PseudoMetricSpace.toUniformSpace.toTopologicalSpace (α := X)

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.pseudoMetrizableSpace : WellDefined PseudoMetrizableSpace :=
  sorry

end Meta

end PiBase
