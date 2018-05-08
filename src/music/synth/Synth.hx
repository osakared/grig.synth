package music.synth;

class Synth
{
    // We'll need to iterate over the objects and regenerate the vectors
    // if we want to be able to update this after creation
    public var blockSize(default, null):Int;
    public var modules:Array<Module>;
    public var connections:Array<Connection>;

    public function new(_blockSize:Int)
    {
        blockSize = _blockSize;
        modules = new Array<Module>();
        connections = new Array<Connection>();
    }

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
