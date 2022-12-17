typedef WorldDefinition = {
    var resolution:Float;
    var layers:Int;
    var landMass:LandmassDefinition;
}

typedef LandmassDefinition = {
    var seaLevel:Float;
    var octaves:Int;
}

class World{
    public var x(default, null):Int;
    public var y(default, null):Int;
    public var width(default, null):Int;
    public var height(default, null):Int;
    public var seed(default, null):Int;

    var noise:hxd.Perlin;
    var cells:Array<Cell>;
    var layers:h2d.Layers;
    var groups:Array<h2d.TileGroup>;

    public function new(x:Int, y:Int, width:Int, height:Int, parent:h2d.Object){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;

        var now = Date.now();
        seed = Std.random(now.getHours() + now.getMinutes() + now.getSeconds());
        noise = new hxd.Perlin();

        cells = [];
        for(ix in 0...width){
            for(iy in 0...height){
                var cx = x + ix;
                var cy = y + iy;
                var base = generateLandmass(cx, cy, getLandmassDefinition());
                cells.push(new Cell(cx, cy, base));
            }
        }

        layers = new h2d.Layers(parent);
        groups = [];
        for(i in 0...Data.worldDefinition.layers) {
            var group = new h2d.TileGroup(parent);
            layers.add(group, i);
            groups.push(group);
        }  
    }

    function getLandmassDefinition() return Data.worldDefinition.landMass;
    
    function generateLandmass(x:Float, y:Float, def:LandmassDefinition):Base{
        var res = Data.worldDefinition.resolution;
        var surface = noise.perlin(seed, x / res, y / res, def.octaves);

        var kind:TileKind;
        if (surface < def.seaLevel)
            kind = TileKind.Water;
        else 
            kind = TileKind.Ground;

        return new Base(Data.tilemap.tiles[kind]);
    }

    public function tick(){
        for (group in groups)
            group.clear();
        
        for (cell in cells){
            var p = new h2d.col.Point(cell.x * Data.tilemap.tileWidth, cell.y * Data.tilemap.tileHeight);
            var visuals = cell.getVisuals();
            for (i in 0...visuals.length)
                groups[i].add(p.x, p.y, visuals[i]);
        }
    }
}