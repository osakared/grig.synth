package;


import lime.media.openal.ALContext;
import openfl.display.Sprite;
import openfl.events.MouseEvent;


class Main extends Sprite
{
	private var synthChannel:SynthChannel;
	private var lastNote:Int;

	private function buttonDown(event:MouseEvent)
	{
		var xRatio = event.localX / stage.stageWidth;
		var yRatio = event.localY / stage.stageHeight;
		lastNote = Math.floor(xRatio * 127.0);
		var velocity = Math.floor(yRatio * 127.0);
		synthChannel.noteOn(lastNote, velocity);
	}

	private function buttonUp(event:MouseEvent)
	{
		synthChannel.noteOff(lastNote);
	}
	
	public function new()
	{
		super();

		synthChannel = new SynthChannel();
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, buttonDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, buttonUp);
	}
}