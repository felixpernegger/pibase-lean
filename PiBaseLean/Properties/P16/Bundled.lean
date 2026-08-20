module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P16.Lemmas

@[expose] public section

namespace PiBase.Formal

def P16 : Property := WellDefined.toProperty WellDefined.compactSpace

end PiBase.Formal
