package example

import "base:intrinsics"
import "base:runtime"
import "core:c"
import "core:fmt"
import "core:math"
import "core:math/linalg/glsl"
import "core:os"
import "core:strings"
import "core:thread"
import "core:time"
import "vendor:glfw"
import "../bgfx"


// Poor man's event queue...
g_keep_rendering      := true
g_window_size_changed := false
g_window_width        : c.int
g_window_height       : c.int

shader_cache          : map[u64][dynamic]byte

api_thread_proc :: proc(
    self : ^thread.Thread
) {
    shader_cache = make(map[u64][dynamic]byte)
    defer {
        for _, value in shader_cache {
            delete(value)
        }
        delete(shader_cache)
    }

    allocator_vtable : bgfx.Allocator_Vtable
    set_allocator_vtable(&allocator_vtable)
    allocator_interface : bgfx.Allocator_Interface
    allocator_interface.vtable = &allocator_vtable

    callback_vtable : bgfx.Callback_Vtable
    set_callback_vtable(&callback_vtable)
    callback_interface : bgfx.Callback_Interface
    callback_interface.vtable = &callback_vtable

    platform_data := cast(^bgfx.Platform_Data) self.user_args[0]

    init : bgfx.Init
    bgfx.init_ctor(&init)
    init.platform_data      = platform_data^
    init.resolution.width   = cast(c.uint32_t) g_window_width
    init.resolution.height  = cast(c.uint32_t) g_window_height
    init.type               = bgfx.Renderer_Type.Count
    init.resolution.reset   = bgfx.RESET_VSYNC | bgfx.RESET_MSAA_X4
    init.allocator          = &allocator_interface
    init.callback           = &callback_interface

    if !bgfx.init(&init) do panic("bgfx.init failed")
    defer bgfx.shutdown()

    bgfx.set_debug(bgfx.DEBUG_TEXT)
    bgfx.set_view_clear(0, bgfx.CLEAR_COLOR | bgfx.CLEAR_DEPTH, 0x202020ff, 1.0, 0)


    Pos_Color_Vertex :: struct { x, y, z : f32, abgr : u32 }
    pcv_layout : bgfx.Vertex_Layout
    bgfx.vertex_layout_begin(&pcv_layout, .Noop)
    bgfx.vertex_layout_add(&pcv_layout, .Position, 3, .Float, false, false)
    bgfx.vertex_layout_add(&pcv_layout, .Color0, 4, .Uint8, true, false)
    bgfx.vertex_layout_end(&pcv_layout)

    cube_vertices := []Pos_Color_Vertex{
        { -1.0,  1.0,  1.0, 0xff000000 },
        {  1.0,  1.0,  1.0, 0xff0000ff },
        { -1.0, -1.0,  1.0, 0xff00ff00 },
        {  1.0, -1.0,  1.0, 0xff00ffff },
        { -1.0,  1.0, -1.0, 0xffff0000 },
        {  1.0,  1.0, -1.0, 0xffff00ff },
        { -1.0, -1.0, -1.0, 0xffffff00 },
        {  1.0, -1.0, -1.0, 0xffffffff },
    }
    cube_vertices_size := cast(c.uint32_t) (size_of(cube_vertices[0]) * len(cube_vertices))

    cube_indices := []u16{
        0, 1, 2,
        1, 3, 2,
        4, 6, 5,
        5, 6, 7,
        0, 2, 4,
        4, 2, 6,
        1, 5, 3,
        5, 7, 3,
        0, 4, 1,
        4, 5, 1,
        2, 3, 6,
        6, 3, 7,
    }
    cube_indices_size := cast(c.uint32_t) (size_of(cube_indices[0]) * len(cube_indices))

    vbh := bgfx.create_vertex_buffer(
        bgfx.make_ref(raw_data(cube_vertices), cube_vertices_size),
        &pcv_layout,
        bgfx.BUFFER_NONE)
    assert(bgfx.is_valid(vbh))
    bgfx.set_vertex_buffer_name(vbh, "cube_vbh", c.INT32_MAX)
    defer bgfx.destroy_vertex_buffer(vbh)

    ibh := bgfx.create_index_buffer(
        bgfx.make_ref(raw_data(cube_indices), cube_indices_size),
        bgfx.BUFFER_NONE)
    assert(bgfx.is_valid(ibh))
    bgfx.set_index_buffer_name(ibh, "cube_ibh", c.INT32_MAX)
    defer bgfx.destroy_index_buffer(ibh)

    program_handle := load_program("vs_color", "fs_color")
    defer bgfx.destroy_program(program_handle)


    start_time := time.now()
    last_frame_time := time.now()
    window_width, window_height := init.resolution.width, init.resolution.height
    bgfx.set_view_rect(0, 0, 0, cast(c.uint16_t) window_width, cast(c.uint16_t) window_height)

    for intrinsics.atomic_load(&g_keep_rendering) {
        if intrinsics.atomic_compare_exchange_strong(&g_window_size_changed, true, false) {
            window_width = cast(c.uint32_t) intrinsics.atomic_load(&g_window_width)
            window_height = cast(c.uint32_t) intrinsics.atomic_load(&g_window_height)
            bgfx.reset(window_width, window_height, init.resolution.reset, bgfx.Texture_Format.Count)
            bgfx.set_view_rect(0, 0, 0, cast(c.uint16_t) window_width, cast(c.uint16_t) window_height)
        }

        last_frame_duration := time.since(last_frame_time)
        last_frame_time = time.now()
        runtime := cast(f32) time.duration_seconds(time.since(start_time))

        {
            view := glsl.mat4LookAt(
                eye     = { 0.0, 0.0, -35.0 },
                centre  = { 8 * math.cos(runtime), 8 * math.sin(runtime), 0 },
                up      = { 0.0, 1.0, 0.0 })
            proj := glsl.mat4Perspective(
                glsl.radians(f32(60.0)),
                cast(f32) window_width / cast(f32) window_height,
                0.1, 1000.0)
            bgfx.set_view_transform(0, raw_data(&view), raw_data(&proj))
        }

        bgfx.touch(0)

        {
            bgfx.dbg_text_clear(0, false)
            bgfx.dbg_text_printf(1, 1, 0x0f, fmt.ctprintf("fps: %.0f", 1 / time.duration_seconds(last_frame_duration)))
        }

        {
            for y in f32(-10)..=10 do for x in f32(-10)..=10 {
                S := glsl.mat4Scale({1, 1, 1})
                R := glsl.mat4Rotate(glsl.normalize(glsl.vec3{x, 0.1 + x, y}), math.sin(x * y + runtime) + runtime)
                T := glsl.mat4Translate({4 * x, 4 * y, 0.0})
                mtx := T * R * S
                bgfx.set_transform(raw_data(&mtx), 1)
                bgfx.set_vertex_buffer(0, vbh, 0, cube_vertices_size)
                bgfx.set_index_buffer(ibh, 0, cube_indices_size)
                bgfx.set_state(
                    (bgfx.STATE_DEFAULT & ~bgfx.STATE_CULL_MASK) | bgfx.STATE_CULL_CCW,
                    0)
                bgfx.submit(0, program_handle, 0, bgfx.DISCARD_ALL)
            }
        }

        bgfx.frame(false)
    }
}

main :: proc() {
    glfw.SetErrorCallback(proc "c" (code: i32, desc: cstring) {
        context = runtime.default_context()
        fmt.println(desc, code)
    })

    if !glfw.Init() do panic("glfw.Init failed")
    defer glfw.Terminate()

    glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
    window := glfw.CreateWindow(1600, 900, "Example", nil, nil)
    if window == nil do panic("glfw.CreateWindow failed")
    defer glfw.DestroyWindow(window)

    glfw.SetKeyCallback(window,
        proc "c" (window : glfw.WindowHandle, key, scancode, action, mods : i32) {
            if key == glfw.KEY_ESCAPE && action == glfw.PRESS {
                glfw.SetWindowShouldClose(window, glfw.TRUE)
            }
        })

    update_window_size :: proc(window : glfw.WindowHandle) {
        w, h := glfw.GetWindowSize(window)
        if w != g_window_width || h != g_window_height {
            intrinsics.atomic_store(&g_window_width, w)
            intrinsics.atomic_store(&g_window_height, h)
            intrinsics.atomic_store(&g_window_size_changed, true)
        }
    }
    update_window_size(window)


    bgfx.render_frame(-1)

    platform_data : bgfx.Platform_Data
    when ODIN_OS == .Windows {
        platform_data.nwh = glfw.GetWin32Window(window)
    } else when ODIN_OS == .Linux {
        platform_data.ndt = glfw.GetX11Display()
        platform_data.nwh = cast(rawptr) cast(c.uintptr_t) glfw.GetX11Window(window)
    } else {
        #panic("OS not supported!")
    }
    assert(platform_data.nwh != nil)

    api_thread := thread.create(api_thread_proc)
    api_thread.user_args[0] = &platform_data
    thread.start(api_thread)
    defer {
        thread.join(api_thread)
        thread.destroy(api_thread)
    }


    for !glfw.WindowShouldClose(window) {
        glfw.PollEvents()
        update_window_size(window)
        bgfx.render_frame(-1)
    }

    intrinsics.atomic_store(&g_keep_rendering, false)
    for bgfx.render_frame(-1) != bgfx.Render_Frame.NoContext {}
}

load_program :: proc(
    vs_name : string,
    fs_name : string
) -> bgfx.Program_Handle {
    load_shader :: proc(
        name : string
    ) -> bgfx.Shader_Handle {
        get_shader_dir :: proc() -> string {
            #partial switch bgfx.get_renderer_type() {
                case .Direct3D11, .Direct3D12: return "dx11"
                case .Metal: return "metal"
                case .OpenGL: return "glsl"
                case .OpenGLES: return "essl"
                case .Vulkan: return "spirv"
                case: panic("bad renderer")
            }
            return ""
        }

        file_path := fmt.tprintf("data/runtime/shaders/%s/%s.bin", get_shader_dir(), name)

        data, ok := os.read_entire_file(file_path)
        if !ok do fmt.panicf("Failed to load file: %s", file_path)
        defer delete(data)

        mem := bgfx.alloc(cast(c.uint32_t) len(data) + 1)
        runtime.mem_copy(mem.data, raw_data(data), len(data))
        (cast([^]c.uint8_t) mem.data)[len(data)] = 0

        handle := bgfx.create_shader(mem)
        bgfx.set_shader_name(handle, strings.unsafe_string_to_cstring(name), cast(c.int32_t) len(name))
        return handle
    }

    vsh := load_shader(vs_name)
    fsh := load_shader(fs_name)

    return bgfx.create_program(vsh, fsh, true)
}

set_allocator_vtable :: proc(
    allocator_vtable : ^bgfx.Allocator_Vtable
) {
    allocator_vtable.realloc = proc "c" (
        this            : ^bgfx.Allocator_Interface,
        ptr             : rawptr,
        size            : c.size_t,
        align           : c.size_t,
        file            : cstring,
        line            : c.uint32_t
    ) -> (result : rawptr) {
        context = runtime.default_context()
        loc : runtime.Source_Code_Location
        loc.line = cast(i32) line
        loc.file_path = string(file)

        if ptr != nil {
            err := runtime.mem_free(ptr, context.allocator, loc)
            assert(err == .None)
            //fmt.printfln("free   %16v          %v:%v", ptr, file, line)
        }

        if size > 0 {
            bytes, err := runtime.mem_alloc_non_zeroed(
                cast(int) size, cast(int) align,
                context.allocator, loc)
            assert(err == .None)
            result = raw_data(bytes)
            //fmt.printfln("alloc  %16v % -8v %v:%v", raw_data(bytes), size, file, line)
        }

        return
    }
}

set_callback_vtable :: proc(
    callback_vtable : ^bgfx.Callback_Vtable
) {
    callback_vtable.fatal = proc "c" (
        this            : ^bgfx.Callback_Interface,
        file_path       : cstring,
        line            : c.uint16_t,
        code            : bgfx.Fatal,
        str             : cstring
    ) {
        context = runtime.default_context()
        loc : runtime.Source_Code_Location
        loc.line = cast(i32) line
        loc.file_path = string(file_path)
        fmt.panicf("%v: %s", code, str, loc = loc)
    }

    callback_vtable.trace_vargs = proc "c" (
        this            : ^bgfx.Callback_Interface,
        file_path       : cstring,
        line            : c.uint16_t,
        format          : cstring,
        // ...
    ) {
        context = runtime.default_context()
        loc : runtime.Source_Code_Location
        loc.line = cast(i32) line
        loc.file_path = string(file_path)
        //fmt.printf("%v: %s", loc, format)
    }

    callback_vtable.profiler_begin = proc "c" (
        this            : ^bgfx.Callback_Interface,
        name            : cstring,
        abgr            : c.uint32_t,
        file_path       : cstring,
        line            : c.uint16_t
    ) {}

    callback_vtable.profiler_begin_literal = proc "c" (
        this            : ^bgfx.Callback_Interface,
        name            : cstring,
        abgr            : c.uint32_t,
        file_path       : cstring,
        line            : c.uint16_t
    ) {}

    callback_vtable.profiler_end = proc "c" (
        this            : ^bgfx.Callback_Interface
    ) {}

    callback_vtable.cache_read_size = proc "c" (
        this            : ^bgfx.Callback_Interface,
        id              : c.uint64_t
    ) -> (size : c.uint32_t) {
        if cache, ok := shader_cache[id]; ok {
            size = cast(c.uint32_t) len(cache)
        }
        return
    }

    callback_vtable.cache_read = proc "c" (
        this            : ^bgfx.Callback_Interface,
        id              : c.uint64_t,
        data            : rawptr,
        size            : c.uint32_t
    ) -> c.bool {
        cache, ok := shader_cache[id]
        if ok {
            read_size := min(cast(int) size, len(cache))
            runtime.mem_copy(data, raw_data(cache), read_size)
        }
        return ok
    }

    callback_vtable.cache_write = proc "c" (
        this            : ^bgfx.Callback_Interface,
        id              : c.uint64_t,
        data            : rawptr,
        size            : c.uint32_t
    ) {
        context = runtime.default_context()
        if id not_in shader_cache {
            shader_cache[id] = make([dynamic]byte)
        }
        cache := shader_cache[id]
        err := resize(&cache, cast(int) size)
        assert(err == .None)
        runtime.mem_copy(raw_data(cache), data, len(cache))
    }

    callback_vtable.screen_shot = proc "c" (
        this            : ^bgfx.Callback_Interface,
        file_path       : cstring,
        width           : c.uint32_t,
        height          : c.uint32_t,
        pitch           : c.uint32_t,
        data            : rawptr,
        size            : c.uint32_t,
        yflip           : c.bool
    ) {}

    callback_vtable.capture_begin = proc "c" (
        this            : ^bgfx.Callback_Interface,
        width           : c.uint32_t,
        height          : c.uint32_t,
        pitch           : c.uint32_t,
        format          : bgfx.Texture_Format,
        yflip           : c.bool
    ) {}

    callback_vtable.capture_end = proc "c" (
        this            : ^bgfx.Callback_Interface
    ) {}

    callback_vtable.capture_frame = proc "c" (
        this            : ^bgfx.Callback_Interface,
        data            : rawptr,
        size            : c.uint32_t
    ) {}
}
