module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P174.Lemmas

@[expose] public section

namespace PiBase.Formal

def P174 : Property := WellDefined.toProperty WellDefined.wellBasedSpace

end PiBase.Formal
