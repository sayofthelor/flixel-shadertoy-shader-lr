package shadertoy;

import flixel.FlxSprite;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import flixel.FlxCamera;

class ShaderToySprite extends FlxSprite {
    public var cam:FlxCamera = null;
    public var shaderToy:FlxShaderToyShader = null;
    override public function new(x:Float = 0, y:Float = 0, ?SimpleGraphic:Null<flixel.util.typeLimit.OneOfThree<flixel.graphics.FlxGraphic, flash.display.BitmapData, String>>) {
        super(x, y, SimpleGraphic);
        cam = new FlxCamera(Std.int(width), Std.int(height));
    }
    override public function update(elapsed:Float):Void {
        if (shaderToy != null && cam != null) {
            shaderToy.update(elapsed, FlxG.mouse);
            if (FlxG.renderBlit)
                pixels.copyPixels(cam.buffer, cam.buffer.rect, new openfl.geom.Point());
            else
                pixels.draw(cam.canvas);
        }
        super.update(elapsed);
    }
    public function updateCam():Void {
        cam.width = Std.int(width);
        cam.height = Std.int(height);
    }
    public function setShader(shader:Null<FlxShaderToyShader>):Void {
        shaderToy = shader;
        cam.setFilters([new ShaderFilter(shaderToy)]);
    }
}