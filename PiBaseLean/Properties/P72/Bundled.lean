module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P72.Lemmas

@[expose] public section

namespace PiBase.Formal

def P72 : Property := WellDefined.toProperty WellDefined.twoMarkovMengerSpace

end PiBase.Formal
