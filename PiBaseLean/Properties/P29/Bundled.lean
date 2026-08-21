module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P29.Lemmas

@[expose] public section

namespace PiBase.Formal

def P29 : Property := WellDefined.toProperty WellDefined.countableChainCondition

end PiBase.Formal
