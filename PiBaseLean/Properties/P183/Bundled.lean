module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P183.Lemmas

@[expose] public section

namespace PiBase.Formal

def P183 : Property := WellDefined.toProperty WellDefined.hasCountableKNetwork

end PiBase.Formal
