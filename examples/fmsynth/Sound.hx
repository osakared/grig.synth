

class Sound extends hxd.App
{

	var synthChannel:SynthChannel;		
	var playing:Bool;

	override function init() {
		synthChannel = new SynthChannel();
		synthChannel.loadPatch('lead_pad.fmp');
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
