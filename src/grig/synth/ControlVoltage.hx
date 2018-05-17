package grig.synth;

abstract ControlVoltage(Float) from Float to Float
{
    public static inline var MIN:Float = -1.0;
    public static inline var MAX:Float = 1.0;

    public inline function new(val:Float = 0.0)
    {
        if (val > MAX) val = Math.min(val, MAX);
        else if (val < MIN) val = MIN;
        this = val;
    }

    @:op(A*B)
    public inline function multiply(val:Float):ControlVoltage
    {
        return new ControlVoltage(this * val);
    }

    @:op(A+B)
    public inline function add(val:ControlVoltage)
    {
        return new ControlVoltage(this + val);
    }
}
