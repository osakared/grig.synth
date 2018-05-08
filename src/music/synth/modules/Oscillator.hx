package music.synth.modules;

import music.synth.AudioChannel;
import music.synth.Module;
import music.synth.Output;

class Oscillator implements Module
{
    public var out(default, null):Output;
    public var parent(default, null):Synth;
    private var audioOutput:AudioChannel;
    private var phase:Float;

    public function new(_parent:Synth)
    {
        parent = _parent;
        out = new Output(this);
        audioOutput = new AudioChannel(parent.blockSize);
        phase = 0;
    }

    public function update()
    {
        // assuming 440 and 44100 for now
        for (i in 0...audioOutput.samples.length) {
            audioOutput.samples[i] = Math.sin(phase);
            phase += 440.0 * Math.PI / 44100.0;
        }
        out.updateValues(audioOutput);
    }
}