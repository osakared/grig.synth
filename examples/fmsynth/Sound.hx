import haxe.ds.Vector;
import hxd.snd.NativeChannel;
import music.fmsynth.FMSynth;

class SynthChannel extends hxd.snd.NativeChannel {

	var synth : FMSynth;

	public function new() {
		super(4096);
		synth = new FMSynth(44100.0, 8);
	}

	override function onSample( buf : haxe.io.Float32Array ) {
		var left = new Vector<Float>(buf.length);
        var right = new Vector<Float>(buf.length);
		synth.render(left, right);
		for( i in 0...buf.length )
			buf[i] = left[i];
	}

	public function noteOn()
	{
		synth.noteOn(64, 64);
	}

	public function noteOff()
	{
		synth.noteOff(64);
	}

}


class Sound extends hxd.App {

	var synthChannel:SynthChannel;		
	var playing:Bool;

	override function init() {
		synthChannel = new SynthChannel();
		playing = false;
	}

	override function update(dt:Float) {
		if( hxd.Key.isPressed(hxd.Key.SPACE) ) {
			if (playing) {
				playing = false;
				synthChannel.noteOff();
			}
			else {
				playing = true;
				synthChannel.noteOn();
			}
		}
	}

	static function main() {
		new Sound();
	}

}
