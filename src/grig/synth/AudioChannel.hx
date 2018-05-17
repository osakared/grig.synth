package grig.synth;

import haxe.ds.Vector;

/**
    Represents a floating-point based signal, consisting of audio or control voltage
**/
class AudioChannel
{
    /** Internal representation of the signal **/
    public var samples(default, null):Vector<ControlVoltage>;
    /** Sample rate of the signal contained within **/
    public var sampleRate(default, null):Int;

    /** Creates a new silent buffer **/
    public function new(size:Int, _sampleRate:Int)
    {
        samples = new Vector<ControlVoltage>(size);
        sampleRate = _sampleRate;

        // Already set to 0.0 on static platforms
        #if (!static)
        clear();
        #end
    }

    // TODO should have an otherStart parameter and honor it
    /**
        Adds `length` values from calling `AudioChannel` starting at `sourceStart` into `other`, starting at `sourceStart`.
        Values are summed.
    **/
    public function addInto(other:AudioChannel, sourceStart:Int = 0, length:Null<Int> = null)
    {
        // Why doesn't haxe have max/min for ints?
        var minLength = samples.length > other.samples.length ? other.samples.length : samples.length;
        if (sourceStart < 0) sourceStart = 0;
        else if (sourceStart > minLength) sourceStart = minLength;
        if (length == null || sourceStart + length > minLength) {
            length = minLength - sourceStart;
        }
        // This is ripe for optimization.. but be careful about not breaking targets
        for (i in sourceStart...(sourceStart + length)) {
            other.samples[i] = other.samples[i] + samples[i];
        }
    }

    // TODO should have an otherStart parameter and honor it
    /**
        Copes `length` values from calling `AudioChannel` starting at `sourceStart` into `other`, starting at `sourceStart`.
        Values in other are replaced with values from calling `AudioChannel`.
    **/
    public function copyInto(other:AudioChannel, sourceStart:Int = 0, length:Null<Int> = null)
    {
        // Kinda violating DRY here
        var minLength = samples.length > other.samples.length ? other.samples.length : samples.length;
        if (sourceStart < 0) sourceStart = 0;
        else if (sourceStart > minLength) sourceStart = minLength;
        if (length == null || sourceStart + length > minLength) {
            length = minLength - sourceStart;
        }
        Vector.blit(samples, sourceStart, other.samples, sourceStart, length);
    }

    /** Multiply all values in the signal by gain **/
    public function applyGain(gain:ControlVoltage)
    {
        for (i in 0...samples.length) {
            samples[i] = samples[i] * gain;
        }
    }

    /** Create a new `AudioChannel` with the same parameters and data (deep copy) **/
    public function copy():AudioChannel
    {
        var newChannel = new AudioChannel(samples.length, sampleRate);
        copyInto(newChannel);
        return newChannel;
    }

    /** Set all values in the signal to `value` **/
    public function set(value:Float)
    {
        // Hmm.. is there a way to do a memset on platforms that let me?
        for (i in 0...samples.length) {
            samples[i] = value;
        }
    }

    /** Resets the buffer to silence (all `0.0`) **/
    public function clear()
    {
        set(0.0);
    }
}