module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P137.Lemmas

@[expose] public section

namespace PiBase.Formal

def P137 : Property := WellDefined.toProperty WellDefined.isEmpty

end PiBase.Formal
