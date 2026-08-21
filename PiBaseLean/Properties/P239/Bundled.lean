module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P239.Lemmas

@[expose] public section

namespace PiBase.Formal

def P239 : Property := WellDefined.toProperty WellDefined.semilocallyContractibleSpace

end PiBase.Formal
