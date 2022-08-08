package shadertoy;

import flixel.FlxSprite;
import flixel.FlxG;
import openfl.filters.ShaderFilter;

class ShaderToySprite extends FlxSprite {
    public var shadertoy:FlxShaderToyShader = null;
    var flt:FlxFilterFrames = null;
    override public function update(elapsed:Float):Void {
        if (shadertoy != null) {
            shadertoy.update(elapsed, FlxG.mouse);
            pixels.applyFilter(0, 0, width, height, new ShaderFilter(shadertoy));
        }
        super.update(elapsed);
    }
    public function setShader(shader:Null<FlxShaderToyShader> = null):Void {
        if (shader == null) return;
        shadertoy = shader;
        shadertoy.iResolution.value = [width, height];
    }
    public function removeShader():Void {
        shadertoy = null;
    }
}