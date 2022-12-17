class Data {
    public static var appDefinition:Main.AppDefinition;
    public static var tilemap_png:h2d.Tile;
    public static var tilemap:Tilemap;
    public static var worldDefinition:World.WorldDefinition;

    public static function init(){
        appDefinition = haxe.Json.parse(hxd.Res.app.entry.getText());

        tilemap_png = hxd.Res.tilemap_png.toTile();

        var mapDef:Tilemap.TilemapDefinition = haxe.Json.parse(hxd.Res.tilemap_json.entry.getText());
        tilemap = new Tilemap(tilemap_png, mapDef);

        worldDefinition = haxe.Json.parse(hxd.Res.world.entry.getText());
    }
}