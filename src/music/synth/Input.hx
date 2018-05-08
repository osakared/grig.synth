package music.synth;

import haxe.ds.Vector;

class Input
{
    // Value set by knob/base value
    public var value(default, default):ControlVoltage;
    public var inputValues(default, null):Array<AudioChannel>;
    public var parent(default, null):Module;

    public function new(_parent:Module)
    {
        value = 0.0;
        parent = _parent;
        inputValues = new Array<AudioChannel>();
    }

    // For connections to use
    public function pushValues(newValues:AudioChannel)
    {
        inputValues.push(newValues);
    }

    // For owning module to use
    public function getValues():AudioChannel
    {
        var summedValues = new AudioChannel(parent.parent.blockSize);
        for (inputValue in inputValues) {
            inputValue.addInto(summedValues);
        }
        return summedValues;
    }
}