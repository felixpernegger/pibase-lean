module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P217.Lemmas

@[expose] public section

namespace PiBase.Formal

def P217 : Property := WellDefined.toProperty WellDefined.stronglyZeroDimensionalSpace

end PiBase.Formal
