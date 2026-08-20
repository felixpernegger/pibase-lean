module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P10.Lemmas

@[expose] public section

namespace PiBase.Formal

def P10 : Property := WellDefined.toProperty WellDefined.semiregularSpace

end PiBase.Formal
