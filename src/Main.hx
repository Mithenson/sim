typedef AppDefinition = {
    var tickRate:Float;
}

class Main extends hxd.App {
    var tick:Int;
    var world:World;

    static function main(){
        hxd.Res.initEmbed();
        new Main();
    }
    
    override function init(){  
        super.init();
        Data.init();

        world = new World(
            0, 
            0, 
            250, 
            250, 
            [
                [
                    new gen.LandmassGenerator()
                ],
                [
                    new gen.MountainsGenerator(),
                    new gen.TreesGenerator()
                ]
            ],
            s2d);
        fitWindowToWorld(0.2);
    }

    override function update(dt:Float) {
        var t = hxd.Math.ceil(dt / Data.appDefinition.tickRate);
        if (t == tick)
            return;

        tick = t;
        world.tick();
    }

    function fitWindowToWorld(zoom:Float){
        var window = hxd.Window.getInstance();
        window.resize(hxd.Math.ceil(world.width * zoom * Data.tilemap.tileWidth), hxd.Math.ceil(world.height * zoom * Data.tilemap.tileHeight));
        s2d.camera.scaleX = zoom;
        s2d.camera.scaleY = zoom;
    }
}