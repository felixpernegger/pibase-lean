module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P109.Bundled
public import PiBaseLean.Properties.P53.Bundled

import Mathlib.Topology.Metrizable.Uniformity

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T669: P53 (MetrizableSpace) => P109 (MonotonicallyNormalSpace)

Fix a metric inducing the topology. For `x ∈ U` pick `r > 0` with `ball x (2 * r) ⊆ U`,
and let `μ x U` be `ball x r`.

If `ball x r₁` and `ball y r₂` meet, say at `z`, then
`dist x y ≤ dist x z + dist z y < r₁ + r₂`. Whichever radius is larger absorbs the sum:
if `r₂ ≤ r₁` then `dist x y < 2 * r₁`, so `y ∈ ball x (2 * r₁) ⊆ U`, and symmetrically
in the other case. That is exactly the disjunction monotone normality asks for. -/
theorem instMonotonicallyNormalSpaceOfMetrizableSpace {X : Type u}
    [TopologicalSpace X] [MetrizableSpace X] : MonotonicallyNormalSpace X where
  monotonically_normal := by
    let _ := metrizableSpaceMetric X
    have key : ∀ (x : X) (s : Opens X), x ∈ s → ∃ r : ℝ, 0 < r ∧ Metric.ball x (2 * r) ⊆ s := by
      intro x s hs
      obtain ⟨δ, hδ, hsub⟩ := Metric.isOpen_iff.mp s.isOpen x hs
      refine ⟨δ / 2, by linarith, ?_⟩
      rwa [show 2 * (δ / 2) = δ by ring]
    choose r hr hball using key
    refine ⟨fun x s hs ↦ ⟨Metric.ball x (r x s hs), Metric.isOpen_ball⟩, fun x s hs ↦ ⟨?_, ?_⟩⟩
    · exact Metric.mem_ball_self (hr x s hs)
    · intro a b u v hu hv hne
      obtain ⟨z, hz₁, hz₂⟩ := Set.nonempty_iff_ne_empty.2 hne
      replace hz₁ : dist z a < r a u hu := hz₁
      replace hz₂ : dist z b < r b v hv := hz₂
      have hab : dist a b < r a u hu + r b v hv := by
        calc dist a b ≤ dist a z + dist z b := dist_triangle a z b
        _ = dist z a + dist z b := by rw [dist_comm a z]
        _ < r a u hu + r b v hv := add_lt_add hz₁ hz₂
      rcases le_total (r b v hv) (r a u hu) with h | h
      · refine Or.inr (hball a u hu ?_)
        rw [Metric.mem_ball, dist_comm]
        linarith
      · refine Or.inl (hball b v hv ?_)
        rw [Metric.mem_ball]
        linarith

end PiBase

namespace PiBase.Formal

theorem T669 : P53 ≤ P109 := fun X _ h ↦ @instMonotonicallyNormalSpaceOfMetrizableSpace X _ h

end PiBase.Formal
