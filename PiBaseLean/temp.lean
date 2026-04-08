module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P133.Defs
public import PiBaseLean.Properties.P32.Defs
public import PiBaseLean.Properties.P100.Defs
public import Mathlib.Topology.Sets.OpenCover
public import Mathlib.Topology.Separation.CompletelyRegular
public import Mathlib.Topology.Defs.Filter

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

open PiBase.AdditionalDefs

/-- 141. k₂-space -/
class K2Space (X : Type u) [TopologicalSpace X] : Prop where
  isCoherentWith : IsCoherentWith {s : Set X | ∀ (Y : Type u) (_ : TopologicalSpace Y) (f : Y → X),
    CompactSpace Y → T2Space Y → Continuous f → IsOpen (f ⁻¹' s)}

/-- 142. k₃-space -/
class K3Space (X : Type u) [TopologicalSpace X] : Prop where
  isCoherentWith : IsCoherentWith {K : Set X | T2Space K ∧ IsCompact K}

/-- 143. Weak Hausdorff -/
class WeakT2Space (X : Type u) [TopologicalSpace X] : Prop where
  compact_closed : ∀ {K : Type u} (_ : TopologicalSpace K) ⦃f : K → X⦄,
    Continuous f → CompactSpace K → T2Space K → IsClosed (range f)

/-- 144. Locally pseudometrizable -/
class LocallyPseudoMetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nbhd_pseudometrizable (x : X) : ∃ s ∈ 𝓝 x, PseudoMetrizableSpace s

/-- 170. k₁-Hausdorff -/
class K1T2Space (X : Type u) [TopologicalSpace X] : Prop extends KcSpace X, LocallyCompactSpace X

end PiBase
