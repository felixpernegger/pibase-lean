module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P116.Lemmas

@[expose] public section

namespace PiBase.Formal

def P116 : Property := WellDefined.toProperty WellDefined.polishSpace

end PiBase.Formal
