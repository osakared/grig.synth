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
        // Very crude..
        return assert(dac.audioInputChannel.samples[3] != 0.0);
    }

    public function testFMSynth()
    {
        var synth = new FMSynth(44100.0, 8);
        var left = new Vector<Float>(1000);
        var right = new Vector<Float>(1000);
        synth.render(left, right);
        trace(left);
        synth.noteOn(64, 64);
        for (i in 0...100) synth.render(left, right);
        synth.render(left, right);
        trace(left);
        return assert(true);
    }

}
