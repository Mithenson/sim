package gen;

typedef TreesDefinition = {
    var chance:Float;
}

class TreesGenerator implements IGenerator {
    var def:TreesDefinition;

    public function new() def = Data.generatorDefinitions[GeneratorKind.Trees];

    public function generate(cell:Cell, noise:hxd.Perlin){
        if (cell.base.kind == Kind.Water)
            return GenerationOutput.skip;
        var rand = hxd.Math.random();
        if (rand < hxd.Math.clamp(def.chance, 0, 1))
            return new GenerationOutput(new ent.Entity(Data.getTile(Kind.Tree)));
        return GenerationOutput.skip;
    }
}