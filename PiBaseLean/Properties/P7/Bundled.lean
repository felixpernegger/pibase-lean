module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P7.Lemmas

@[expose] public section

namespace PiBase.Formal

def P7 : Property := WellDefined.toProperty WellDefined.t4Space

end PiBase.Formal
