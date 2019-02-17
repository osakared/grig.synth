package grig.synth;

import grig.audio.AudioChannel;

/**
    Component that can send out Audio/CV signals from a module
**/
class Output
{
    /**
        Buffer containing data to be sent to other modules
    **/
    public var outputChannel(default, null):AudioChannel;
    /**
        Owning module
    **/
    public var parent(default, null):Module;
    /**
        Sample rate (can differ from module's, synth's)
    **/
    public var sampleRate(default, null):Int;

    public function new(_parent:Module, _sampleRate:Int)
    {
        parent = _parent;
        sampleRate = _sampleRate;
        outputChannel = new AudioChannel(new AudioChannelData(parent.parent.blockSize));
    }

    // For owning module to use
    public function updateValues(sourceChannel:AudioChannel)
    {
        sourceChannel.copyInto(outputChannel);
    }

    // For Connection to use
    public function getValues():AudioChannel
    {
        return outputChannel.copy();
    }
}
