# bgfx-odin
[Odin-lang](https://github.com/odin-lang/Odin) bindings generation for [bgfx](https://github.com/bkaradzic/bgfx).

> All `.sh` and `.cmd` scripts assume that the bgfx repository is in the same parent directory as bgfx-odin.

## Bindings
Generated bindings are in the bgfx directory. The static bgfx libs need to be built separately and copied to the bgfx/lib directory.

## Generating
Generate bindings by running a `generate` script in the gen directory.
Bindings generation requires lua and uses the bgfx IDL scripts.

## Examples
`odin run example/mini_example.odin -file`.
example.odin requires the shaders to be built by running a `make_shaders` script in the example/data directory. Shader building uses the bgfx shader makefile.

## TODO
- [ ] Windows scripts
- [ ] Platforms other than Windows & Linux?
- [ ] Default parameters in bindings
- [ ] Variadic arguments in bindings (printf, vargs...)
- [ ] Example doesn't seem to work with Vulkan?
