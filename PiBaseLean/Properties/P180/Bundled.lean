module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P180.Lemmas

@[expose] public section

namespace PiBase.Formal

def P180 : Property := WellDefined.toProperty WellDefined.hereditarilySeparableSpace

end PiBase.Formal
