module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P48.Lemmas

@[expose] public section

namespace PiBase.Formal

def P48 : Property := WellDefined.toProperty WellDefined.totallySeparatedSpace

end PiBase.Formal
