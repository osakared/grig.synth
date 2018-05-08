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

    var state:VoiceState;
    var note:UInt;
    var enable:UInt;
    var dead:UInt;

    var baseFreq:Float;
    var envSpeed:Float;
    var pos:Float;
    var speed:Float;

    var lfoStep:Float;
    var lfoPhase:Float;
    var count:UInt;

    // Used in process_frames(). Should be local in cache.
    var phases:Vector<Float>;
    var env:Vector<Float>;
    var readMod:Vector<Float>;
    var targetEnvStep:Vector<Float>;
    var stepRate:Vector<Float>;
    var lfoFreqMod:Vector<Float>;
    var panAmp:Vector<Vector<Float>>;

    // Using when updating envelope (every N sample).
    var falloff:Vector<Float>;
    var endTime:Vector<Float>;
    var targetEnv:Vector<Float>;

    var releaseTime:Vector<Float>;
    var target:Vector<Vector<Float>>;
    var time:Vector<Vector<Float>>;
    var lerp:Vector<Vector<Float>>;

    var amp:Vector<Float>;
    var wheelAmp:Vector<Float>;
    var lfoAmp:Vector<Float>;

    public function new()
    {
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
}
