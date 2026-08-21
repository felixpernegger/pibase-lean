module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P73.Lemmas

@[expose] public section

namespace PiBase.Formal

def P73 : Property := WellDefined.toProperty WellDefined.soberSpace

end PiBase.Formal
