/* Copyright (C) 2014 Hans-Kristian Arntzen <maister@archlinux.us>
 *
 * Permission is hereby granted, free of charge,
 * to any person obtaining a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package music.fmsynth;

import haxe.ds.Vector;
import haxe.io.Input;

class VoiceParameters
{
    public var amp(default, null):Vector<Float>;
    public var pan(default, null):Vector<Float>;
    public var freqMod(default, null):Vector<Float>;
    public var freqOffset(default, null):Vector<Float>;

    public var envelopeTarget(default, null):Vector<Vector<Float>>;
    public var envelopeDelay(default, null):Vector<Vector<Float>>;
    public var envelopeReleaseTime(default, null):Vector<Float>;

    public var keyboardScalingMidPoint(default, null):Vector<Float>;
    public var keyboardScalingLowFactor(default, null):Vector<Float>;
    public var keyboardScalingHighFactor(default, null):Vector<Float>;

    public var velocitySensitivity(default, null):Vector<Float>;
    public var modSensitivity(default, null):Vector<Float>;

    public var lfoAmpDepth(default, null):Vector<Float>;
    public var lfoFreqModDepth(default, null):Vector<Float>;

    public var enable(default, null):Vector<Float>;

    public var carriers(default, null):Vector<Float>;
    public var modToCarriers(default, null):Vector<Vector<Float>>;//[FMSYNTH_OPERATORS][FMSYNTH_OPERATORS];

    private function setDefault(vector:Vector<Float>, value:Float)
    {
        for (i in 0...vector.length) {
            vector[i] = value;
        }
    }

    public function new(numOperators:Int)
    {
        amp = new Vector<Float>(numOperators);
        pan = new Vector<Float>(numOperators);
        freqMod = new Vector<Float>(numOperators);
        freqOffset = new Vector<Float>(numOperators);

        envelopeTarget = new Vector<Vector<Float>>(3);
        for (i in 0...3) envelopeTarget[i] = new Vector<Float>(numOperators);
        envelopeDelay = new Vector<Vector<Float>>(3);
        for (i in 0...3) envelopeDelay[i] = new Vector<Float>(numOperators);
        envelopeReleaseTime = new Vector<Float>(numOperators);

        keyboardScalingMidPoint = new Vector<Float>(numOperators);
        keyboardScalingLowFactor = new Vector<Float>(numOperators);
        keyboardScalingHighFactor = new Vector<Float>(numOperators);

        velocitySensitivity = new Vector<Float>(numOperators);
        modSensitivity = new Vector<Float>(numOperators);

        lfoAmpDepth = new Vector<Float>(numOperators);
        lfoFreqModDepth = new Vector<Float>(numOperators);

        enable = new Vector<Float>(numOperators);

        carriers = new Vector<Float>(numOperators);
        modToCarriers = new Vector<Vector<Float>>(numOperators);
        for (i in 0...numOperators) modToCarriers[i] = new Vector<Float>(numOperators);

        setDefault(amp, 1.0);
        setDefault(pan, 0.0);

        setDefault(freqMod, 1.0);
        setDefault(freqOffset, 0.0);
        
        setDefault(envelopeTarget[0], 1.0);
        setDefault(envelopeTarget[1], 0.5);
        setDefault(envelopeTarget[2], 0.25);
        setDefault(envelopeDelay[0], 0.05);
        setDefault(envelopeDelay[1], 0.05);
        setDefault(envelopeDelay[2], 0.25);
        setDefault(envelopeReleaseTime, 0.50);
        
        setDefault(keyboardScalingMidPoint, 440.0);
        setDefault(keyboardScalingLowFactor, 0.0);
        setDefault(keyboardScalingHighFactor, 0.0);
        
        setDefault(velocitySensitivity, 1.0);
        setDefault(modSensitivity, 0.0);
        
        setDefault(lfoAmpDepth, 0.0);
        setDefault(lfoFreqModDepth, 0.0);
        
        setDefault(enable, 1.0);

        carriers[0] = 1.0;
        for (i in 1...numOperators) {
            carriers[i] = 0.0;
        }

        for (i in 0...numOperators) {
            setDefault(modToCarriers[i], 0.0);
        }
    }

    public static function unpackFloatForLibFMSynth(input:Input):Float
    {
        var ch1 = input.readByte();
        var ch2 = input.readByte();
        var ch3 = input.readByte();
        var ch4 = input.readByte();

        var exp:Int = (ch1 << 8 | ch2);
        if (exp & 0x8000 != 0) {
            exp -= 0x10000;
        }
        var fractional:Float = (ch3 << 8 | ch4) / 0x8000;
        fractional = fractional * Math.pow(2.0, exp);
        return fractional;
    }

    private function setParams(vector:Vector<Float>, input:Input)
    {
        for (i in 0...vector.length) {
            vector[i] = unpackFloatForLibFMSynth(input);
        }
    }

    public function loadLibFMSynthParameters(input:Input)
    {
        setParams(amp, input);
        setParams(pan, input);

        setParams(freqMod, input);
        setParams(freqOffset, input);
        
        setParams(envelopeTarget[0], input);
        setParams(envelopeTarget[1], input);
        setParams(envelopeTarget[2], input);
        setParams(envelopeDelay[0], input);
        setParams(envelopeDelay[1], input);
        setParams(envelopeDelay[2], input);
        setParams(envelopeReleaseTime, input);
        
        setParams(keyboardScalingMidPoint, input);
        setParams(keyboardScalingLowFactor, input);
        setParams(keyboardScalingHighFactor, input);
        
        setParams(velocitySensitivity, input);
        setParams(modSensitivity, input);
        
        setParams(lfoAmpDepth, input);
        setParams(lfoFreqModDepth, input);
        
        setParams(enable, input);

        setParams(carriers, input);
        
        for (i in 0...modToCarriers.length) {
            setParams(modToCarriers[i], input);
        }
    }
}
