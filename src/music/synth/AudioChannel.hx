package music.synth;

import haxe.ds.Vector;

// Represents one channel of floating point audio
class AudioChannel
{
    public var samples(default, null):Vector<ControlVoltage>;

    public function new(size:Int)
    {
        samples = new Vector<ControlVoltage>(size);
    }

    public function addInto(other:AudioChannel, start:Int = 0, length:Null<Int> = null)
    {
        // Why doesn't haxe have max/min for ints?
        var minLength = samples.length > other.samples.length ? other.samples.length : samples.length;
        if (start < 0) start = 0;
        else if (start > minLength) start = minLength;
        if (length == null || start + length > minLength) {
            length = minLength - start;
        }
        // This is ripe for optimization.. but be careful about not breaking targets
        for (i in start...(start + length)) {
            other.samples[i] = other.samples[i] + samples[i];
        }
    }

    public function copyInto(other:AudioChannel, start:Int = 0, length:Null<Int> = null)
    {
        // Kinda violating DRY here
        var minLength = samples.length > other.samples.length ? other.samples.length : samples.length;
        if (start < 0) start = 0;
        else if (start > minLength) start = minLength;
        if (length == null || start + length > minLength) {
            length = minLength - start;
        }
        Vector.blit(samples, start, other.samples, start, length);
    }

    public function applyGain(gain:Float)
    {
        for (i in 0...samples.length) {
            samples[i] = samples[i] * gain;
        }
    }

    public function copy():AudioChannel
    {
        var newChannel = new AudioChannel(samples.length);
        copyInto(newChannel);
        return newChannel;
    }

    public function clear()
    {
        // Hmm.. is there a way to do a memset on platforms that let me?
        for (i in 0...samples.length) {
            samples[i] = 0.0;
        }
    }
}