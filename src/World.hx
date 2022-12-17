typedef WorldDefinition = {
    var layers:Int;
    var landMass:LandmassDefinition;
    var decor:DecorDefinition;
}

typedef LandmassDefinition = {
    var resolution:Float;
    var octaves:Int;
    var seaLevel:Float;
}

typedef DecorDefinition = {
    var resolution:Float;
    var octaves:Int;
    var ranges:Array<{min:Float, max:Float, chance:Int, kind:String}>;
}

class World{
    public var x(default, null):Int;
    public var y(default, null):Int;
    public var width(default, null):Int;
    public var height(default, null):Int;

    var noise:hxd.Perlin;
    var cells:Array<Array<Cell>>;
    var layers:h2d.Layers;
    var groups:Array<h2d.TileGroup>;

    public function new(x:Int, y:Int, width:Int, height:Int, parent:h2d.Object){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;

        noise = new hxd.Perlin();
        noise.normalize = true;
        cells = [];

        var landmassSeed = Std.random(2147483647);
        for(ix in 0...width){
            var column = [];
            for(iy in 0...height){
                var cx = x + ix;
                var cy = y + iy;
                var base = generateLandmass(landmassSeed, cx, cy, Data.worldDefinition.landMass);
                column.push(new Cell(cx, cy, base));
            }
            cells.push(column);
        }

        var decorSeed = Std.random(2147483647);
        for (x in 0...cells.length){
            for (y in 0...cells[x].length){
                var decor = generateDecor(decorSeed, x, y, Data.worldDefinition.decor);
                if (decor == null)
                    continue;
                cells[x][y].addEntity(decor);
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
    
    function generateLandmass(seed:Int, x:Int, y:Int, def:LandmassDefinition):Base{
        var val = noise.perlin(seed, x /def.resolution, y / def.resolution, def.octaves);
        var kind:TileKind;
        if (val < def.seaLevel)
            kind = TileKind.Water;
        else 
            kind = TileKind.Ground;

        return new Base(Data.tilemap.tiles[kind]);
    }

    function generateDecor(seed:Int, x:Int, y:Int, def:DecorDefinition){
        if (cells[x][y].base.kind == TileKind.Water)
            return null;

        var val = noise.perlin(seed, x / def.resolution, y / def.resolution, def.octaves);
        trace("a");
        for(range in def.ranges){
            if (val >= range.min && val <= range.max){
                var rand = Std.random(100);
                if (rand > range.chance)
                    continue;
                
                var kind = TileKind.createByName(range.kind);
                return new Entity(Data.tilemap.tiles[kind]);
            }
        }
        return null;
    }

    public function tick(){
        for (group in groups)
            group.clear();
        
        for (column in cells){
            for(cell in column){
                var p = new h2d.col.Point(cell.x * Data.tilemap.tileWidth, cell.y * Data.tilemap.tileHeight);
                var entities = cell.getEntities();
                for (i in 0...entities.length)
                    groups[i].add(p.x, p.y, entities[i].visual);
            }
        }
    }
}