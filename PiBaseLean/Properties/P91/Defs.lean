module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Analysis.Normed.Operator.BanachSteinhaus
public import Mathlib.Topology.Algebra.Module.WeakDual

@[expose] public section

universe u

namespace PiBase

open Topology

/- 91. Eberlein compact -/
class EberleinCompactSpace (X : Type u) [TopologicalSpace X] : Prop extends CompactSpace X where
  eberlein_compact : ∃ (E : Type u) (_ : NormedAddCommGroup E) (_ : NormedSpace ℝ E)
    (f : X → WeakSpace ℝ E), CompleteSpace E ∧ IsEmbedding f

end PiBase

namespace PiBase.Formal

def P91 : Property where
  toPred := EberleinCompactSpace
  well_defined φ h := sorry

end PiBase.Formal
