module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P229.Lemmas

@[expose] public section

namespace PiBase.Formal

def P229 : Property := WellDefined.toProperty WellDefined.semilocallySimplyConnectedSpace

end PiBase.Formal
