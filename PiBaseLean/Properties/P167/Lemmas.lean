module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P167.Defs

@[expose] public section

namespace PiBase

open Topology Filter

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.seqDiscreteSpace [h : SeqDiscreteSpace X] (f : X ≃ₜ Y) :
    SeqDiscreteSpace Y where
  tendsto_constant s y hy := by
    have h_tend : Tendsto (f.symm ∘ s) atTop (𝓝 (f.symm y)) :=
      (f.symm.continuous.continuousAt (x := y)).tendsto.comp hy
    have h_ev := h.tendsto_constant (f.symm ∘ s) (f.symm y) h_tend
    exact h_ev.mono fun n hn => f.symm.injective hn

theorem WellDefined.seqDiscreteSpace : WellDefined SeqDiscreteSpace :=
  fun {_ _} _ _ h _ => Homeomorph.seqDiscreteSpace h.some

end PiBase
