module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P70.Lemmas

@[expose] public section

namespace PiBase.Formal

def P70 : Property := WellDefined.toProperty WellDefined.markovMengerSpace

end PiBase.Formal
