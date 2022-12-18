package gen;

typedef LandmassDefinition = {
    var resolution:Float;
    var octaves:Int;
    var seaLevel:Float;
}

class LandmassGenerator implements IGenerator{
    var seed:Int;
    var def:LandmassDefinition;

    public function new(){
        seed = Std.random(2147483647);
        def = Data.generatorDefinitions[GeneratorKind.Landmass];
    }

    public function generate(cell:Cell, noise:hxd.Perlin){
        var val = noise.perlin(seed, cell.x / def.resolution, cell.y / def.resolution, def.octaves);
        if (val < def.seaLevel)
            return new GenerationOutput(new Base(Data.getTile(Kind.Water)));
        else 
            return new GenerationOutput(new Base(Data.getTile(Kind.Ground)));
    }
}