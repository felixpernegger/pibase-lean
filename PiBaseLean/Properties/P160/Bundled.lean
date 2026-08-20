module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P160.Lemmas

@[expose] public section

namespace PiBase.Formal

def P160 : Property := WellDefined.toProperty WellDefined.strategicallyKMengerSpace

end PiBase.Formal
