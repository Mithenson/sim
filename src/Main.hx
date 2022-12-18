typedef AppDefinition = {
    var tickRate:Float;
}

class Main extends hxd.App {
    var session:Session;

    static function main(){
        hxd.Res.initEmbed();
        new Main();
    }
    
    override function init(){  
        super.init();
        Data.init();

        var controller = new Controller(s2d);
        var world = new World(
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
            ]);

        session = new Session(s2d, controller, world);
        session.init();
    }

    override function update(dt:Float) session.update(dt);
}