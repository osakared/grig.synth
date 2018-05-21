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

package grig.synth.fmsynth;

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.Input;

class FMSynth
{
    public var voiceParameters:VoiceParameters;
    public var globalParameters:GlobalParameters;

    public var sampleRate:Float;
    public var invSampleRate:Float;

    public var bend:Float;
    public var wheel:Float;
    public var sustained:Bool;

    public var maxVoices:Int;
    public var voices:Vector<FMVoice>;

    public var numOperators(default, null):Int;

    private var patchName:String;
    private var patchAuthor:String;

    private function initVoices()
    {
        for (v in 0...voices.length) {
            for (i in 0...numOperators) {
                voices[v].amp[i] = 1.0;
                voices[v].panAmp[0][i] = 1.0;
                voices[v].panAmp[1][i] = 1.0;
                voices[v].wheelAmp[i] = 1.0;
                voices[v].lfoAmp[i] = 1.0;
                voices[v].lfoFreqMod[i] = 1.0;
            }
        }
        bend = 1.0;
        wheel = 0.0;
    }

    public function new(_sampleRate:Float, _maxVoices:Int = 8, _numOperators:Int = 8)
    {
        sampleRate = _sampleRate;
        maxVoices = _maxVoices;
        numOperators = _numOperators;
        invSampleRate = 1.0 / sampleRate;

        voiceParameters = new VoiceParameters(numOperators);
        globalParameters = new GlobalParameters();

        voices = new Vector<FMVoice>(maxVoices);
        for (i in 0...voices.length) {
            voices[i] = new FMVoice(this, numOperators);
        }

        initVoices();
    }

    public function noteOn(note:UInt, velocity:UInt)
    {
        for (i in 0...maxVoices) {
            if (voices[i].state == VoiceInactive) {
                voices[i].triggerVoice(note, velocity);
                break;
            }
        }
    }

    public function noteOff(note:UInt)
    {
        for (i in 0...maxVoices) {
            if (voices[i].note == note &&
                voices[i].state == VoiceRunning) {
                if (sustained) {
                    voices[i].state = VoiceSustained;
                }
                else {
                    voices[i].releaseVoice();
                }
            }
        }
    }

    public function setSustain(enable:Bool)
    {
        var releasing:Bool = sustained && !enable;
        sustained = enable;

        if (releasing) {
            for (i in 0...maxVoices) {
                if (voices[i].state == VoiceSustained) {
                    voices[i].releaseVoice();
                }
            }
        }
    }

    public function setModWheel(_wheel:UInt)
    {
        var value:Float = _wheel * (1.0 / 127.0);
        wheel = value;

        for (v in 0...maxVoices) {
            var voice = voices[v];

            if (voice.state != VoiceInactive) {
                for (o in 0...numOperators) {
                    voice.wheelAmp[o] = 1.0 - voiceParameters.modSensitivity[o] +
                        voiceParameters.modSensitivity[o] * value;
                }

                voice.updateReadMod();
            }
        }
    }

    public function setPitchBend(value:UInt)
    {
        bend = FMVoice.pitchBendToRatio(value);

        for (v in 0...maxVoices) {
            var voice = voices[v];

            if (voice.state != VoiceInactive) {
                for (o in 0...numOperators) {
                    var freq:Float = bend * voice.baseFreq;
                    voice.stepRate[o] =
                        (freq * voiceParameters.freqMod[o] + voiceParameters.freqOffset[o]) *
                        invSampleRate;
                }
            }
        }
    }

    public function releaseAll()
    {
        for (i in 0...maxVoices) {
            voices[i].releaseVoice();
        }
        sustained = false;
    }

    public function parseMidi(data:Bytes)
    {
        if (data.length == 3 && ((data.get(0) & 0xf0) == 0x90)) {
            if (data.get(2) != 0) {
                noteOn(data.get(1), data.get(2));
                return;
            }
            else {
                noteOff(data.get(1));
                return;
            }
        }
        else if (data.length == 3 && ((data.get(0) & 0xf0) == 0x80)) {
            noteOff(data.get(1));
            return;
        }
        else if (data.length == 3 && ((data.get(0) & 0xf0) == 0xb0 && data.get(1) == 64)) {
            setSustain(data.get(2) >= 64);
            return;
        }
        else if (data.length == 3 && ((data.get(0) & 0xf0) == 0xb0 && data.get(1) == 1)) {
            setModWheel(data.get(2));
            return;
        }
        else if ((data.length == 1 && data.get(0) == 0xff) ||
            (data.length == 3 && ((data.get(0) & 0xf0) == 0xb0) && data.get(1) == 120)) {
            // Reset, All Sound Off
            releaseAll();
            return;
        }
        else if ((data.length == 3 && ((data.get(0) & 0xf0) == 0xb0) && data.get(1) == 123) ||
            (data.length == 1 && data.get(0) == 0xfc)) {
            // All Notes Off, STOP
            releaseAll();
            return;
        }
        else if (data.length == 3 && ((data.get(0) & 0xf0) == 0xe0)) {
            // Pitch bend
            var newBend = data.get(1) | (data.get(2) << 7);
            setPitchBend(newBend);
            return;
        }
        else if (data.length == 1 && data.get(0) == 0xf8) {
            // Timing message, just ignore.
            return;
        }
        else {
            return; // unknown
        }
    }

    // public function setParameter(parameter:UInt, value:Float) // skipping
    // public function setGloablParameter(parameter:UInt, value:Float) // skipping

    public function render(left:Vector<Float>, right:Vector<Float>):Int
    {
        var activeVoices = 0;
        FMVoice.clearBuffer(left);
        FMVoice.clearBuffer(right);

        for (i in 0...maxVoices) {
            if (voices[i].state != VoiceInactive) {
                voices[i].renderVoice(left, right);
                if (voices[i].updateActive()) {
                    activeVoices++;
                }
            }
        }

        return activeVoices;
    }

    public function loadLibFMSynthPreset(input:Input):Bool
    {
        if (numOperators != 8) {
            trace('Wrong number of operators for libfmsynth patches');
            return false;
        }

        if (input.readString(8) != "FMSYNTH1") {
            trace('Not an FMSYNTH1 file');
            return false;
        }

        patchName = input.readString(64);
        patchAuthor = input.readString(64);

        globalParameters.volume = VoiceParameters.unpackFloatForLibFMSynth(input);
        globalParameters.lfoFreq = VoiceParameters.unpackFloatForLibFMSynth(input);

        voiceParameters.loadLibFMSynthParameters(input);

        return true;
    }

}