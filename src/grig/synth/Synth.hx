package grig.synth;

/**
    A modular synthesizer, which can contain any arbitrary configuration of `Module`s and `Connection`s.
**/
class Synth
{
    // We'll need to iterate over the objects and regenerate the vectors
    // if we want to be able to update this after creation
    /** Amount of samples to process in each audio callback **/
    public var blockSize(default, null):Int;
    /** All the modules contained within this synth patch **/
    public var modules:Array<Module>;
    /** All the connections contained within this synth patch **/
    public var connections:Array<Connection>;
    /** The sample rate the synth generates audio or its main output signal at **/
    public var sampleRate(default, null):Int;

    public function new(_blockSize:Int, _sampleRate:Int)
    {
        blockSize = _blockSize;
        sampleRate = _sampleRate;
        modules = new Array<Module>();
        connections = new Array<Connection>();
    }

    /** Process a block of samples in each of the `Module`s and `Connection`s **/
    public function update()
    {
        for (module in modules) {
            module.update();
        }
        for (connection in connections) {
            connection.update();
        }
    }
}
