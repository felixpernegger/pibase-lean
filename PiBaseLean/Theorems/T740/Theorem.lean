module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P162.Bundled
public import PiBaseLean.Properties.P215.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T740: P215 (HereditarilyRealcompactSpace) => P162 (RealcompactSpace) -/
instance instRealcompactSpaceOfHereditarilyRealcompactSpace {X : Type u}
    [TopologicalSpace X] [h : HereditarilyRealcompactSpace X] :
    RealcompactSpace X := h.subset_realcompact.toProperty WellDefined.realcompactSpace

end PiBase

namespace PiBase.Formal

theorem T740 : P215 ≤ P162 := fun X _ ↦ @instRealcompactSpaceOfHereditarilyRealcompactSpace X _

end PiBase.Formal
