module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P202.Lemmas

@[expose] public section

namespace PiBase.Formal

def P202 : Property := WellDefined.toProperty WellDefined.hasPointWithUniqueNeighborhood

end PiBase.Formal
