module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P245.Lemmas

@[expose] public section

namespace PiBase.Formal

def P245 : Property := WellDefined.toProperty WellDefined.hasFinitelyManyOpenSets

end PiBase.Formal
