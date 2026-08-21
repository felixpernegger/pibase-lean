module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P237.Lemmas

@[expose] public section

namespace PiBase.Formal

def P237 : Property := WellDefined.toProperty WellDefined.topologicalNManifoldWithBoundary

end PiBase.Formal
