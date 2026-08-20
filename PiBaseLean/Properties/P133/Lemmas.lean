module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P133.Defs
public import Mathlib.Topology.Connected.PathConnected

@[expose] public section

namespace PiBase

open Topology Filter Set TopologicalSpace

variable {X Y : Type*} [t : TopologicalSpace X] [s : TopologicalSpace Y]

instance instLotsOfOrderTopology {X : Type*} [TopologicalSpace X] [h : LinearOrder X]
    [h' : OrderTopology X] : Lots X where from_linear_order := ⟨h, h'⟩

/-- The order topology transported along a homeomorphism is again an order topology. -/
theorem Homeomorph.lots {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    [h : Lots X] (f : X ≃ₜ Y) : Lots Y where
  from_linear_order := by
    classical
    obtain ⟨l, hl⟩ := h.from_linear_order
    let I : LinearOrder Y := Equiv.linearOrder f.toEquiv.symm
    refine ⟨I, ?_⟩
    refine { topology_eq_generate_intervals := ?_ }
    rw [← f.symm.induced_eq]
    refine StrictMono.induced_topology_eq_preorder (fun ⦃a b⦄ a_1 ↦ a_1) ?_
    rw [f.symm.range_coe]
    exact Set.ordConnected_univ

section Meta

theorem WellDefined.lots : WellDefined Lots :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    Homeomorph.lots (h := h) φ

end Meta

end PiBase
