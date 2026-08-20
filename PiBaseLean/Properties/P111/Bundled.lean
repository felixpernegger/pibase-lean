module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P111.Lemmas

@[expose] public section

namespace PiBase.Formal

def P111 : Property := WellDefined.toProperty WellDefined.hemicompactSpace

end PiBase.Formal
