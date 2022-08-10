package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import shadertoy.FlxShaderToyShader;

class PlayState extends FlxState
{
	var shadedSprite:FlxSprite;
	var shadingText:FlxText;

	public static var thingArray:Array<String> = ['Road to Hell', 'fractal pyramid', 'Seascape', 'Pegasus Galaxy'];
	public static var thingIndex:Int = 0;
	public static var shaders:Map<String, Dynamic>;
	public static var links:Map<String, String> = [
		'Road to Hell' => ShaderStorage.roadToHell[1],
		'fractal pyramid' => ShaderStorage.pyramids[1],
		'Seascape' => ShaderStorage.seascape[1],
		'Pegasus Galaxy' => ShaderStorage.galaxy[1]
	];

	override public function create()
	{
		shadedSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		shadedSprite.screenCenter();
		shadingText = new FlxText(10, 10, FlxG.width - 20, "Press LEFT and RIGHT to cycle shaders \nShader: " + thingArray[thingIndex]);
		shadingText.setFormat(24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		shadingText.borderSize = 2;
		add(shadedSprite);
		add(shadingText);
		shaders = [
			'Road to Hell' => new FlxShaderToyShader(ShaderStorage.roadToHell[0], shadedSprite.width, shadedSprite.height),
			'fractal pyramid' => new FlxShaderToyShader(ShaderStorage.pyramids[0], shadedSprite.width, shadedSprite.height),
			'Seascape' => new FlxShaderToyShader(ShaderStorage.seascape[0], shadedSprite.width, shadedSprite.height),
			'Pegasus Galaxy' => new FlxShaderToyShader(ShaderStorage.galaxy[0], shadedSprite.width, shadedSprite.height)
		];
		setShader();
		super.create();
	}

	private function setShader():Void
	{
		shadedSprite.shader = shaders[thingArray[thingIndex]];
		shadingText.text = "FlxShaderToyShader-LR demo \nPress LEFT and RIGHT to cycle shaders \nShader: "
			+ thingArray[thingIndex]
			+ " \n("
			+ links[thingArray[thingIndex]]
			+ " || Press ENTER to go to link)";
	}

	private function changeSelection(r:Bool):Void
	{
		if (r)
		{
			thingIndex++;
			if (thingIndex >= thingArray.length)
			{
				thingIndex = 0;
			}
		}
		else
		{
			thingIndex--;
			if (thingIndex < 0)
			{
				thingIndex = thingArray.length - 1;
			}
		}
		setShader();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
		{
			changeSelection(FlxG.keys.justPressed.RIGHT);
		}
		for (i in shaders.keys())
		{
			if (shadedSprite.shader == shaders[i])
			{
				shaders[i].update(elapsed, FlxG.mouse);
			}
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.openURL(links[thingArray[thingIndex]]);
		}
		super.update(elapsed);
	}
}
