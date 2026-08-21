module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P189.Defs

@[expose] public section

namespace PiBase

open Set Function

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.sigmaConnectedSpace : WellDefined SigmaConnectedSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    have h_conn : PreconnectedSpace Y := by
      constructor
      have hpre := isPreconnected_range (β := Y) φ.continuous
      simpa [EquivLike.range_eq_univ] using hpre
    refine { h_conn with no_partition := ?_ }
    intro fY ⟨hInjY, hPartY⟩
    let fX : ℕ → Set X := fun n => φ ⁻¹' (fY n)
    have hfX : ∀ n, fX n = φ ⁻¹' (fY n) := fun _ => rfl
    have hInjX : Injective fX := by
      intro m n hmn
      apply hInjY
      have h1 : φ '' fX m = φ '' fX n := congrArg (φ '' ·) hmn
      rwa [hfX, hfX, φ.image_preimage, φ.image_preimage] at h1
    have hPartX : Setoid.IsPartition (range fX) := by
      apply Set.PairwiseDisjoint.isPartition_of_exists_of_ne_empty
      · rintro s ⟨m, rfl⟩ t ⟨n, rfl⟩ hst
        have hmn : fY m ≠ fY n := fun he => hst (by rw [hfX, hfX, he])
        have hd := (hPartY.pairwiseDisjoint (Set.mem_range_self m)
          (Set.mem_range_self n) hmn).preimage φ
        rwa [hfX, hfX]
      · intro x
        obtain ⟨b, ⟨hb_mem, hb_x⟩, -⟩ := hPartY.2 (φ x)
        obtain ⟨n, rfl⟩ := hb_mem
        exact ⟨fX n, Set.mem_range_self n, by rw [hfX]; exact hb_x⟩
      · rintro ⟨n, hn⟩
        refine hPartY.1 ⟨n, ?_⟩
        have h1 := (φ.image_preimage (fY n)).symm
        rw [← hfX, hn, Set.image_empty] at h1
        exact h1
    obtain ⟨n, hn⟩ := h.no_partition fX ⟨hInjX, hPartX⟩
    refine ⟨n, ?_⟩
    intro hClosedY
    have hClosedX : IsClosed (fX n) := by
      rw [hfX]
      exact hClosedY.preimage φ.continuous
    exact hn hClosedX

end PiBase
