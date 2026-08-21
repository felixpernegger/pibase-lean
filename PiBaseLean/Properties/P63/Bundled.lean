module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P63.Lemmas

@[expose] public section

namespace PiBase.Formal

def P63 : Property := WellDefined.toProperty WellDefined.cechCompleteSpace

end PiBase.Formal
