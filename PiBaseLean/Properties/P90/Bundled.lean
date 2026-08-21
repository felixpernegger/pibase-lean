module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P90.Lemmas

@[expose] public section

namespace PiBase.Formal

def P90 : Property := WellDefined.toProperty WellDefined.alexandrovDiscrete

end PiBase.Formal
