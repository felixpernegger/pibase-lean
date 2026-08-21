module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P12.Lemmas

@[expose] public section

namespace PiBase.Formal

def P12 : Property := WellDefined.toProperty WellDefined.completelyRegularSpace

end PiBase.Formal
