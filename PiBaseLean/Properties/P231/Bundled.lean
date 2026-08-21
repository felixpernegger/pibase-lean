module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P231.Lemmas

@[expose] public section

namespace PiBase.Formal

def P231 : Property := WellDefined.toProperty WellDefined.weaklyLocallySimplyConnectedSpace

end PiBase.Formal
