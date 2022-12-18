class Entity{
    public var visual(default, null):h2d.Tile;
    public var kind(default, null):Kind;

    public function new (source:Tile){
        visual = source.pickRandomVariant();
        kind = source.kind;
    }
}