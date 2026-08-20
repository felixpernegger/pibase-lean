module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P198.Lemmas

@[expose] public section

namespace PiBase.Formal

def P198 : Property := WellDefined.toProperty WellDefined.hasCountableExtent

end PiBase.Formal
