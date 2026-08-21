module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P52.Lemmas

@[expose] public section

namespace PiBase.Formal

def P52 : Property := WellDefined.toProperty WellDefined.discreteTopology

end PiBase.Formal
