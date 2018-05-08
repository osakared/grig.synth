package music.synth;


class Output
{
    public var outputChannel(default, null):AudioChannel;
    public var parent(default, null):Module;

    public function new(_parent:Module)
    {
        parent = _parent;
        outputChannel = new AudioChannel(parent.parent.blockSize);
    }

    // For owning module to use
    public function updateValues(sourceChannel:AudioChannel)
    {
        sourceChannel.copyInto(outputChannel);
    }

    // For Connection to use
    public function getValues():AudioChannel
    {
        var newValues = outputChannel.copy();
        outputChannel.clear();
        return newValues;
    }
}
