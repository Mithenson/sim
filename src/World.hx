typedef WorldDefinition = {
    var layers:Int;
}

class World{
    public var x(default, null):Int;
    public var y(default, null):Int;
    public var width(default, null):Int;
    public var height(default, null):Int;
    public var bounds(get, never):h2d.col.Bounds;

    var def:WorldDefinition;
    var noise:hxd.Perlin;
    var generators:Array<Array<gen.IGenerator>>;
    var cells:Array<Array<Cell>>;
    var layers:h2d.Layers;
    var groups:Array<h2d.TileGroup>;

    public function new(x:Int, y:Int, width:Int, height:Int, generators:Array<Array<gen.IGenerator>>){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.generators = generators;

        def = Data.worldDefinition;
        noise = new hxd.Perlin();
        noise.normalize = true;
        cells = [];
    }

    public function init(parent:h2d.Object){
        generate(parent);
        tick();
    }

    function get_bounds(){
        var bounds = groups[0].getBounds();
        for(i in 1...groups.length)
            bounds.addBounds(groups[i].getBounds());
        return bounds;
    }

    function generate(parent:h2d.Object){
        for(ix in 0...width){
            var column = [];
            for(iy in 0...height){
                var cx = x + ix;
                var cy = y + iy;
                column.push(new Cell(cx, cy));
            }
            cells.push(column);
        }

        for(pass in generators){
            for(x in 0...cells.length){
                for(y in 0...cells[x].length){
                    for(generator in pass){
                        var cell = cells[x][y];
                        var output = generator.generate(cell, noise);
                        if (output.entity != null)
                            cell.addEntity(output.entity);
                        if (output.stop)
                            break;
                    }
                }
            }
        }

        layers = new h2d.Layers(parent);
        groups = [];
        for(i in 0...Data.worldDefinition.layers) {
            var group = new h2d.TileGroup(parent);
            layers.add(group, i);
            groups.push(group);
        }  
    }

    public function tick(){
        for (group in groups)
            group.clear();
        
        for (column in cells){
            for(cell in column){
                var p = new h2d.col.Point(cell.x * Data.tilemap.tileWidth, cell.y * Data.tilemap.tileHeight);
                var entities = cell.getEntities();
                for (i in 0...entities.length)
                    groups[i].add(p.x, p.y, entities[i].visual);
            }
        }
    }

    public function dispose() { }
}