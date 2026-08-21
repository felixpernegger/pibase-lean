module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P168.Lemmas

@[expose] public section

namespace PiBase.Formal

def P168 : Property := WellDefined.toProperty WellDefined.countableSetsDiscrete

end PiBase.Formal
