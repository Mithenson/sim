typedef TileDefinition = {
    var kind:String;
    var cells:Array<{x:Int, y:Int}>;
}

class Tile{
    public var kind:Kind;

    var variants:Array<h2d.Tile>;

    public function new(src:h2d.Tile, mapDef:Tilemap.TilemapDefinition, def:TileDefinition) {
        kind = Kind.createByName(def.kind);
        variants = [];
        for(cell in def.cells)
            variants.push(src.sub(cell.x * (mapDef.tileWidth + mapDef.padding), cell.y * (mapDef.tileHeight + mapDef.padding), mapDef.tileWidth, mapDef.tileHeight));
    }

    public var variantCount(get, never):Int;

    function get_variantCount() return variants.length;

    public function pickVariant(idx:Int) return variants[idx];

    public function pickRandomVariant(){
        var idx = Std.random(variantCount);
        return pickVariant(idx);
    }
}