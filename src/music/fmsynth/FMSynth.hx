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

class FMSynth
{
    private var voiceParameters:VoiceParameters;
    private var globalParameters:GlobalParameters;

    private var sampleRate:Float;
    private var invSampleRate:Float;

    private var bend:Float;
    private var wheel:Float;
    private var sustained:Bool;

    private var maxVoices:Int;
    private var voices:Vector<FMVoice>;

    public function new(_sampleRate:Float, _maxVoices:Int)
    {
        sampleRate = _sampleRate;
        maxVoices = _maxVoices;
        invSampleRate = 1.0 / sampleRate;

        voiceParameters = new VoiceParameters();
        globalParameters = new GlobalParameters();
    }
}