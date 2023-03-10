package gen;

class GenerationOutput{
    public var entity:ent.Entity;
    public var stop:Bool;

    public function new(entity:ent.Entity, ?stop:Bool){
        this.entity = entity;
        if (stop == null)
            stop = false;
        this.stop = stop;
    }

    public static var skip(get, never):GenerationOutput;

    static function get_skip() return new GenerationOutput(null, false);
}