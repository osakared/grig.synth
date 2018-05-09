# haxe_music_synth

!!! This is alpha currently. Don't depend on the interface not changing!

Individual modules to put together to make synths, with some modules being full-fledged synths in their own right

Works more like a modular analog synth for maximum flexibility but with converters to work with the more rigid world of midi.

Also includes a port of [libfmsynth](https://github.com/Themaister/libfmsynth/blob/master/src/fmsynth.c).

## Short-term TODOs

* Have the basic bones there (inputs, outputs, some very basic Moogian modules)
* Add patch loading to the libfmsynth port
* Made the libfmsynth play nice with other objects (e.g., let it take CV pitch instead of just midi pitch)
* Make an example of sounds being played in an examples directory (use openfl or something if necessary)
