class MathPlus{
    public static function fceil(v:Float, d:Int):Float{
        var f = hxd.Math.floor(v);
        var r = v;
        if (f != 0)
            r %= f;
        var fd = 10.0 * d;
        var cDec = hxd.Math.ceil(r * fd);
        return f + (cDec / fd);
    }
}