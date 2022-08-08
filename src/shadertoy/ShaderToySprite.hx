package shadertoy;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.FlxG;
import openfl.filters.ShaderFilter;

class ShaderToySprite extends FlxSprite {
    public var shader:FlxShaderToyShader = null;
    var flt:FlxFilterFrames = null;
    override public function update(elapsed:Float):Void {
        if (shader != null) shader.update(elapsed, FlxG.mouse);
        if (flt != null) flt.applyToSprite(this, true, false);
        super.update(elapsed);
    }
    public function setShader(shader:Null<FlxShaderToyShader> = null):Void {
        if (shader == null) return;
        this.shader = shader;
        shader.iResolution.values = [width, height];
        flt = FlxFilterFrames.fromFrames(frames, 0, 0, new ShaderFilter([this.shader]));
    }
    public function removeShader():Void {
        shader = flt = null;
    }
}