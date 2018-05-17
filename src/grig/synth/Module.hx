package grig.synth;

interface Module
{
    public var parent(default, null):Synth;

    public function update():Void;
}
