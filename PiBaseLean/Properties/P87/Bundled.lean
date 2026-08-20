module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P87.Lemmas

@[expose] public section

namespace PiBase.Formal

def P87 : Property := WellDefined.toProperty WellDefined.hasGroupTopology

end PiBase.Formal
