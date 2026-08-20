module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P98.Lemmas

@[expose] public section

namespace PiBase.Formal

def P98 : Property := WellDefined.toProperty WellDefined.kω1Space

end PiBase.Formal
