module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P238.Lemmas

@[expose] public section

namespace PiBase.Formal

def P238 : Property := WellDefined.toProperty WellDefined.hasRealTVSTopology

end PiBase.Formal
