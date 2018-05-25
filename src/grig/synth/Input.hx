package grig.synth;

import grig.audio.AudioChannel;
import grig.audio.AudioSample;

/**
    Component that can accept arbitrary number of channel inputs, which are mixed into new values
    Used with `Cord` in the synth context, but agnostic so in theory can be used with other
    types of audio graphs.
**/
class Input
{
    /** Value set by knob/base value **/
    public var value(default, default):AudioSample;
    /** Values received by inputs, to be summed **/
    public var inputValues(default, null):Array<AudioChannel>;
    /** Module that this is an input for **/
    public var parent(default, null):Module;
    /** sample rate this input runs at. Can differ from owning module's sample rate. **/
    public var sampleRate(default, null):Int;

    public function new(_parent:Module, _sampleRate:Int)
    {
        value = 0.0;
        parent = _parent;
        inputValues = new Array<AudioChannel>();
        sampleRate = _sampleRate;
    }

    /** Put new values into the input (used by `Connection`s) **/
    public function pushValues(newValues:AudioChannel)
    {
        inputValues.push(newValues);
    }

    /** For owning module to get the values summed from the inputs **/
    public function getValues():AudioChannel
    {
        var summedValues = new AudioChannel(parent.parent.blockSize, sampleRate);
        summedValues.setAll(value);
        for (inputValue in inputValues) {
            inputValue.addInto(summedValues);
        }
        return summedValues;
    }
}