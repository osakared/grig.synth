import grig.audio.AudioChannel;
import grig.synth.fmsynth.FMSynth;

import hxd.snd.NativeChannel;
import haxe.ds.Vector;
import haxe.io.BytesInput;
import haxe.Resource;

class SynthChannel extends hxd.snd.NativeChannel {

	var synth : FMSynth;
	var left : AudioChannel;
	var right : AudioChannel;

	public function new() {
		super(4096);
		synth = new FMSynth(44100.0, 8, 8);
	}

	public function loadPatch(name:String)
	{
		var patchBytes = Resource.getBytes(name);
        synth.loadLibFMSynthPreset(new BytesInput(patchBytes));
	}

	override function onSample( buf : haxe.io.Float32Array ) {
		if (left == null || left.length != buf.length) {
			left = new AudioChannel(buf.length, 44100);
			right = new AudioChannel(buf.length, 44100);
		}
		else {
			left.clear();
			right.clear();
		}
		synth.render(left, right);
		for( i in 0...buf.length ) {
			buf[i] = left.get(i);
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