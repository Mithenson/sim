class Entity{
    public var visual(get, null):h2d.Tile;

    public function new (source:Tile){
        visual = source.pickRandomVariant();
    }

    function get_visual() return visual;
}