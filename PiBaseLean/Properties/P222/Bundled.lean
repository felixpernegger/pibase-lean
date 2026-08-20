module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P222.Lemmas

@[expose] public section

namespace PiBase.Formal

def P222 : Property := WellDefined.toProperty WellDefined.hasCofiniteTopology

end PiBase.Formal
