typedef TilemapDefinition = {
    var tileWidth:Int;
    var tileHeight:Int;
    var padding:Int;
    var tileDefinitions:Array<Tile.TileDefinition>;
}

class Tilemap{
    public var tileWidth(get, null):Int;
    public var tileHeight(get, null):Int;
    public var tiles:Map<Kind, Tile>;

    public function new(src:h2d.Tile, def:TilemapDefinition){
        tileWidth = def.tileWidth;
        tileHeight = def.tileHeight;
        tiles = new Map();
        for(tileDef in def.tileDefinitions){
            var tile = new Tile(src, def, tileDef);
            tiles.set(tile.kind, tile);
        }
    }

    function get_tileWidth() return tileWidth;
    function get_tileHeight() return tileHeight;
}