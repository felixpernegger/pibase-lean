module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P138.Lemmas

@[expose] public section

namespace PiBase.Formal

def P138 : Property := WellDefined.toProperty WellDefined.countablyManyContinuousSelfMaps

end PiBase.Formal
