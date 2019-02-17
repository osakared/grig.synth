package;

import grig.audio.AudioChannel;
import grig.synth.fmsynth.FMSynth;
import grig.synth.Connection;
import grig.synth.Synth;
import grig.synth.module.DAC;
import grig.synth.module.Oscillator;
import tink.unit.Assert.*;

@:asserts
class SynthTest {

    public function new()
    {
    }

    public function testSin()
    {
        var synth = new Synth(1000, 44100);
        var osc = new Oscillator(synth);
        var dac = new DAC(synth);
        var connection = new Connection(osc.out, dac.audioInput, synth);
        synth.modules.push(osc);
        synth.modules.push(dac);
        synth.connections.push(connection);
        synth.update();
        // The first update isn't enough to fill up the input buffers, another run gets the flow going
        synth.update();
        // Very crude.. use rms or something at least
        return assert(!dac.audioInputChannel.isSilent());
    }

    public function testFMSynth()
    {
        var synth = new FMSynth(44100.0, 2, 8);
        var left = new AudioChannel(new AudioChannelData(44100));
        var right = new AudioChannel(new AudioChannelData(44100));
        synth.noteOn(64, 64);
        synth.render(left, right);
        return assert(!left.isSilent());
    }

}
