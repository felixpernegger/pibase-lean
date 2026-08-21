module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P224.Lemmas

@[expose] public section

namespace PiBase.Formal

def P224 : Property := WellDefined.toProperty WellDefined.weaklyLocallyContractibleSpace

end PiBase.Formal
