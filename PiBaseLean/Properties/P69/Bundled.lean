module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P69.Lemmas

@[expose] public section

namespace PiBase.Formal

def P69 : Property := WellDefined.toProperty WellDefined.strategicMengerSpace

end PiBase.Formal
