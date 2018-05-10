package;

import haxe.ds.Vector;
import music.fmsynth.FMSynth;
import music.synth.Connection;
import music.synth.Synth;
import music.synth.modules.DAC;
import music.synth.modules.Oscillator;
import tink.unit.Assert.*;

@:asserts
class SynthTest {

    public function new()
    {
    }

    public function testSin()
    {
        var synth = new Synth(1000);
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
        return assert(dac.audioInputChannel.samples[3] != 0.0 && dac.audioInputChannel.samples[3] != Math.NaN);
    }

    public function testFMSynth()
    {
        var synth = new FMSynth(44100.0, 2, 2);
        var left = new Vector<Float>(10);
        var right = new Vector<Float>(10);
        synth.noteOn(64, 64);
        synth.render(left, right);
        // trace(left);
        return assert(left[3] != 0.0 && left[3] != Math.NaN);
    }

}
