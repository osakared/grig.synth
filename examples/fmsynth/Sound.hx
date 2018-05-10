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

	public function noteOn(note:Int)
	{
		synth.noteOn(note, 64);
	}

	public function noteOff(note:Int)
	{
		synth.noteOff(note);
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
			synthChannel.noteOn(18);
		}
		else if( hxd.Key.isReleased(hxd.Key.SPACE) ) {
			synthChannel.noteOff(18);
		}
		if( hxd.Key.isPressed(hxd.Key.A) ) {
			synthChannel.noteOn(36);
		}
		else if( hxd.Key.isReleased(hxd.Key.A) ) {
			synthChannel.noteOff(36);
		}
		if( hxd.Key.isPressed(hxd.Key.S) ) {
			synthChannel.noteOn(38);
		}
		else if( hxd.Key.isReleased(hxd.Key.S) ) {
			synthChannel.noteOff(38);
		}
		if( hxd.Key.isPressed(hxd.Key.D) ) {
			synthChannel.noteOn(39);
		}
		else if( hxd.Key.isReleased(hxd.Key.D) ) {
			synthChannel.noteOff(39);
		}
		if( hxd.Key.isPressed(hxd.Key.F) ) {
			synthChannel.noteOn(41);
		}
		else if( hxd.Key.isReleased(hxd.Key.F) ) {
			synthChannel.noteOff(41);
		}
		if( hxd.Key.isPressed(hxd.Key.G) ) {
			synthChannel.noteOn(43);
		}
		else if( hxd.Key.isReleased(hxd.Key.G) ) {
			synthChannel.noteOff(43);
		}
		if( hxd.Key.isPressed(hxd.Key.H) ) {
			synthChannel.noteOn(44);
		}
		else if( hxd.Key.isReleased(hxd.Key.H) ) {
			synthChannel.noteOff(44);
		}
		if( hxd.Key.isPressed(hxd.Key.J) ) {
			synthChannel.noteOn(46);
		}
		else if( hxd.Key.isReleased(hxd.Key.J) ) {
			synthChannel.noteOff(46);
		}
		if( hxd.Key.isPressed(hxd.Key.K) ) {
			synthChannel.noteOn(48);
		}
		else if( hxd.Key.isReleased(hxd.Key.K) ) {
			synthChannel.noteOff(48);
		}
		if( hxd.Key.isPressed(hxd.Key.L) ) {
			synthChannel.noteOn(50);
		}
		else if( hxd.Key.isReleased(hxd.Key.L) ) {
			synthChannel.noteOff(50);
		}
	}

	static function main() {
		new Sound();
	}

}
