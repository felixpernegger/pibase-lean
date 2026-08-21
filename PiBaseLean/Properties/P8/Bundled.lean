module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P8.Lemmas

@[expose] public section

namespace PiBase.Formal

def P8 : Property := WellDefined.toProperty WellDefined.t5Space

end PiBase.Formal
