package gen;

typedef GeneratorDefinition = {
    var kind:String;
    var value:Dynamic;
}

interface IGenerator {
    public function generate(cell:Cell, noise:hxd.Perlin):GenerationOutput;
}