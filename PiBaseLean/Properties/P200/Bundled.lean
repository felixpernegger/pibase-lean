module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P200.Lemmas

@[expose] public section

namespace PiBase.Formal

def P200 : Property := WellDefined.toProperty WellDefined.presimplyConnectedSpace

end PiBase.Formal
