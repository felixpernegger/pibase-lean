import PiBaseLean.Properties.P200.Defs

namespace PiBase

/- Theorem 583: a contractible space is (pre-)simply connected -/
instance PreSimplyConnectedSpaceOfLocallySimplyConnectedSpace
    {X : Type*} [TopologicalSpace X] [ContractibleSpace X] :
    PreSimplyConnectedSpace X where
  presimplyconnected := Or.inr <| SimplyConnectedSpace.ofContractible X

end PiBase
