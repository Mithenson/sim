class Cell{
    public var x(default, null):Int;
    public var y(default, null):Int;
    public var count(get, never):Int;
    public var base(get, never):Base;

    var entities:Array<Entity>;

    public function new(x:Int, y:Int, base:Base){
        this.x = x;
        this.y = y;

        entities = [base];
    }

    function get_count() return entities.length;

    function get_base() return Std.downcast(getEntity(0), Base);

    public function getEntity(idx:Int) return entities[idx];

    public function getEntities()  return entities;

    public function addEntity(entity:Entity) entities.push(entity);
}