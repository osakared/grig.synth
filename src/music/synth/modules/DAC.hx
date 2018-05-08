package music.synth.modules;

import music.synth.AudioChannel;
import music.synth.Input;
import music.synth.Module;

class DAC implements Module
{
    public var audioInput(default, null):Input;
    public var parent(default, null):Synth;
    public var audioInputChannel(default, null):AudioChannel;

    public function new(_parent:Synth)
    {
        parent = _parent;
        audioInput = new Input(this);
        audioInputChannel = new AudioChannel(parent.blockSize);
    }

    public function update()
    {
        var inAudio = audioInput.getValues();
        inAudio.copyInto(audioInputChannel);
    }
}