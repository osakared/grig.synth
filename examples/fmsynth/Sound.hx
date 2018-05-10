import haxe.ds.Vector;
import hxd.snd.NativeChannel;
import music.fmsynth.FMSynth;

class SynthChannel extends hxd.snd.NativeChannel {

	var synth : FMSynth;
	var left : Vector<Float>;
	var right : Vector<Float>;

	public function new() {
		super(4096);
		synth = new FMSynth(44100.0, 8);
	}

	override function onSample( buf : haxe.io.Float32Array ) {
		if (left == null || left.length != buf.length) {
			left = new Vector<Float>(buf.length);
			right = new Vector<Float>(buf.length);
		}
		synth.render(left, right);
		for( i in 0...buf.length ) {
			buf[i] = left[i];
		}
	}

	public function noteOn()
	{
		synth.noteOn(30, 64);
	}

	public function noteOff()
	{
		synth.noteOff(30);
	}

}


class Sound extends hxd.App {

	var synthChannel:SynthChannel;		
	var playing:Bool;

	override function init() {
		synthChannel = new SynthChannel();
	}

	override function update(dt:Float) {
		if( hxd.Key.isPressed(hxd.Key.SPACE) ) {
			trace('space is the place');
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
