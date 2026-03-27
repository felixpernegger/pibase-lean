import Mathlib
import PibaseLean.AdditionalDefs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u v

namespace UnstablePiBase

/- 31. Metacompact -/
class MetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  metacompact :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end UnstablePiBase
