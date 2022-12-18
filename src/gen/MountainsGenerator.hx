package gen;

typedef MountainsDefinition = {
    var resolution:Float;
    var octaves:Int;
    var min:Float;
    var max:Float;
}

class MountainsGenerator implements IGenerator {
    var seed:Int;
    var def:MountainsDefinition;

    public function new(){
        seed = Std.random(2147483647);
        def = Data.generatorDefinitions[GeneratorKind.Mountains];
    }

    public function generate(cell:Cell, noise:hxd.Perlin){
        if (cell.base.kind == Kind.Water)
            return GenerationOutput.skip;
        var val = noise.perlin(seed, cell.x / def.resolution, cell.y / def.resolution, def.octaves);
        if (val >= def.min && val <= def.max)
            return new GenerationOutput(new ent.Entity(Data.getTile(Kind.Mountain)), true);
        return GenerationOutput.skip;
    }
}