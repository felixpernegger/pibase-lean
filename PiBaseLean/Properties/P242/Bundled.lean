module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P242.Lemmas

@[expose] public section

namespace PiBase.Formal

def P242 : Property := WellDefined.toProperty WellDefined.weaklyContractibleSpace

end PiBase.Formal
