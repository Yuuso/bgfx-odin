# bgfx-odin

[Odin-lang](https://github.com/odin-lang/Odin) bindings generation for [bgfx](https://github.com/bkaradzic/bgfx) API.

> All `.sh` and `.cmd` scripts assume that the bgfx repository is in the same parent directory as bgfx-odin.


## Bindings

Generated Odin bindings are in the `bgfx` directory.  
The static bgfx libs need to be built separately and copied to the `bgfx/lib` directory.

The bindings match the C API with no extra wrappers.  
Types are converted to roughly match the common Odin style.


## Generating

Regenerate new bindings by running a `generate` script in the `gen` directory.  
Bindings generation requires lua and uses the bgfx IDL scripts.


## Examples

Minimal example:  
`odin run example/mini_example.odin -file`

`mt_example.odin` requires the shaders to be built by running a `make_shaders` script in the example/data directory. Shader building uses the bgfx shader makefile and expects shaderc to be in the bgfx tools directory.
