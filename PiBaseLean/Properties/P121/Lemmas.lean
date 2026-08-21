module

public import Mathlib.Topology.Metrizable.Uniformity
public import PiBaseLean.Properties.P185.Lemmas

@[expose] public section

namespace PiBase

open TopologicalSpace

universe u

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
  fun {_ _} _ _ hXY _ =>
    let φ := hXY.some
    φ.symm.isInducing.pseudoMetrizableSpace

end PiBase
