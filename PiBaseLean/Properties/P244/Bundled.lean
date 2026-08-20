module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P244.Lemmas

@[expose] public section

namespace PiBase.Formal

def P244 : Property := WellDefined.toProperty WellDefined.hasCountablePiCharacter

end PiBase.Formal
