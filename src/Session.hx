class Session{
    public static var controller(default, null):Controller;
    public static var world(default, null):World;

    var scene:h2d.Scene;
    var tick:Int;

    public function new(scene:h2d.Scene, c:Controller, w:World){
        this.scene = scene;
        
        controller = c;
        world = w;
    }

    public function init() {
        world.init(scene);
        controller.init();
    }

    public function update(dt:Float){
        controller.update(dt);

        var t = hxd.Math.ceil(dt / Data.appDefinition.tickRate);
        if (t == tick)
            return;

        tick = t;
        world.tick();
    }

    public function dispose(){
        controller = null;
        world = null;
    }
}