class Data {
    public static var appDefinition:Main.AppDefinition;
    public static var tilemap_png:h2d.Tile;
    public static var tilemap:Tilemap;
    public static var controllerDefinition:Controller.ControllerDefinition;
    public static var worldDefinition:World.WorldDefinition;
    public static var generatorDefinitions:Map<gen.GeneratorKind, Dynamic>;

    public static function init(){
        appDefinition = haxe.Json.parse(hxd.Res.app.entry.getText());

        tilemap_png = hxd.Res.tilemap_png.toTile();

        var mapDef:Tilemap.TilemapDefinition = haxe.Json.parse(hxd.Res.tilemap_json.entry.getText());
        tilemap = new Tilemap(tilemap_png, mapDef);

        controllerDefinition = haxe.Json.parse(hxd.Res.controller.entry.getText());
        worldDefinition = haxe.Json.parse(hxd.Res.world.entry.getText());

        generatorDefinitions = new Map();
        for(sub in hxd.Res.load('gen')){
            if (sub.entry.extension != 'json')
                continue;
            var def:gen.IGenerator.GeneratorDefinition = haxe.Json.parse(sub.entry.getText());
            var kind = gen.GeneratorKind.createByName(def.kind);
            generatorDefinitions.set(kind, def.value);
        }
    }

    public static function getTile(kind:Kind) return tilemap.tiles[kind];
}