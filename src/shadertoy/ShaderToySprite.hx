package shadertoy;

import flixel.FlxSprite;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import flixel.FlxCamera;
import flixel.math.FlxPoint;

class ShaderToySprite extends FlxSprite {
    public var cam:FlxCamera = null;
    public var shaderToy:FlxShaderToyShader = null;
    override public function new(x:Float = 0, y:Float = 0, ?SimpleGraphic:Null<flixel.system.FlxGraphicAsset>) {
        super(x, y, SimpleGraphic);
        cam = new FlxCamera(width, height);
    }
    override public function update(elapsed:Float):Void {
        if (shaderToy != null && cam != null) {
            shaderToy.update(elapsed, FlxG.mouse);
            if (FlxG.render.blit)
                pixels.copyPixels(cam.buffer, cam.rect, new FlxPoint());
            else
                pixels.draw(cam.canvas);
        }
        super.update(elapsed);
    }
    public function updateCam():Void {
        cam.width = width;
        cam.height = height;
    }
    public function setShader(shader:Null<FlxShaderToyShader>):Void {
        shaderToy = shader;
        cam.setFilters([new ShaderFilter(shaderToy)]);
    }
}