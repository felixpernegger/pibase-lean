module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P223.Lemmas

@[expose] public section

namespace PiBase.Formal

def P223 : Property := WellDefined.toProperty WellDefined.locallyContractibleSpace

end PiBase.Formal
