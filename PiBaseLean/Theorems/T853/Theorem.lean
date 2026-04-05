import PiBaseLean.Properties.P230.Defs
import PiBaseLean.Properties.P231.Defs

open Topology Set Function Filter

namespace PiBase

/- Theorem 853: a locally simply connected space is weakly locally simply connected -/
instance instWeaklyLocallySimplyConnectedSpaceOfLocallySimplyConnectedSpace
    {X : Type*} [TopologicalSpace X] [h : LocallySimplyConnectedSpace X] :
    WeaklyLocallySimplyConnectedSpace X where
  simply_connected_nbhd x := by
    obtain ⟨U, hU⟩ := ((hasBasis_iff.1 <| h.simply_connected_basis x) univ).1 univ_mem
    exact ⟨U, IsOpen.mem_nhds hU.1.2.1 hU.1.1, hU.1.2.2⟩

end PiBase
