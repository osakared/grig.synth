package grig.synth.module;

import grig.audio.AudioChannel;
import grig.synth.Module;
import grig.synth.Output;

class Oscillator implements Module
{
    public var out(default, null):Output;
    public var parent(default, null):Synth;
    private var audioOutput:AudioChannel;
    private var phase:Float;

    public function new(_parent:Synth)
    {
        parent = _parent;
        out = new Output(this, parent.sampleRate);
        audioOutput = new AudioChannel(new AudioChannelData(parent.blockSize));
        phase = 0;
    }

    public function update()
    {
        // assuming 440 and 44100 for now
        for (i in 0...audioOutput.length) {
            audioOutput[i] = Math.sin(phase);
            phase += 440.0 * Math.PI / 44100.0;
        }
        out.updateValues(audioOutput);
    }
}