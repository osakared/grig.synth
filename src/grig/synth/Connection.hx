package grig.synth;

import grig.audio.AudioChannel;
import grig.audio.AudioSample;

class Connection
{
    public var output(default, null):Output;
    public var input(default, null):Input;
    public var multiplier(default, null):AudioSample;
    public var parent(default, null):Synth;
    private var transferChannel:AudioChannel;

    public function new(_output:Output, _input:Input, _parent:Synth)
    {
        output = _output;
        input = _input;
        parent = _parent;
        multiplier = 1.0;
        transferChannel = new AudioChannel(parent.blockSize, parent.sampleRate);
    }

    public function update()
    {
        // TODO support curving the data
        transferChannel.clear();
        var outputChannel = output.getValues();
        outputChannel.copyInto(transferChannel);
        transferChannel.applyGain(multiplier);
        input.pushValues(transferChannel);
    }
}
