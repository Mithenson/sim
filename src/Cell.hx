class Cell{
    public var x(default, null):Int;
    public var y(default, null):Int;
    public var count(get, never):Int;
    public var base(get, never):ent.Base;

    var entities:Array<ent.Entity>;

    public function new(x:Int, y:Int){
        this.x = x;
        this.y = y;

        entities = [];
    }

    function get_count() return entities.length;

    function get_base() return Std.downcast(getEntity(0), ent.Base);

    public function getEntity(idx:Int) return entities[idx];

    public function getEntities()  return entities;

    public function addEntity(entity:ent.Entity) entities.push(entity);
}