module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P216.Bundled
public import PiBaseLean.Properties.P30.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T744: P216 (HereditarilyParacompact) => P30 (ParacompactSpace) -/
instance instParacompactSpaceOfHereditarilyParacompact {X : Type u}
    [TopologicalSpace X] [h : HereditarilyParacompact X] :
    ParacompactSpace X := h.subset_paracompact.toProperty WellDefined.paracompactSpace

end PiBase

namespace PiBase.Formal

theorem T744 : P216 ≤ P30 := fun X _ ↦ @instParacompactSpaceOfHereditarilyParacompact X _

end PiBase.Formal
