module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P166.Lemmas

@[expose] public section

namespace PiBase.Formal

def P166 : Property := WellDefined.toProperty WellDefined.hasCoarserSeparableMetrizableTopology

end PiBase.Formal
