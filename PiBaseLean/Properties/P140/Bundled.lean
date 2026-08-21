module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P140.Lemmas

@[expose] public section

namespace PiBase.Formal

def P140 : Property := WellDefined.toProperty WellDefined.compactlyCoherentSpace

end PiBase.Formal
