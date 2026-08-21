module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P124.Lemmas

@[expose] public section

namespace PiBase.Formal

def P124 : Property := WellDefined.toProperty WellDefined.topologicalNManifold

end PiBase.Formal
