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

class VoiceParameters
{
    public var amp(default, null):Vector<Float>;
    public var pan(default, null):Vector<Float>;
    public var freqMod(default, null):Vector<Float>;
    public var freqOffset(default, null):Vector<Float>;

    public var envelopeTarget(default, null):Vector<Vector<Float>>;//[3][FMSYNTH_OPERATORS];
    public var envelopeDelay(default, null):Vector<Vector<Float>>;//[3][FMSYNTH_OPERATORS];
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

    public function new()
    {
        amp = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        pan = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        freqMod = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        freqOffset = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);

        envelopeTarget = new Vector<Vector<Float>>(3);
        for (i in 0...3) envelopeTarget[i] = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        envelopeDelay = new Vector<Vector<Float>>(3);
        for (i in 0...3) envelopeDelay[i] = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        envelopeReleaseTime = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);

        keyboardScalingMidPoint = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        keyboardScalingLowFactor = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        keyboardScalingHighFactor = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);

        velocitySensitivity = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        modSensitivity = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);

        lfoAmpDepth = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        lfoFreqModDepth = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);

        enable = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);

        carriers = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);
        modToCarriers = new Vector<Vector<Float>>(FMVoice.FMSYNTH_OPERATORS);
        for (i in 0...FMVoice.FMSYNTH_OPERATORS) modToCarriers[i] = new Vector<Float>(FMVoice.FMSYNTH_OPERATORS);

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
        for (i in 1...FMVoice.FMSYNTH_OPERATORS) {
            carriers[i] = 0.0;
        }

        for (i in 0...FMVoice.FMSYNTH_OPERATORS) {
            setDefault(modToCarriers[i], 0.0);
        }
    }
}
