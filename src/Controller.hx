typedef ControllerDefinition = {
    var cameraSpeed:Float;
    var zoomSpeed:Float;
    var minZoom:Float;
    var maxZoom:Float;
}

class Controller{
    var def:ControllerDefinition;
    var scene:h2d.Scene;
    var moveX:Int;
    var moveY:Int;
    var zoom:Float;
    var resized:Bool;
  
    public function new(scene:h2d.Scene) {
        this.scene = scene;
        def = Data.controllerDefinition;
    }

    public function init(){
        scene.camera.anchorX = 0.5;
        scene.camera.anchorY = 0.5;
        scene.camera.scaleX = 1;
        scene.camera.scaleY = 1;
        resizeCameraToWorld();
        lockCameraToWorld();

        var window = hxd.Window.getInstance();
        window.addEventTarget(onEvent);
        window.addResizeEvent(onResize);
    }
    
    function onEvent(event:hxd.Event){
        switch(event.kind){
            case hxd.Event.EventKind.EWheel:{
                var worldBounds = Session.world.bounds;
                var minScaleX = scene.camera.viewportWidth / worldBounds.width;
                var minScaleY = scene.camera.viewportHeight / worldBounds.height;
                var minScale = hxd.Math.max(minScaleX, minScaleY);
                var minZoom = hxd.Math.max(minScale, def.minZoom);
                zoomCamera(hxd.Math.clamp(zoom - event.wheelDelta * def.zoomSpeed, minZoom, def.maxZoom));
                lockCameraToWorld();
            }
            case _:
        }
    }

    function onResize() resized = true;

    public function update(dt:Float) {
        moveCamera(dt);

        if (resized){
            resizeCameraToWorld();
            resized = false;
        }
    }

    function moveCamera(dt:Float){
        var x = getAxis(hxd.Key.LEFT, hxd.Key.RIGHT);
        if (x != null)
            moveX = x;

        var y = getAxis(hxd.Key.DOWN, hxd.Key.UP);
        if (y != null)
            moveY = -y;

        if (moveX != 0 || moveY != 0){
            var vector = new h2d.col.Point(moveX, moveY);
            vector = vector.normalized().multiply(dt * def.cameraSpeed);
            scene.camera.move(vector.x, vector.y);
            lockCameraToWorld();
        } 
    }

    function getAxis(negativeKey:Int, positiveKey:Int):Null<Int>{
        if (hxd.Key.isPressed(negativeKey)) 
            return -1;
        if (hxd.Key.isPressed(positiveKey))
            return 1;
        if (hxd.Key.isReleased(negativeKey) && !hxd.Key.isDown(positiveKey) || hxd.Key.isReleased(positiveKey) && !hxd.Key.isDown(negativeKey))
            return 0;

        return null;
    }

    function resizeCameraToWorld(){
        var cameraSize = getCameraSize();
        var worldBounds = Session.world.bounds;

        var correction:Null<Float> = null;
        if (cameraSize.width > worldBounds.width)
            correction = scene.camera.viewportWidth / worldBounds.width;

        if (cameraSize.height > worldBounds.height){
            var scaleY = scene.camera.viewportHeight / worldBounds.height;
            if (correction == null || correction < scaleY)
                correction = scaleY;
        }

        if (correction != null)
            zoomCamera(correction);

        lockCameraToWorld();
    }

    function lockCameraToWorld(){
        var c = scene.camera;
        var cSize = getCameraSize();
        var cX = c.x - c.anchorX * cSize.width;
        var cY = c.y - c.anchorY * cSize.height;
        var cBdMin = new h2d.col.Point(cX, cY);
        var cBdMax = new h2d.col.Point(cX + cSize.width, cY + cSize.height);

        var cBds = new h2d.col.Bounds();
        cBds.setMin(cBdMin);
        cBds.setMax(cBdMax);

        var wBds = Session.world.bounds;
        var correction = new h2d.col.Point();

        if (cBds.xMin < wBds.xMin)
            correction.x = wBds.xMin - cBds.xMin;
        else if (cBds.xMax > wBds.xMax)
            correction.x = wBds.xMax - cBds.xMax;

        if (cBds.yMin < wBds.yMin)
            correction.y = wBds.yMin - cBds.yMin;
        else if (cBds.yMax > wBds.yMax)
            correction.y = wBds.yMax - cBds.yMax;

        scene.camera.move(correction.x, correction.y);
    }

    function getCameraSize(){
        var c = scene.camera;
        var width = c.viewportWidth / c.scaleX;
        var height = c.viewportHeight / c.scaleY;
        return {width:width, height:height};
    }

    function zoomCamera(value:Float){
        zoom = MathPlus.fceil(value, 2);
        scene.camera.setScale(zoom, zoom);
    }

    public function dispose(){
        var window = hxd.Window.getInstance();
        window.removeEventTarget(onEvent);
        window.removeResizeEvent(onResize);
    }
}