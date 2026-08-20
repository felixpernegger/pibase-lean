module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P162.Lemmas

@[expose] public section

namespace PiBase.Formal

def P162 : Property := WellDefined.toProperty WellDefined.realcompactSpace

end PiBase.Formal
