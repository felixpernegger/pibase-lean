module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P199.Lemmas

@[expose] public section

namespace PiBase.Formal

def P199 : Property := WellDefined.toProperty WellDefined.contractibleSpace

end PiBase.Formal
