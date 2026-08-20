module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P161.Lemmas

@[expose] public section

namespace PiBase.Formal

def P161 : Property := WellDefined.toProperty WellDefined.markovKMengerSpace

end PiBase.Formal
