class Cell{
    public var x(default, null):Int;
    public var y(default, null):Int;
    
    var entities:Array<Entity>;

    public function new(x:Int, y:Int, base:Base){
        this.x = x;
        this.y = y;

        entities = [base];
    }

    public function getVisuals()  return [for(entity in entities) entity.visual];
}