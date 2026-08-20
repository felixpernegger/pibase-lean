module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P205.Lemmas

@[expose] public section

namespace PiBase.Formal

def P205 : Property := WellDefined.toProperty WellDefined.cutPointSpace

end PiBase.Formal
