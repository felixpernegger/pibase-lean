module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P153.Lemmas

@[expose] public section

namespace PiBase.Formal

def P153 : Property := WellDefined.toProperty WellDefined.omegaMengerSpace

end PiBase.Formal
