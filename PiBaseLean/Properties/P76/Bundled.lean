module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P76.Lemmas

@[expose] public section

namespace PiBase.Formal

def P76 : Property := WellDefined.toProperty WellDefined.proximalSpace

end PiBase.Formal
