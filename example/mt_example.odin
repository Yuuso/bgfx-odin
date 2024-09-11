package example

import iscs "base:intrinsics"
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


// core:c/libc links with the wrong crt...
when ODIN_OS == .Windows {
    when ODIN_DEBUG {
        foreign import libc {
            "system:libcmtd.lib",
            "system:legacy_stdio_definitions.lib",
        }
    } else {
        foreign import libc {
            "system:libcmt.lib",
            "system:legacy_stdio_definitions.lib",
        }
    }
} else {
    foreign import libc "system:c"
}

@(default_calling_convention = "c")
foreign libc {
    vsnprintf :: proc(
        s       : [^]c.char,
        n       : c.size_t,
        format  : cstring,
        arg     : ^c.va_list
    ) -> int ---
}


// Poor man's event queue...
g_keep_rendering      := true
g_window_size_changed := false
g_window_width        : c.int
g_window_height       : c.int


api_thread_proc :: proc(
    self : ^thread.Thread
) {
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
    init.type               = .Count
    init.resolution.reset   = bgfx.RESET_VSYNC | bgfx.RESET_MSAA_X4
    init.allocator          = &allocator_interface
    init.callback           = &callback_interface

    if !bgfx.init(&init) do panic("bgfx.init failed")
    defer bgfx.shutdown()

    bgfx.set_debug(bgfx.DEBUG_TEXT)
    bgfx.set_view_clear(0, bgfx.CLEAR_COLOR | bgfx.CLEAR_DEPTH, 0x202020ff)


    pcv_layout : bgfx.Vertex_Layout
    bgfx.vertex_layout_begin(&pcv_layout)
    bgfx.vertex_layout_add(&pcv_layout, .Position, 3, .Float, false, false)
    bgfx.vertex_layout_add(&pcv_layout, .Color0,   4, .Uint8, true, false)
    bgfx.vertex_layout_end(&pcv_layout)

    Pos_Color_Vertex :: struct { x, y, z : f32, abgr : u32 }
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

    vbh  : bgfx.Vertex_Buffer_Handle         = { bgfx.INVALID_HANDLE }
    ibh  : bgfx.Index_Buffer_Handle          = { bgfx.INVALID_HANDLE }
    dvbh : bgfx.Dynamic_Vertex_Buffer_Handle = { bgfx.INVALID_HANDLE }
    dibh : bgfx.Dynamic_Index_Buffer_Handle  = { bgfx.INVALID_HANDLE }
    tvb  : bgfx.Transient_Vertex_Buffer      ; tvb.handle = { bgfx.INVALID_HANDLE }
    tib  : bgfx.Transient_Index_Buffer       ; tvb.handle = { bgfx.INVALID_HANDLE }

    {
        vertex_memory := bgfx.alloc(
            auto_cast len(cube_vertices) * size_of(cube_vertices[0]))
        runtime.mem_copy_non_overlapping(
            vertex_memory.data,
            &cube_vertices[0],
            auto_cast len(cube_vertices) * size_of(cube_vertices[0]))
        vbh = bgfx.create_vertex_buffer(vertex_memory, &pcv_layout)
        bgfx.set_vertex_buffer_name(vbh, "cube_vbh")

        index_memory := bgfx.alloc(
            auto_cast len(cube_indices) * size_of(cube_indices[0]))
        runtime.mem_copy_non_overlapping(
            index_memory.data,
            &cube_indices[0],
            auto_cast len(cube_indices) * size_of(cube_indices[0]))
        ibh = bgfx.create_index_buffer(index_memory)
        bgfx.set_index_buffer_name(ibh, "cube_ibh")
    } defer {
        bgfx.destroy_vertex_buffer(vbh)
        bgfx.destroy_index_buffer(ibh)
    }

    {
        dvbh = bgfx.create_dynamic_vertex_buffer(
            cast(u32) len(cube_vertices),
            &pcv_layout)
        vertex_memory := bgfx.make_ref(
            &cube_vertices[0],
            cast(u32) len(cube_vertices) * size_of(cube_vertices[0]))
        bgfx.update_dynamic_vertex_buffer(dvbh, 0, vertex_memory)

        index_memory := bgfx.copy(
            &cube_indices[0],
            cast(u32) len(cube_indices) * size_of(cube_indices[0]))
        dibh = bgfx.create_dynamic_index_buffer_mem(index_memory)
    } defer {
        bgfx.destroy_dynamic_vertex_buffer(dvbh)
        bgfx.destroy_dynamic_index_buffer(dibh)
    }

    program_handle := load_program("vs_color", "fs_color")
    defer bgfx.destroy_program(program_handle)


    start_time := time.now()
    last_frame_time := time.now()
    window_width, window_height :=
        init.resolution.width, init.resolution.height
    bgfx.set_view_rect(0, 0, 0,
        cast(c.uint16_t) window_width,
        cast(c.uint16_t) window_height)

    for {
        if !iscs.atomic_load(&g_keep_rendering) do break

        res_changed := iscs.atomic_compare_exchange_strong(
            &g_window_size_changed, true, false)
        if res_changed {
            window_width = cast(c.uint32_t) iscs.atomic_load(&g_window_width)
            window_height = cast(c.uint32_t) iscs.atomic_load(&g_window_height)
            bgfx.reset(window_width, window_height, init.resolution.reset)
            bgfx.set_view_rect(0, 0, 0,
                cast(c.uint16_t) window_width,
                cast(c.uint16_t) window_height)
        }

        last_frame_duration := time.since(last_frame_time)
        last_frame_time = time.now()
        total_time := cast(f32) time.duration_seconds(time.since(start_time))


        view_id : bgfx.View_Id : 0
        bgfx.touch(view_id)

        {
            view := glsl.mat4LookAt(
                eye    = { 0.0, 0.0, -35.0 },
                centre = { 8 * math.cos(total_time), 8 * math.sin(total_time), 0 },
                up     = { 0.0, 1.0, 0.0 })
            proj := glsl.mat4Perspective(
                glsl.radians(f32(60.0)),
                cast(f32) window_width / cast(f32) window_height,
                0.1, 1000.0)
            bgfx.set_view_transform(0, &view, &proj)
        }

        when false {
            bgfx.dbg_text_clear()
            // NOTE!
            // bgfx printf seems to break some buffer memory at least with
            // Vulkan renderer! (probably just random UB...)
            // Maybe a problem with c_vararg in bindings?
            fps := 1 / time.duration_seconds(last_frame_duration)
            bgfx.dbg_text_printf(1, 1, 0x0f, "fps: %i", i32(fps))
        }

        {
            bgfx.alloc_transient_vertex_buffer(
                &tvb,
                auto_cast len(cube_vertices),
                &pcv_layout)
            runtime.mem_copy_non_overlapping(
                tvb.data,
                &cube_vertices[0],
                len(cube_vertices) * size_of(cube_vertices[0]))

            bgfx.alloc_transient_index_buffer(
                &tib,
                auto_cast len(cube_indices))
            runtime.mem_copy_non_overlapping(
                tib.data,
                &cube_indices[0],
                len(cube_indices) * size_of(cube_indices[0]))
        }

        N : f32 : 16
        z_loop: for z in f32(0)..=2 {
            xy_loop: for y in -N..=N do for x in -N..=N {
                mtx : glsl.mat4
                {
                    S := glsl.mat4Scale({1, 1, 1})
                    R := glsl.mat4Rotate(
                        glsl.normalize(glsl.vec3{x, 0.1 + x, y}),
                        math.sin(x * y + total_time) + total_time)
                    T := glsl.mat4Translate({4 * x, 4 * y, 4 * z})
                    mtx = T * R * S
                }
                bgfx.set_transform(&mtx)

                switch z {
                    case 0:
                        assert(bgfx.is_valid(vbh))
                        assert(bgfx.is_valid(ibh))
                        bgfx.set_vertex_buffer(
                            0, vbh, 0, auto_cast len(cube_vertices))
                        bgfx.set_index_buffer(
                            ibh, 0, auto_cast len(cube_indices))

                    case 1:
                        assert(bgfx.is_valid(dvbh))
                        assert(bgfx.is_valid(dibh))
                        bgfx.set_dynamic_vertex_buffer(
                            0, dvbh, 0, auto_cast len(cube_vertices))
                        bgfx.set_dynamic_index_buffer(
                            dibh, 0, auto_cast len(cube_indices))

                    case 2:
                        assert(bgfx.is_valid(tvb.handle))
                        assert(bgfx.is_valid(tib.handle))
                        bgfx.set_transient_vertex_buffer(
                            0, &tvb, 0, auto_cast len(cube_vertices))
                        bgfx.set_transient_index_buffer(
                            &tib, 0, auto_cast len(cube_indices))

                    case: panic("bad draw")
                }

                bgfx.set_state(bgfx.STATE_DEFAULT)
                bgfx.submit(view_id, program_handle)
            }
        }

        bgfx.frame()
        free_all(context.temp_allocator)
    }
}

main :: proc() {
    glfw.SetErrorCallback(proc "c" (code : i32, desc : cstring) {
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
        proc "c" (
            window : glfw.WindowHandle,
            key, scancode, action, mods : i32
        ) {
            if key == glfw.KEY_ESCAPE && action == glfw.PRESS {
                glfw.SetWindowShouldClose(window, glfw.TRUE)
            }
        })

    update_window_size :: proc(window : glfw.WindowHandle) {
        w, h := glfw.GetWindowSize(window)
        if w != g_window_width || h != g_window_height {
            iscs.atomic_store(&g_window_width, w)
            iscs.atomic_store(&g_window_height, h)
            iscs.atomic_store(&g_window_size_changed, true)
        }
    }
    update_window_size(window)


    bgfx.render_frame()

    platform_data : bgfx.Platform_Data
    when ODIN_OS == .Windows {
        platform_data.nwh = glfw.GetWin32Window(window)
    } else when ODIN_OS == .Linux {
        platform_data.ndt = glfw.GetX11Display()
        platform_data.nwh =
            cast(rawptr) cast(c.uintptr_t) glfw.GetX11Window(window)
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
        bgfx.render_frame()
        free_all(context.temp_allocator)
    }

    iscs.atomic_store(&g_keep_rendering, false)
    for bgfx.render_frame() != .No_Context {}
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

        file_path := fmt.tprintf("data/runtime/shaders/%s/%s.bin",
            get_shader_dir(), name)

        data, ok := os.read_entire_file(file_path)
        if !ok do fmt.panicf("Failed to load file: %s", file_path)
        defer delete(data)

        mem := bgfx.alloc(cast(c.uint32_t) len(data) + 1)
        runtime.mem_copy(mem.data, &data[0], len(data))
        (cast([^]c.uint8_t) mem.data)[len(data)] = 0

        handle := bgfx.create_shader(mem)
        assert(bgfx.is_valid(handle))
        bgfx.set_shader_name(handle,
            strings.unsafe_string_to_cstring(name),
            cast(c.int32_t) len(name))
        return handle
    }

    vsh := load_shader(vs_name)
    fsh := load_shader(fs_name)

    DESTROY_SHADERS :: true
    return bgfx.create_program(vsh, fsh, DESTROY_SHADERS)
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

        size_for_size := max(cast(int) align, size_of(int))

        new_size : int
        if size > 0 {
            new_size = cast(int) size + size_for_size
        }

        old_size : int
        old_ptr : rawptr
        if ptr != nil {
            mptr : [^]byte = auto_cast ptr
            old_ptr = mptr[-size_for_size:]
            old_size = (cast(^int) old_ptr)^
        }

        data, err := runtime.mem_resize(
            old_ptr,
            old_size,
            new_size,
            cast(int) align,
            context.allocator,
            loc)
        assert(err == nil)

        if data != nil {
            runtime.mem_copy_non_overlapping(
                &data[0], &new_size, size_of(new_size))
            result = &data[size_for_size]
        }

        when false {
            fmt.printfln("%-7s  %16v % -8v %v:%v",
                ptr == nil ? "alloc" : (size == 0 ? "free" : "realloc"),
                result != nil ? result : ptr,
                size == 0 ? old_size : new_size,
                file, line)
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
        args            : ^c.va_list
    ) {
        context = runtime.default_context()

        buf : [512]c.char
        n := vsnprintf(&buf[0], 512, format, args)
        assert(n > 0 && n < 512)
        trace_msg := string(buf[:n])

        loc : runtime.Source_Code_Location
        loc.line = cast(i32) line
        loc.file_path = string(file_path)

        fmt.printf("%s", trace_msg)
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
    ) -> c.uint32_t { return 0 }

    callback_vtable.cache_read = proc "c" (
        this            : ^bgfx.Callback_Interface,
        id              : c.uint64_t,
        data            : rawptr,
        size            : c.uint32_t
    ) -> c.bool { return false }

    callback_vtable.cache_write = proc "c" (
        this            : ^bgfx.Callback_Interface,
        id              : c.uint64_t,
        data            : rawptr,
        size            : c.uint32_t
    ) {}

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
