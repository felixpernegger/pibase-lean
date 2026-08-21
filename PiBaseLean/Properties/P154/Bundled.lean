module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P154.Lemmas

@[expose] public section

namespace PiBase.Formal

def P154 : Property := WellDefined.toProperty WellDefined.goSpace

end PiBase.Formal
