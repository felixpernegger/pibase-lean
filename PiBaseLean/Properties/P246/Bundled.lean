module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P246.Lemmas

@[expose] public section

namespace PiBase.Formal

def P246 : Property := WellDefined.toProperty WellDefined.collectionwiseHausdorffSpace

end PiBase.Formal
