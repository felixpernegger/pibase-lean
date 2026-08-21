module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P21.Defs

@[expose] public section

namespace PiBase

open Filter Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.weaklyCountablyCompact [WeaklyCountablyCompact X] (f : X ≃ₜ Y) :
    WeaklyCountablyCompact Y where
  weakly_countably_compact := by
    intro s hsInf
    have hSub : s ⊆ range f := by
      rw [f.range_coe]
      exact subset_univ _
    have hInfPre : (f ⁻¹' s).Infinite := hsInf.preimage hSub
    obtain ⟨x, hx⟩ := (inferInstance : WeaklyCountablyCompact X).weakly_countably_compact _ hInfPre
    refine ⟨f x, ?_⟩
    have hcomap : Filter.comap (f : X → Y) (𝓟 s) = 𝓟 (f ⁻¹' s) := Filter.comap_principal
    have hx_comap : AccPt x (Filter.comap (f : X → Y) (𝓟 s)) := by
      rw [hcomap]
      exact hx
    exact f.isOpenEmbedding.accPt_comap_iff.mp hx_comap

theorem WellDefined.weaklyCountablyCompact : WellDefined WeaklyCountablyCompact :=
  fun {_ _} _ _ h _ ↦ Homeomorph.weaklyCountablyCompact h.some

end PiBase
