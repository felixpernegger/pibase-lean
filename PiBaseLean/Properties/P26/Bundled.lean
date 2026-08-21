module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P26.Lemmas

@[expose] public section

namespace PiBase.Formal

def P26 : Property := WellDefined.toProperty WellDefined.separableSpace

end PiBase.Formal
