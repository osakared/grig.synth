import hxd.snd.NativeChannel;
import music.fmsynth.FMSynth;
import haxe.ds.Vector;

class SynthChannel extends hxd.snd.NativeChannel {

	var synth : FMSynth;
	var left : Vector<Float>;
	var right : Vector<Float>;

	public function new() {
		super(4096);
		synth = new FMSynth(44100.0, 8, 8);
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

	public function noteOn(note:Int, velocity:Int = 64)
	{
		synth.noteOn(note, velocity);
	}

	public function noteOff(note:Int)
	{
		synth.noteOff(note);
	}

}