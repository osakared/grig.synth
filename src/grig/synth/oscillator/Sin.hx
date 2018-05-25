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

package grig.synth.oscillator;

/**
 * Sin wave (imperfect approximation) 
 */
class Sin
{
    // TODO use macros to pre-calculate values?
    public static inline var INV_FACTORIAL_3_2PIPOW3 = 41.341702240399755; //((1.0 / 6.0) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI));
    public static inline var INV_FACTORIAL_5_2PIPOW5 = 81.60524927607503; //((1.0 / 120.0) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI));
    public static inline var INV_FACTORIAL_7_2PIPOW7 = 76.70585975306136; //((1.0 / 5040.0) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI) * (2.0 * Math.PI));

    public static function oscillate(phase:Float):Float
    {
        var x:Float = phase < 0.5 ? (phase - 0.25) : (0.75 - phase);

        var x2:Float = x * x;
        var x3:Float = x2 * x;
        x *= 2.0 * Math.PI;
        x -= x3 * INV_FACTORIAL_3_2PIPOW3;

        var x5:Float = x3 * x2;
        x += x5 * INV_FACTORIAL_5_2PIPOW5;

        var x7:Float = x5 * x2;
        x -= x7 * INV_FACTORIAL_7_2PIPOW7;

        return x;
    }
}
