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

class FMVoice
{
    public static inline var FMSYNTH_FRAMES_PER_LFO = 32;
    public static inline var FMSYNTH_OPERATORS = 8;

    private var parent:FMSynth;

    public var state:VoiceState;
    public var note:UInt;
    public var enable:UInt;
    public var dead:UInt;

    public var baseFreq:Float;
    public var envSpeed:Float;
    public var pos:Float;
    public var speed:Float;

    public var lfoStep:Float;
    public var lfoPhase:Float;
    public var count:UInt;

    // Used in process_frames(). Should be local in cache.
    public var phases:Vector<Float>;
    public var env:Vector<Float>;
    public var readMod:Vector<Float>;
    public var targetEnvStep:Vector<Float>;
    public var stepRate:Vector<Float>;
    public var lfoFreqMod:Vector<Float>;
    public var panAmp:Vector<Vector<Float>>;

    // Using when updating envelope (every N sample).
    public var falloff:Vector<Float>;
    public var endTime:Vector<Float>;
    public var targetEnv:Vector<Float>;

    public var releaseTime:Vector<Float>;
    public var target:Vector<Vector<Float>>;
    public var time:Vector<Vector<Float>>;
    public var lerp:Vector<Vector<Float>>;

    public var amp:Vector<Float>;
    public var wheelAmp:Vector<Float>;
    public var lfoAmp:Vector<Float>;

    public function new(_parent:FMSynth)
    {
        parent = _parent;

        state = VoiceInactive;

        phases = new Vector<Float>(FMSYNTH_OPERATORS);
        env = new Vector<Float>(FMSYNTH_OPERATORS);
        readMod = new Vector<Float>(FMSYNTH_OPERATORS);
        targetEnvStep = new Vector<Float>(FMSYNTH_OPERATORS);
        stepRate = new Vector<Float>(FMSYNTH_OPERATORS);
        lfoFreqMod = new Vector<Float>(FMSYNTH_OPERATORS);

        panAmp = new Vector<Vector<Float>>(2);
        panAmp[0] = new Vector<Float>(FMSYNTH_OPERATORS);
        panAmp[1] = new Vector<Float>(FMSYNTH_OPERATORS);

        falloff = new Vector<Float>(FMSYNTH_OPERATORS);
        endTime = new Vector<Float>(FMSYNTH_OPERATORS);
        targetEnv = new Vector<Float>(FMSYNTH_OPERATORS);

        releaseTime = new Vector<Float>(FMSYNTH_OPERATORS);
        target = new Vector<Vector<Float>>(4);
        for (i in 0...4) target[i] = new Vector<Float>(FMSYNTH_OPERATORS);
        time = new Vector<Vector<Float>>(4);
        for (i in 0...4) time[i] = new Vector<Float>(FMSYNTH_OPERATORS);
        lerp = new Vector<Vector<Float>>(3);
        for (i in 0...3) lerp[i] = new Vector<Float>(FMSYNTH_OPERATORS);

        amp = new Vector<Float>(FMSYNTH_OPERATORS);
        wheelAmp = new Vector<Float>(FMSYNTH_OPERATORS);
        lfoAmp = new Vector<Float>(FMSYNTH_OPERATORS);
    }

    public function updateReadMod()
    {
        for (i in 0...FMSYNTH_OPERATORS) {
            readMod[i] = wheelAmp[i] * lfoAmp[i] * amp[i];
        }
    }

    private function updateTargetEnvelope()
    {
        pos += speed * FMSYNTH_FRAMES_PER_LFO;

        if (state == VoiceReleased) {
            for (i in 0...FMSYNTH_OPERATORS) {
                targetEnv[i] *= falloff[i];
                if (pos >= endTime[i]) {
                    dead |= 1 << i;
                }
            }
        }
        else {
            for (i in 0...FMSYNTH_OPERATORS) {
                if (pos >= time[3][i]) {
                    targetEnv[i] = target[3][i];
                    trace(pos);
                    trace(time[3][i]);
                    trace(target[3][i]);
                }
                else if (pos >= time[2][i]) {
                    targetEnv[i] = target[2][i] +
                    (pos - time[2][i]) * lerp[2][i];
                }
                else if (pos >= time[1][i]) {
                    targetEnv[i] = target[1][i] +
                    (pos - time[1][i]) * lerp[1][i];
                }
                else {
                    targetEnv[i] = target[0][i] +
                    (pos - time[0][i]) * lerp[0][i];
                }
            }
        }

        for (i in 0...FMSYNTH_OPERATORS) {
            targetEnvStep[i] =
                (targetEnv[i] - env[i]) * (1.0 / FMSYNTH_FRAMES_PER_LFO);
        }
    }

    private function resetEnvelope()
    {
        pos = 0.0;
        count = 0;
        speed = parent.invSampleRate;
        dead = 0;

        for (i in 0...FMSYNTH_OPERATORS) {
            env[i] = target[0][i] = 0.0;
            time[0][i] = 0.0;

            for (j in 1...4) {
                target[j][i] = parent.voiceParameters.envelopeTarget[j - 1][i];
                time[j][i] = parent.voiceParameters.envelopeDelay[j - 1][i] +
                    time[j - 1][i];
            }

            for (j in 0...3) {
                lerp[j][i] = (target[j + 1][i] - target[j][i]) /
                    (time[j + 1][i] - time[j][i]);
            }

            releaseTime[i] = parent.voiceParameters.envelopeReleaseTime[i];
            falloff[i] = Math.exp(Math.log(0.001) * FMSYNTH_FRAMES_PER_LFO *
                parent.invSampleRate / releaseTime[i]);
        }

        updateTargetEnvelope();
    }

    private function resetVoice(volume:Float, velocity:Float, freq:Float)
    {
        enable = 0;

        for (i in 0...FMSYNTH_OPERATORS) {
            phases[i] = 0.25;

            var modAmp:Float = 1.0 - parent.voiceParameters.velocitySensitivity[i];
            modAmp += parent.voiceParameters.velocitySensitivity[i] * velocity;

            var ratio:Float = freq / parent.voiceParameters.keyboardScalingMidPoint[i];
            var factor:Float = ratio > 1.0 ?
                parent.voiceParameters.keyboardScalingHighFactor[i] :
                parent.voiceParameters.keyboardScalingLowFactor[i];

            modAmp *= Math.pow(ratio, factor);

            var enableOn:Bool = parent.voiceParameters.enable[i] > 0.5;
            enable |= cast(enableOn, Int) << i;

            if (enableOn) {
                amp[i] = modAmp * parent.voiceParameters.amp[i];
            }
            else {
                amp[i] = 0.0;
            }

            wheelAmp[i] = 1.0 - parent.voiceParameters.modSensitivity[i] +
                parent.voiceParameters.modSensitivity[i] * parent.wheel;
            panAmp[0][i] = volume * Math.min(1.0 - parent.voiceParameters.pan[i], 1.0) *
                parent.voiceParameters.carriers[i];
            panAmp[1][i] = volume * Math.min(1.0 + parent.voiceParameters.pan[i], 1.0) *
                parent.voiceParameters.carriers[i];

            lfoAmp[i] = 1.0;
            lfoFreqMod[i] = 1.0;
        }

        state = VoiceRunning;
        resetEnvelope();
    }

    public function triggerVoice(_note:UInt, velocity:UInt)
    {
        note = _note;
        baseFreq = noteToFrequency(note);

        var freq:Float = parent.bend * baseFreq;
        var modVel:Float = velocity * (1.0 / 127.0);

        for (o in 0...FMSYNTH_OPERATORS)
        {
            stepRate[o] =
                (freq * parent.voiceParameters.freqMod[o] + parent.voiceParameters.freqOffset[o]) * parent.invSampleRate;
        }

        resetVoice(parent.globalParameters.volume, modVel, baseFreq);
        updateReadMod();

        lfoPhase = 0.25;
        lfoStep = FMSYNTH_FRAMES_PER_LFO * parent.globalParameters.lfoFreq * parent.invSampleRate;
        count = 0;
    }

    public static function pitchBendToRatio(bend:UInt):Float
    {
        // Two semitones range.
        return Math.pow(2.0, (bend - 8192.0) / (8192.0 * 6.0));
    }

    // We're definitely gonna want to switch to using our more flexible interface
    // so arbitrary pitches/alternative temperaments (from `music`) can be used
    public static function noteToFrequency(note:UInt)
    {
        return 440.0 * Math.pow(2.0, (note - 69.0) / 12.0);
    }

    public function releaseVoice()
    {
        state = VoiceReleased;
        for (i in 0...FMSYNTH_OPERATORS) {
            endTime[i] = pos + releaseTime[i];
        }
    }

    public function setLfoValue(value:Float)
    {
        for (i in 0...FMSYNTH_OPERATORS) {
            lfoAmp[i] = 1.0 + parent.voiceParameters.lfoAmpDepth[i] * value;
            lfoFreqMod[i] = 1.0 + parent.voiceParameters.lfoFreqModDepth[i] * value;
        }

        updateReadMod();
    }

    public function updateActive():Bool
    {
        if (enable & (~dead) != 0) {
            return true;
        }
        else {
            state = VoiceInactive;
            return false;
        }
    }

    public function processFrames(left:Vector<Float>, right:Vector<Float>, start:UInt, frames:UInt)
    {
        var cached = new Vector<Float>(FMSYNTH_OPERATORS);
        var cachedModulator = new Vector<Float>(FMSYNTH_OPERATORS);
        var steps = new Vector<Float>(FMSYNTH_OPERATORS);

        for (f in start...start+frames) {
            for (o in 0...FMSYNTH_OPERATORS) {
                steps[o] = lfoFreqMod[o] * stepRate[o];
            }

            for (o in 0...FMSYNTH_OPERATORS) {
                var value:Float = env[o] * readMod[o] * FMOscillator.oscillator(phases[o]);

                cached[o] = value;
                cachedModulator[o] = value * stepRate[o];
                env[o] += targetEnvStep[o];
            }

            for (o in 0...FMSYNTH_OPERATORS) {
                var scalar:Float = cachedModulator[o];
                var vec = parent.voiceParameters.modToCarriers[o];
                for (j in 0...FMSYNTH_OPERATORS) steps[j] += scalar * vec[j];
            }

            for (o in 0...FMSYNTH_OPERATORS) {
                phases[o] += steps[o];
                phases[o] -= Math.ffloor(phases[o]);
            }

            for (o in 0...FMSYNTH_OPERATORS) {
                left[f]  += cached[o] * panAmp[0][o];
                right[f] += cached[o] * panAmp[1][o];
            }
        }
    }

    public static inline function min(l:Int, r:Int)
    {
        return l > r ? r : l;
    }

    public function renderVoice(left:Vector<Float>, right:Vector<Float>)
    {
        var frames = left.length;
        var start = 0;

        while (frames > 0) {
            var toRender:UInt = min(FMSYNTH_FRAMES_PER_LFO - count, frames);

            processFrames(left, right, start, toRender);

            start += toRender;
            frames -= toRender;
            count += toRender;

            if (count == FMSYNTH_FRAMES_PER_LFO) {
                var lfoValue:Float = FMOscillator.oscillator(lfoPhase);
                lfoPhase += lfoStep;
                lfoPhase -= Math.ffloor(lfoPhase);
                count = 0;

                setLfoValue(lfoValue);
                updateTargetEnvelope();
            }
        }
    }
}
