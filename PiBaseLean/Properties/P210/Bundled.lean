module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P210.Lemmas

@[expose] public section

namespace PiBase.Formal

def P210 : Property := WellDefined.toProperty WellDefined.α1Space

end PiBase.Formal
