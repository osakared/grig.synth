# grig.synth

!!! This is alpha currently. Don't depend on the interface not changing!

Individual modules to put together to make synths, with some modules being full-fledged synths in their own right.

Works more like a modular analog synth for maximum flexibility but with converters to work with the more rigid world of midi.

Also includes a port of [libfmsynth](https://github.com/Themaister/libfmsynth/blob/master/src/fmsynth.c).

## Short-term TODOs

* Add enough modules that it's possible to make a basic sound with the modular synth
* Add a demo for the modular synth making audio
* Made the libfmsynth play nice with other objects (e.g., let it take CV pitch instead of just midi pitch)
* Split out any audio into separate .audio project
* Allow different modules to be different sample rates (e.g., so control aren't doing too much processing)