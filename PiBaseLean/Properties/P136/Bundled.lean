module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P136.Lemmas

@[expose] public section

namespace PiBase.Formal

def P136 : Property := WellDefined.toProperty WellDefined.anticompactSpace

end PiBase.Formal
