module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P172.Lemmas

@[expose] public section

namespace PiBase.Formal

def P172 : Property := WellDefined.toProperty WellDefined.radialSpace

end PiBase.Formal
