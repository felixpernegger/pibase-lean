module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P234.Lemmas

@[expose] public section

namespace PiBase.Formal

def P234 : Property := WellDefined.toProperty WellDefined.hasOpenConnectedComponents

end PiBase.Formal
