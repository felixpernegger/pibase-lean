module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P159.Lemmas

@[expose] public section

namespace PiBase.Formal

def P159 : Property := WellDefined.toProperty WellDefined.kMengerSpace

end PiBase.Formal
