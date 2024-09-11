package example

import "base:runtime"
import "core:c"
import "core:fmt"
import "vendor:glfw"
import "../bgfx"


main :: proc() {
    glfw.SetErrorCallback(proc "c" (code: i32, desc: cstring) {
        context = runtime.default_context()
        fmt.println(desc, code)
    })

    if !glfw.Init() do panic("glfw.Init failed")
    defer glfw.Terminate()

    glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
    window := glfw.CreateWindow(1280, 720, "Example", nil, nil)
    if window == nil do panic("glfw.CreateWindow failed")
    defer glfw.DestroyWindow(window)

    glfw.SetKeyCallback(window,
        proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
            if key == glfw.KEY_ESCAPE && action == glfw.PRESS {
                glfw.SetWindowShouldClose(window, glfw.TRUE)
            }
        })

    init : bgfx.Init
    bgfx.init_ctor(&init)
    when ODIN_OS == .Windows {
        init.platform_data.nwh = glfw.GetWin32Window(window)
    } else when ODIN_OS == .Linux {
        init.platform_data.ndt = glfw.GetX11Display()
        init.platform_data.nwh = cast(rawptr) cast(c.uintptr_t) glfw.GetX11Window(window)
    } else {
        #panic("OS not supported!")
    }
    width, height := glfw.GetWindowSize(window)
    init.resolution.width = cast(c.uint32_t) width
    init.resolution.height = cast(c.uint32_t) height

    bgfx.render_frame()
    if !bgfx.init(&init) do panic("bgfx.init failed")
    defer bgfx.shutdown()

    bgfx.set_debug(bgfx.DEBUG_STATS)
    bgfx.set_view_clear(0, bgfx.CLEAR_COLOR, 0x303030ff)
    bgfx.set_view_rect_ratio(0, 0, 0, bgfx.Backbuffer_Ratio.Equal)

    for !glfw.WindowShouldClose(window) {
        glfw.PollEvents()
        bgfx.touch(0)
        bgfx.frame()
    }
}
