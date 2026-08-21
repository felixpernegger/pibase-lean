module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P77.Lemmas

@[expose] public section

namespace PiBase.Formal

def P77 : Property := WellDefined.toProperty WellDefined.corsonCompactSpace

end PiBase.Formal
