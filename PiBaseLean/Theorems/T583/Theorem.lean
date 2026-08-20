module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P199.Bundled
public import PiBaseLean.Properties.P200.Bundled

@[expose] public section

namespace PiBase

/- Theorem 583: a contractible space is (pre-)simply connected -/
instance PresimplyConnectedSpaceOfLocallySimplyConnectedSpace
    {X : Type*} [TopologicalSpace X] [ContractibleSpace X] :
    PresimplyConnectedSpace X where
  presimplyconnected := Or.inr <| SimplyConnectedSpace.ofContractible X

end PiBase

namespace PiBase.Formal

theorem T583 : P199 ≤ P200 := @PresimplyConnectedSpaceOfLocallySimplyConnectedSpace

end PiBase.Formal
