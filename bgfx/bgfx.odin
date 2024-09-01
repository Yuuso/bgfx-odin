//
// AUTO GENERATED! DO NOT EDIT!
//

package bgfx

import "core:c"


API_VERSION :: 128

when ODIN_OS == .Windows {
    when ODIN_DEBUG {
        @(extra_linker_flags="/NODEFAULTLIB:libcmt")
        foreign import lib {
            "system:gdi32.lib",
            "system:psapi.lib",
            "lib/bgfxDebug.lib",
            "lib/bimgDebug.lib",
            "lib/bxDebug.lib",
        }
    } else {
        foreign import lib {
            "system:gdi32.lib",
            "system:psapi.lib",
            "lib/bgfxRelease.lib",
            "lib/bimgRelease.lib",
            "lib/bxRelease.lib",
        }
    }
} else when ODIN_OS == .Linux {
    when ODIN_DEBUG {
        foreign import lib {
            "system:stdc++",
            "lib/libbgfxDebug.a",
            "lib/libbimgDebug.a",
            "lib/libbxDebug.a",
        }
    } else {
        foreign import lib {
            "system:stdc++",
            "lib/libbgfxRelease.a",
            "lib/libbimgRelease.a",
            "lib/libbxRelease.a",
        }
    }
} else {
    #panic("OS not supported!")
}


View_Id :: distinct c.uint16_t

INVALID_HANDLE : c.uint16_t : 0xffff

Callback_Vtable :: struct {
    fatal : proc "c" (
        this            : ^Callback_Interface,
        file_path       : cstring,
        line            : c.uint16_t,
        code            : Fatal,
        str             : cstring
    ),

    trace_vargs : proc "c" (
        this            : ^Callback_Interface,
        file_path       : cstring,
        line            : c.uint16_t,
        format          : cstring,
        args            : ^c.va_list
    ),

    profiler_begin : proc "c" (
        this            : ^Callback_Interface,
        name            : cstring,
        abgr            : c.uint32_t,
        file_path       : cstring,
        line            : c.uint16_t
    ),

    profiler_begin_literal : proc "c" (
        this            : ^Callback_Interface,
        name            : cstring,
        abgr            : c.uint32_t,
        file_path       : cstring,
        line            : c.uint16_t
    ),

    profiler_end : proc "c" (
        this            : ^Callback_Interface
    ),

    cache_read_size : proc "c" (
        this            : ^Callback_Interface,
        id              : c.uint64_t
    ) -> c.uint32_t,

    cache_read : proc "c" (
        this            : ^Callback_Interface,
        id              : c.uint64_t,
        data            : rawptr,
        size            : c.uint32_t
    ) -> c.bool,

    cache_write : proc "c" (
        this            : ^Callback_Interface,
        id              : c.uint64_t,
        data            : rawptr,
        size            : c.uint32_t
    ),

    screen_shot : proc "c" (
        this            : ^Callback_Interface,
        file_path       : cstring,
        width           : c.uint32_t,
        height          : c.uint32_t,
        pitch           : c.uint32_t,
        data            : rawptr,
        size            : c.uint32_t,
        yflip           : c.bool
    ),

    capture_begin : proc "c" (
        this            : ^Callback_Interface,
        width           : c.uint32_t,
        height          : c.uint32_t,
        pitch           : c.uint32_t,
        format          : Texture_Format,
        yflip           : c.bool
    ),

    capture_end : proc "c" (
        this            : ^Callback_Interface
    ),

    capture_frame : proc "c" (
        this            : ^Callback_Interface,
        data            : rawptr,
        size            : c.uint32_t
    )
}
Callback_Interface :: struct {
    vtable              : ^Callback_Vtable
}

Allocator_Vtable :: struct {
    realloc : proc "c" (
        this            : ^Allocator_Interface,
        ptr             : rawptr,
        size            : c.size_t,
        align           : c.size_t,
        file            : cstring,
        line            : c.uint32_t
    ) -> rawptr
}
Allocator_Interface :: struct {
    vtable              : ^Allocator_Vtable
}

Release_Fn :: #type proc "c" (ptr : rawptr, user_data : rawptr)


// Color RGB/alpha/depth write. When it's not specified write will be disabled.
STATE_WRITE_R                        : c.uint64_t : 0x0000000000000001  // Enable R write.
STATE_WRITE_G                        : c.uint64_t : 0x0000000000000002  // Enable G write.
STATE_WRITE_B                        : c.uint64_t : 0x0000000000000004  // Enable B write.
STATE_WRITE_A                        : c.uint64_t : 0x0000000000000008  // Enable alpha write.
STATE_WRITE_Z                        : c.uint64_t : 0x0000004000000000  // Enable depth write.
STATE_WRITE_RGB                      : c.uint64_t : 0x0000000000000007  // Enable RGB write.
STATE_WRITE_MASK                     : c.uint64_t : 0x000000400000000f  // Write all channels mask.

// Depth test state. When `BGFX_STATE_DEPTH_` is not specified depth test will be disabled.
STATE_DEPTH_TEST_LESS                : c.uint64_t : 0x0000000000000010  // Enable depth test, less.
STATE_DEPTH_TEST_LEQUAL              : c.uint64_t : 0x0000000000000020  // Enable depth test, less or equal.
STATE_DEPTH_TEST_EQUAL               : c.uint64_t : 0x0000000000000030  // Enable depth test, equal.
STATE_DEPTH_TEST_GEQUAL              : c.uint64_t : 0x0000000000000040  // Enable depth test, greater or equal.
STATE_DEPTH_TEST_GREATER             : c.uint64_t : 0x0000000000000050  // Enable depth test, greater.
STATE_DEPTH_TEST_NOTEQUAL            : c.uint64_t : 0x0000000000000060  // Enable depth test, not equal.
STATE_DEPTH_TEST_NEVER               : c.uint64_t : 0x0000000000000070  // Enable depth test, never.
STATE_DEPTH_TEST_ALWAYS              : c.uint64_t : 0x0000000000000080  // Enable depth test, always.
STATE_DEPTH_TEST_SHIFT               : c.uint64_t : 4
STATE_DEPTH_TEST_MASK                : c.uint64_t : 0x00000000000000f0

// Use BGFX_STATE_BLEND_FUNC(_src, _dst) or BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)
// helper macros.
STATE_BLEND_ZERO                     : c.uint64_t : 0x0000000000001000  // 0, 0, 0, 0
STATE_BLEND_ONE                      : c.uint64_t : 0x0000000000002000  // 1, 1, 1, 1
STATE_BLEND_SRC_COLOR                : c.uint64_t : 0x0000000000003000  // Rs, Gs, Bs, As
STATE_BLEND_INV_SRC_COLOR            : c.uint64_t : 0x0000000000004000  // 1-Rs, 1-Gs, 1-Bs, 1-As
STATE_BLEND_SRC_ALPHA                : c.uint64_t : 0x0000000000005000  // As, As, As, As
STATE_BLEND_INV_SRC_ALPHA            : c.uint64_t : 0x0000000000006000  // 1-As, 1-As, 1-As, 1-As
STATE_BLEND_DST_ALPHA                : c.uint64_t : 0x0000000000007000  // Ad, Ad, Ad, Ad
STATE_BLEND_INV_DST_ALPHA            : c.uint64_t : 0x0000000000008000  // 1-Ad, 1-Ad, 1-Ad ,1-Ad
STATE_BLEND_DST_COLOR                : c.uint64_t : 0x0000000000009000  // Rd, Gd, Bd, Ad
STATE_BLEND_INV_DST_COLOR            : c.uint64_t : 0x000000000000a000  // 1-Rd, 1-Gd, 1-Bd, 1-Ad
STATE_BLEND_SRC_ALPHA_SAT            : c.uint64_t : 0x000000000000b000  // f, f, f, 1; f = min(As, 1-Ad)
STATE_BLEND_FACTOR                   : c.uint64_t : 0x000000000000c000  // Blend factor
STATE_BLEND_INV_FACTOR               : c.uint64_t : 0x000000000000d000  // 1-Blend factor
STATE_BLEND_SHIFT                    : c.uint64_t : 12
STATE_BLEND_MASK                     : c.uint64_t : 0x000000000ffff000

// Use BGFX_STATE_BLEND_EQUATION(_equation) or BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)
// helper macros.
STATE_BLEND_EQUATION_ADD             : c.uint64_t : 0x0000000000000000  // Blend add: src + dst.
STATE_BLEND_EQUATION_SUB             : c.uint64_t : 0x0000000010000000  // Blend subtract: src - dst.
STATE_BLEND_EQUATION_REVSUB          : c.uint64_t : 0x0000000020000000  // Blend reverse subtract: dst - src.
STATE_BLEND_EQUATION_MIN             : c.uint64_t : 0x0000000030000000  // Blend min: min(src, dst).
STATE_BLEND_EQUATION_MAX             : c.uint64_t : 0x0000000040000000  // Blend max: max(src, dst).
STATE_BLEND_EQUATION_SHIFT           : c.uint64_t : 28
STATE_BLEND_EQUATION_MASK            : c.uint64_t : 0x00000003f0000000

// Cull state. When `BGFX_STATE_CULL_*` is not specified culling will be disabled.
STATE_CULL_CW                        : c.uint64_t : 0x0000001000000000  // Cull clockwise triangles.
STATE_CULL_CCW                       : c.uint64_t : 0x0000002000000000  // Cull counter-clockwise triangles.
STATE_CULL_SHIFT                     : c.uint64_t : 36
STATE_CULL_MASK                      : c.uint64_t : 0x0000003000000000

// Alpha reference value.
STATE_ALPHA_REF_SHIFT                : c.uint64_t : 40
STATE_ALPHA_REF_MASK                 : c.uint64_t : 0x0000ff0000000000
STATE_ALPHA_REF :: #force_inline proc(v : c.uint64_t) -> c.uint64_t { return (v << STATE_ALPHA_REF_SHIFT) & STATE_ALPHA_REF_MASK }

STATE_PT_TRISTRIP                    : c.uint64_t : 0x0001000000000000  // Tristrip.
STATE_PT_LINES                       : c.uint64_t : 0x0002000000000000  // Lines.
STATE_PT_LINESTRIP                   : c.uint64_t : 0x0003000000000000  // Line strip.
STATE_PT_POINTS                      : c.uint64_t : 0x0004000000000000  // Points.
STATE_PT_SHIFT                       : c.uint64_t : 48
STATE_PT_MASK                        : c.uint64_t : 0x0007000000000000

// Point size value.
STATE_POINT_SIZE_SHIFT               : c.uint64_t : 52
STATE_POINT_SIZE_MASK                : c.uint64_t : 0x00f0000000000000
STATE_POINT_SIZE :: #force_inline proc(v : c.uint64_t) -> c.uint64_t { return (v << STATE_POINT_SIZE_SHIFT) & STATE_POINT_SIZE_MASK }

// Enable MSAA write when writing into MSAA frame buffer.
// This flag is ignored when not writing into MSAA frame buffer.
STATE_MSAA                           : c.uint64_t : 0x0100000000000000  // Enable MSAA rasterization.
STATE_LINEAA                         : c.uint64_t : 0x0200000000000000  // Enable line AA rasterization.
STATE_CONSERVATIVE_RASTER            : c.uint64_t : 0x0400000000000000  // Enable conservative rasterization.
STATE_NONE                           : c.uint64_t : 0x0000000000000000  // No state.
STATE_FRONT_CCW                      : c.uint64_t : 0x0000008000000000  // Front counter-clockwise (default is clockwise).
STATE_BLEND_INDEPENDENT              : c.uint64_t : 0x0000000400000000  // Enable blend independent.
STATE_BLEND_ALPHA_TO_COVERAGE        : c.uint64_t : 0x0000000800000000  // Enable alpha to coverage.

// Default state is write to RGB, alpha, and depth with depth test less enabled, with clockwise
// culling and MSAA (when writing into MSAA frame buffer, otherwise this flag is ignored).
STATE_DEFAULT ::          (
    STATE_WRITE_RGB       |
    STATE_WRITE_A         |
    STATE_WRITE_Z         |
    STATE_DEPTH_TEST_LESS |
    STATE_CULL_CW         |
    STATE_MSAA            )

STATE_MASK                           : c.uint64_t : 0xffffffffffffffff

// Do not use!
STATE_RESERVED_SHIFT                 : c.uint64_t : 61
STATE_RESERVED_MASK                  : c.uint64_t : 0xe000000000000000

// Set stencil ref value.
STENCIL_FUNC_REF_SHIFT               : c.uint32_t : 0
STENCIL_FUNC_REF_MASK                : c.uint32_t : 0x000000ff
STENCIL_FUNC_REF :: #force_inline proc(v : c.uint32_t) -> c.uint32_t { return (v << STENCIL_FUNC_REF_SHIFT) & STENCIL_FUNC_REF_MASK }

// Set stencil rmask value.
STENCIL_FUNC_RMASK_SHIFT             : c.uint32_t : 8
STENCIL_FUNC_RMASK_MASK              : c.uint32_t : 0x0000ff00
STENCIL_FUNC_RMASK :: #force_inline proc(v : c.uint32_t) -> c.uint32_t { return (v << STENCIL_FUNC_RMASK_SHIFT) & STENCIL_FUNC_RMASK_MASK }

STENCIL_NONE                         : c.uint32_t : 0x00000000
STENCIL_MASK                         : c.uint32_t : 0xffffffff
STENCIL_DEFAULT                      : c.uint32_t : 0x00000000

STENCIL_TEST_LESS                    : c.uint32_t : 0x00010000          // Enable stencil test, less.
STENCIL_TEST_LEQUAL                  : c.uint32_t : 0x00020000          // Enable stencil test, less or equal.
STENCIL_TEST_EQUAL                   : c.uint32_t : 0x00030000          // Enable stencil test, equal.
STENCIL_TEST_GEQUAL                  : c.uint32_t : 0x00040000          // Enable stencil test, greater or equal.
STENCIL_TEST_GREATER                 : c.uint32_t : 0x00050000          // Enable stencil test, greater.
STENCIL_TEST_NOTEQUAL                : c.uint32_t : 0x00060000          // Enable stencil test, not equal.
STENCIL_TEST_NEVER                   : c.uint32_t : 0x00070000          // Enable stencil test, never.
STENCIL_TEST_ALWAYS                  : c.uint32_t : 0x00080000          // Enable stencil test, always.
STENCIL_TEST_SHIFT                   : c.uint32_t : 16
STENCIL_TEST_MASK                    : c.uint32_t : 0x000f0000

STENCIL_OP_FAIL_S_ZERO               : c.uint32_t : 0x00000000          // Zero.
STENCIL_OP_FAIL_S_KEEP               : c.uint32_t : 0x00100000          // Keep.
STENCIL_OP_FAIL_S_REPLACE            : c.uint32_t : 0x00200000          // Replace.
STENCIL_OP_FAIL_S_INCR               : c.uint32_t : 0x00300000          // Increment and wrap.
STENCIL_OP_FAIL_S_INCRSAT            : c.uint32_t : 0x00400000          // Increment and clamp.
STENCIL_OP_FAIL_S_DECR               : c.uint32_t : 0x00500000          // Decrement and wrap.
STENCIL_OP_FAIL_S_DECRSAT            : c.uint32_t : 0x00600000          // Decrement and clamp.
STENCIL_OP_FAIL_S_INVERT             : c.uint32_t : 0x00700000          // Invert.
STENCIL_OP_FAIL_S_SHIFT              : c.uint32_t : 20
STENCIL_OP_FAIL_S_MASK               : c.uint32_t : 0x00f00000

STENCIL_OP_FAIL_Z_ZERO               : c.uint32_t : 0x00000000          // Zero.
STENCIL_OP_FAIL_Z_KEEP               : c.uint32_t : 0x01000000          // Keep.
STENCIL_OP_FAIL_Z_REPLACE            : c.uint32_t : 0x02000000          // Replace.
STENCIL_OP_FAIL_Z_INCR               : c.uint32_t : 0x03000000          // Increment and wrap.
STENCIL_OP_FAIL_Z_INCRSAT            : c.uint32_t : 0x04000000          // Increment and clamp.
STENCIL_OP_FAIL_Z_DECR               : c.uint32_t : 0x05000000          // Decrement and wrap.
STENCIL_OP_FAIL_Z_DECRSAT            : c.uint32_t : 0x06000000          // Decrement and clamp.
STENCIL_OP_FAIL_Z_INVERT             : c.uint32_t : 0x07000000          // Invert.
STENCIL_OP_FAIL_Z_SHIFT              : c.uint32_t : 24
STENCIL_OP_FAIL_Z_MASK               : c.uint32_t : 0x0f000000

STENCIL_OP_PASS_Z_ZERO               : c.uint32_t : 0x00000000          // Zero.
STENCIL_OP_PASS_Z_KEEP               : c.uint32_t : 0x10000000          // Keep.
STENCIL_OP_PASS_Z_REPLACE            : c.uint32_t : 0x20000000          // Replace.
STENCIL_OP_PASS_Z_INCR               : c.uint32_t : 0x30000000          // Increment and wrap.
STENCIL_OP_PASS_Z_INCRSAT            : c.uint32_t : 0x40000000          // Increment and clamp.
STENCIL_OP_PASS_Z_DECR               : c.uint32_t : 0x50000000          // Decrement and wrap.
STENCIL_OP_PASS_Z_DECRSAT            : c.uint32_t : 0x60000000          // Decrement and clamp.
STENCIL_OP_PASS_Z_INVERT             : c.uint32_t : 0x70000000          // Invert.
STENCIL_OP_PASS_Z_SHIFT              : c.uint32_t : 28
STENCIL_OP_PASS_Z_MASK               : c.uint32_t : 0xf0000000

CLEAR_NONE                           : c.uint16_t : 0x0000              // No clear flags.
CLEAR_COLOR                          : c.uint16_t : 0x0001              // Clear color.
CLEAR_DEPTH                          : c.uint16_t : 0x0002              // Clear depth.
CLEAR_STENCIL                        : c.uint16_t : 0x0004              // Clear stencil.
CLEAR_DISCARD_COLOR_0                : c.uint16_t : 0x0008              // Discard frame buffer attachment 0.
CLEAR_DISCARD_COLOR_1                : c.uint16_t : 0x0010              // Discard frame buffer attachment 1.
CLEAR_DISCARD_COLOR_2                : c.uint16_t : 0x0020              // Discard frame buffer attachment 2.
CLEAR_DISCARD_COLOR_3                : c.uint16_t : 0x0040              // Discard frame buffer attachment 3.
CLEAR_DISCARD_COLOR_4                : c.uint16_t : 0x0080              // Discard frame buffer attachment 4.
CLEAR_DISCARD_COLOR_5                : c.uint16_t : 0x0100              // Discard frame buffer attachment 5.
CLEAR_DISCARD_COLOR_6                : c.uint16_t : 0x0200              // Discard frame buffer attachment 6.
CLEAR_DISCARD_COLOR_7                : c.uint16_t : 0x0400              // Discard frame buffer attachment 7.
CLEAR_DISCARD_DEPTH                  : c.uint16_t : 0x0800              // Discard frame buffer depth attachment.
CLEAR_DISCARD_STENCIL                : c.uint16_t : 0x1000              // Discard frame buffer stencil attachment.
CLEAR_DISCARD_COLOR_MASK             : c.uint16_t : 0x07f8
CLEAR_DISCARD_MASK                   : c.uint16_t : 0x1ff8

// Rendering state discard. When state is preserved in submit, rendering states can be discarded
// on a finer grain.
DISCARD_NONE                         : c.uint8_t  : 0x00                // Preserve everything.
DISCARD_BINDINGS                     : c.uint8_t  : 0x01                // Discard texture sampler and buffer bindings.
DISCARD_INDEX_BUFFER                 : c.uint8_t  : 0x02                // Discard index buffer.
DISCARD_INSTANCE_DATA                : c.uint8_t  : 0x04                // Discard instance data.
DISCARD_STATE                        : c.uint8_t  : 0x08                // Discard state and uniform bindings.
DISCARD_TRANSFORM                    : c.uint8_t  : 0x10                // Discard transform.
DISCARD_VERTEX_STREAMS               : c.uint8_t  : 0x20                // Discard vertex streams.
DISCARD_ALL                          : c.uint8_t  : 0xff                // Discard all states.

DEBUG_NONE                           : c.uint32_t : 0x00000000          // No debug.
DEBUG_WIREFRAME                      : c.uint32_t : 0x00000001          // Enable wireframe for all primitives.
DEBUG_IFH                            : c.uint32_t : 0x00000002          // Enable infinitely fast hardware test. No draw calls will be submitted to driver. It's useful when profiling to quickly assess bottleneck between CPU and GPU.
DEBUG_STATS                          : c.uint32_t : 0x00000004          // Enable statistics display.
DEBUG_TEXT                           : c.uint32_t : 0x00000008          // Enable debug text display.
DEBUG_PROFILER                       : c.uint32_t : 0x00000010          // Enable profiler. This causes per-view statistics to be collected, available through `bgfx::Stats::ViewStats`. This is unrelated to the profiler functions in `bgfx::CallbackI`.

BUFFER_COMPUTE_FORMAT_8X1            : c.uint16_t : 0x0001              // 1 8-bit value
BUFFER_COMPUTE_FORMAT_8X2            : c.uint16_t : 0x0002              // 2 8-bit values
BUFFER_COMPUTE_FORMAT_8X4            : c.uint16_t : 0x0003              // 4 8-bit values
BUFFER_COMPUTE_FORMAT_16X1           : c.uint16_t : 0x0004              // 1 16-bit value
BUFFER_COMPUTE_FORMAT_16X2           : c.uint16_t : 0x0005              // 2 16-bit values
BUFFER_COMPUTE_FORMAT_16X4           : c.uint16_t : 0x0006              // 4 16-bit values
BUFFER_COMPUTE_FORMAT_32X1           : c.uint16_t : 0x0007              // 1 32-bit value
BUFFER_COMPUTE_FORMAT_32X2           : c.uint16_t : 0x0008              // 2 32-bit values
BUFFER_COMPUTE_FORMAT_32X4           : c.uint16_t : 0x0009              // 4 32-bit values
BUFFER_COMPUTE_FORMAT_SHIFT          : c.uint16_t : 0
BUFFER_COMPUTE_FORMAT_MASK           : c.uint16_t : 0x000f

BUFFER_COMPUTE_TYPE_INT              : c.uint16_t : 0x0010              // Type `int`.
BUFFER_COMPUTE_TYPE_UINT             : c.uint16_t : 0x0020              // Type `uint`.
BUFFER_COMPUTE_TYPE_FLOAT            : c.uint16_t : 0x0030              // Type `float`.
BUFFER_COMPUTE_TYPE_SHIFT            : c.uint16_t : 4
BUFFER_COMPUTE_TYPE_MASK             : c.uint16_t : 0x0030

BUFFER_NONE                          : c.uint16_t : 0x0000
BUFFER_COMPUTE_READ                  : c.uint16_t : 0x0100              // Buffer will be read by shader.
BUFFER_COMPUTE_WRITE                 : c.uint16_t : 0x0200              // Buffer will be used for writing.
BUFFER_DRAW_INDIRECT                 : c.uint16_t : 0x0400              // Buffer will be used for storing draw indirect commands.
BUFFER_ALLOW_RESIZE                  : c.uint16_t : 0x0800              // Allow dynamic index/vertex buffer resize during update.
BUFFER_INDEX32                       : c.uint16_t : 0x1000              // Index buffer contains 32-bit indices.
BUFFER_COMPUTE_READ_WRITE            : c.uint16_t : 0x0300

TEXTURE_NONE                         : c.uint64_t : 0x0000000000000000
TEXTURE_MSAA_SAMPLE                  : c.uint64_t : 0x0000000800000000  // Texture will be used for MSAA sampling.
TEXTURE_RT                           : c.uint64_t : 0x0000001000000000  // Render target no MSAA.
TEXTURE_COMPUTE_WRITE                : c.uint64_t : 0x0000100000000000  // Texture will be used for compute write.
TEXTURE_SRGB                         : c.uint64_t : 0x0000200000000000  // Sample texture as sRGB.
TEXTURE_BLIT_DST                     : c.uint64_t : 0x0000400000000000  // Texture will be used as blit destination.
TEXTURE_READ_BACK                    : c.uint64_t : 0x0000800000000000  // Texture will be used for read back from GPU.

TEXTURE_RT_MSAA_X2                   : c.uint64_t : 0x0000002000000000  // Render target MSAAx2 mode.
TEXTURE_RT_MSAA_X4                   : c.uint64_t : 0x0000003000000000  // Render target MSAAx4 mode.
TEXTURE_RT_MSAA_X8                   : c.uint64_t : 0x0000004000000000  // Render target MSAAx8 mode.
TEXTURE_RT_MSAA_X16                  : c.uint64_t : 0x0000005000000000  // Render target MSAAx16 mode.
TEXTURE_RT_MSAA_SHIFT                : c.uint64_t : 36
TEXTURE_RT_MSAA_MASK                 : c.uint64_t : 0x0000007000000000

TEXTURE_RT_WRITE_ONLY                : c.uint64_t : 0x0000008000000000  // Render target will be used for writing
TEXTURE_RT_SHIFT                     : c.uint64_t : 36
TEXTURE_RT_MASK                      : c.uint64_t : 0x000000f000000000

// Sampler flags.
SAMPLER_U_MIRROR                     : c.uint32_t : 0x00000001          // Wrap U mode: Mirror
SAMPLER_U_CLAMP                      : c.uint32_t : 0x00000002          // Wrap U mode: Clamp
SAMPLER_U_BORDER                     : c.uint32_t : 0x00000003          // Wrap U mode: Border
SAMPLER_U_SHIFT                      : c.uint32_t : 0
SAMPLER_U_MASK                       : c.uint32_t : 0x00000003

SAMPLER_V_MIRROR                     : c.uint32_t : 0x00000004          // Wrap V mode: Mirror
SAMPLER_V_CLAMP                      : c.uint32_t : 0x00000008          // Wrap V mode: Clamp
SAMPLER_V_BORDER                     : c.uint32_t : 0x0000000c          // Wrap V mode: Border
SAMPLER_V_SHIFT                      : c.uint32_t : 2
SAMPLER_V_MASK                       : c.uint32_t : 0x0000000c

SAMPLER_W_MIRROR                     : c.uint32_t : 0x00000010          // Wrap W mode: Mirror
SAMPLER_W_CLAMP                      : c.uint32_t : 0x00000020          // Wrap W mode: Clamp
SAMPLER_W_BORDER                     : c.uint32_t : 0x00000030          // Wrap W mode: Border
SAMPLER_W_SHIFT                      : c.uint32_t : 4
SAMPLER_W_MASK                       : c.uint32_t : 0x00000030

SAMPLER_MIN_POINT                    : c.uint32_t : 0x00000040          // Min sampling mode: Point
SAMPLER_MIN_ANISOTROPIC              : c.uint32_t : 0x00000080          // Min sampling mode: Anisotropic
SAMPLER_MIN_SHIFT                    : c.uint32_t : 6
SAMPLER_MIN_MASK                     : c.uint32_t : 0x000000c0

SAMPLER_MAG_POINT                    : c.uint32_t : 0x00000100          // Mag sampling mode: Point
SAMPLER_MAG_ANISOTROPIC              : c.uint32_t : 0x00000200          // Mag sampling mode: Anisotropic
SAMPLER_MAG_SHIFT                    : c.uint32_t : 8
SAMPLER_MAG_MASK                     : c.uint32_t : 0x00000300

SAMPLER_MIP_POINT                    : c.uint32_t : 0x00000400          // Mip sampling mode: Point
SAMPLER_MIP_SHIFT                    : c.uint32_t : 10
SAMPLER_MIP_MASK                     : c.uint32_t : 0x00000400

SAMPLER_COMPARE_LESS                 : c.uint32_t : 0x00010000          // Compare when sampling depth texture: less.
SAMPLER_COMPARE_LEQUAL               : c.uint32_t : 0x00020000          // Compare when sampling depth texture: less or equal.
SAMPLER_COMPARE_EQUAL                : c.uint32_t : 0x00030000          // Compare when sampling depth texture: equal.
SAMPLER_COMPARE_GEQUAL               : c.uint32_t : 0x00040000          // Compare when sampling depth texture: greater or equal.
SAMPLER_COMPARE_GREATER              : c.uint32_t : 0x00050000          // Compare when sampling depth texture: greater.
SAMPLER_COMPARE_NOTEQUAL             : c.uint32_t : 0x00060000          // Compare when sampling depth texture: not equal.
SAMPLER_COMPARE_NEVER                : c.uint32_t : 0x00070000          // Compare when sampling depth texture: never.
SAMPLER_COMPARE_ALWAYS               : c.uint32_t : 0x00080000          // Compare when sampling depth texture: always.
SAMPLER_COMPARE_SHIFT                : c.uint32_t : 16
SAMPLER_COMPARE_MASK                 : c.uint32_t : 0x000f0000

SAMPLER_BORDER_COLOR_SHIFT           : c.uint32_t : 24
SAMPLER_BORDER_COLOR_MASK            : c.uint32_t : 0x0f000000
SAMPLER_BORDER_COLOR :: #force_inline proc(v : c.uint32_t) -> c.uint32_t { return (v << SAMPLER_BORDER_COLOR_SHIFT) & SAMPLER_BORDER_COLOR_MASK }

SAMPLER_RESERVED_SHIFT               : c.uint32_t : 28
SAMPLER_RESERVED_MASK                : c.uint32_t : 0xf0000000

SAMPLER_NONE                         : c.uint32_t : 0x00000000
SAMPLER_SAMPLE_STENCIL               : c.uint32_t : 0x00100000          // Sample stencil instead of depth.
SAMPLER_POINT ::          (
    SAMPLER_MIN_POINT     |
    SAMPLER_MAG_POINT     |
    SAMPLER_MIP_POINT     )

SAMPLER_UVW_MIRROR ::     (
    SAMPLER_U_MIRROR      |
    SAMPLER_V_MIRROR      |
    SAMPLER_W_MIRROR      )

SAMPLER_UVW_CLAMP ::      (
    SAMPLER_U_CLAMP       |
    SAMPLER_V_CLAMP       |
    SAMPLER_W_CLAMP       )

SAMPLER_UVW_BORDER ::     (
    SAMPLER_U_BORDER      |
    SAMPLER_V_BORDER      |
    SAMPLER_W_BORDER      )

SAMPLER_BITS_MASK ::      (
    SAMPLER_U_MASK        |
    SAMPLER_V_MASK        |
    SAMPLER_W_MASK        |
    SAMPLER_MIN_MASK      |
    SAMPLER_MAG_MASK      |
    SAMPLER_MIP_MASK      |
    SAMPLER_COMPARE_MASK  )

RESET_MSAA_X2                        : c.uint32_t : 0x00000010          // Enable 2x MSAA.
RESET_MSAA_X4                        : c.uint32_t : 0x00000020          // Enable 4x MSAA.
RESET_MSAA_X8                        : c.uint32_t : 0x00000030          // Enable 8x MSAA.
RESET_MSAA_X16                       : c.uint32_t : 0x00000040          // Enable 16x MSAA.
RESET_MSAA_SHIFT                     : c.uint32_t : 4
RESET_MSAA_MASK                      : c.uint32_t : 0x00000070

RESET_NONE                           : c.uint32_t : 0x00000000          // No reset flags.
RESET_FULLSCREEN                     : c.uint32_t : 0x00000001          // Not supported yet.
RESET_VSYNC                          : c.uint32_t : 0x00000080          // Enable V-Sync.
RESET_MAXANISOTROPY                  : c.uint32_t : 0x00000100          // Turn on/off max anisotropy.
RESET_CAPTURE                        : c.uint32_t : 0x00000200          // Begin screen capture.
RESET_FLUSH_AFTER_RENDER             : c.uint32_t : 0x00002000          // Flush rendering after submitting to GPU.
RESET_FLIP_AFTER_RENDER              : c.uint32_t : 0x00004000          // This flag specifies where flip occurs. Default behaviour is that flip occurs before rendering new frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`.
RESET_SRGB_BACKBUFFER                : c.uint32_t : 0x00008000          // Enable sRGB backbuffer.
RESET_HDR10                          : c.uint32_t : 0x00010000          // Enable HDR10 rendering.
RESET_HIDPI                          : c.uint32_t : 0x00020000          // Enable HiDPI rendering.
RESET_DEPTH_CLAMP                    : c.uint32_t : 0x00040000          // Enable depth clamp.
RESET_SUSPEND                        : c.uint32_t : 0x00080000          // Suspend rendering.
RESET_TRANSPARENT_BACKBUFFER         : c.uint32_t : 0x00100000          // Transparent backbuffer. Availability depends on: `BGFX_CAPS_TRANSPARENT_BACKBUFFER`.

RESET_FULLSCREEN_SHIFT               : c.uint32_t : 0
RESET_FULLSCREEN_MASK                : c.uint32_t : 0x00000001

RESET_RESERVED_SHIFT                 : c.uint32_t : 31
RESET_RESERVED_MASK                  : c.uint32_t : 0x80000000

CAPS_ALPHA_TO_COVERAGE               : c.uint64_t : 0x0000000000000001  // Alpha to coverage is supported.
CAPS_BLEND_INDEPENDENT               : c.uint64_t : 0x0000000000000002  // Blend independent is supported.
CAPS_COMPUTE                         : c.uint64_t : 0x0000000000000004  // Compute shaders are supported.
CAPS_CONSERVATIVE_RASTER             : c.uint64_t : 0x0000000000000008  // Conservative rasterization is supported.
CAPS_DRAW_INDIRECT                   : c.uint64_t : 0x0000000000000010  // Draw indirect is supported.
CAPS_DRAW_INDIRECT_COUNT             : c.uint64_t : 0x0000000000000020  // Draw indirect with indirect count is supported.
CAPS_FRAGMENT_DEPTH                  : c.uint64_t : 0x0000000000000040  // Fragment depth is available in fragment shader.
CAPS_FRAGMENT_ORDERING               : c.uint64_t : 0x0000000000000080  // Fragment ordering is available in fragment shader.
CAPS_GRAPHICS_DEBUGGER               : c.uint64_t : 0x0000000000000100  // Graphics debugger is present.
CAPS_HDR10                           : c.uint64_t : 0x0000000000000200  // HDR10 rendering is supported.
CAPS_HIDPI                           : c.uint64_t : 0x0000000000000400  // HiDPI rendering is supported.
CAPS_IMAGE_RW                        : c.uint64_t : 0x0000000000000800  // Image Read/Write is supported.
CAPS_INDEX32                         : c.uint64_t : 0x0000000000001000  // 32-bit indices are supported.
CAPS_INSTANCING                      : c.uint64_t : 0x0000000000002000  // Instancing is supported.
CAPS_OCCLUSION_QUERY                 : c.uint64_t : 0x0000000000004000  // Occlusion query is supported.
CAPS_PRIMITIVE_ID                    : c.uint64_t : 0x0000000000008000  // PrimitiveID is available in fragment shader.
CAPS_RENDERER_MULTITHREADED          : c.uint64_t : 0x0000000000010000  // Renderer is on separate thread.
CAPS_SWAP_CHAIN                      : c.uint64_t : 0x0000000000020000  // Multiple windows are supported.
CAPS_TEXTURE_BLIT                    : c.uint64_t : 0x0000000000040000  // Texture blit is supported.
CAPS_TEXTURE_COMPARE_LEQUAL          : c.uint64_t : 0x0000000000080000  // Texture compare less equal mode is supported.
CAPS_TEXTURE_COMPARE_RESERVED        : c.uint64_t : 0x0000000000100000
CAPS_TEXTURE_CUBE_ARRAY              : c.uint64_t : 0x0000000000200000  // Cubemap texture array is supported.
CAPS_TEXTURE_DIRECT_ACCESS           : c.uint64_t : 0x0000000000400000  // CPU direct access to GPU texture memory.
CAPS_TEXTURE_READ_BACK               : c.uint64_t : 0x0000000000800000  // Read-back texture is supported.
CAPS_TEXTURE_2D_ARRAY                : c.uint64_t : 0x0000000001000000  // 2D texture array is supported.
CAPS_TEXTURE_3D                      : c.uint64_t : 0x0000000002000000  // 3D textures are supported.
CAPS_TRANSPARENT_BACKBUFFER          : c.uint64_t : 0x0000000004000000  // Transparent back buffer supported.
CAPS_VERTEX_ATTRIB_HALF              : c.uint64_t : 0x0000000008000000  // Vertex attribute half-float is supported.
CAPS_VERTEX_ATTRIB_UINT10            : c.uint64_t : 0x0000000010000000  // Vertex attribute 10_10_10_2 is supported.
CAPS_VERTEX_ID                       : c.uint64_t : 0x0000000020000000  // Rendering with VertexID only is supported.
CAPS_VIEWPORT_LAYER_ARRAY            : c.uint64_t : 0x0000000040000000  // Viewport layer is available in vertex shader.
CAPS_TEXTURE_COMPARE_ALL             : c.uint64_t : 0x0000000000180000  // All texture compare modes are supported.

CAPS_FORMAT_TEXTURE_NONE             : c.uint32_t : 0x00000000          // Texture format is not supported.
CAPS_FORMAT_TEXTURE_2D               : c.uint32_t : 0x00000001          // Texture format is supported.
CAPS_FORMAT_TEXTURE_2D_SRGB          : c.uint32_t : 0x00000002          // Texture as sRGB format is supported.
CAPS_FORMAT_TEXTURE_2D_EMULATED      : c.uint32_t : 0x00000004          // Texture format is emulated.
CAPS_FORMAT_TEXTURE_3D               : c.uint32_t : 0x00000008          // Texture format is supported.
CAPS_FORMAT_TEXTURE_3D_SRGB          : c.uint32_t : 0x00000010          // Texture as sRGB format is supported.
CAPS_FORMAT_TEXTURE_3D_EMULATED      : c.uint32_t : 0x00000020          // Texture format is emulated.
CAPS_FORMAT_TEXTURE_CUBE             : c.uint32_t : 0x00000040          // Texture format is supported.
CAPS_FORMAT_TEXTURE_CUBE_SRGB        : c.uint32_t : 0x00000080          // Texture as sRGB format is supported.
CAPS_FORMAT_TEXTURE_CUBE_EMULATED    : c.uint32_t : 0x00000100          // Texture format is emulated.
CAPS_FORMAT_TEXTURE_VERTEX           : c.uint32_t : 0x00000200          // Texture format can be used from vertex shader.
CAPS_FORMAT_TEXTURE_IMAGE_READ       : c.uint32_t : 0x00000400          // Texture format can be used as image and read from.
CAPS_FORMAT_TEXTURE_IMAGE_WRITE      : c.uint32_t : 0x00000800          // Texture format can be used as image and written to.
CAPS_FORMAT_TEXTURE_FRAMEBUFFER      : c.uint32_t : 0x00001000          // Texture format can be used as frame buffer.
CAPS_FORMAT_TEXTURE_FRAMEBUFFER_MSAA : c.uint32_t : 0x00002000          // Texture format can be used as MSAA frame buffer.
CAPS_FORMAT_TEXTURE_MSAA             : c.uint32_t : 0x00004000          // Texture can be sampled as MSAA.
CAPS_FORMAT_TEXTURE_MIP_AUTOGEN      : c.uint32_t : 0x00008000          // Texture format supports auto-generated mips.

RESOLVE_NONE                         : c.uint8_t  : 0x00                // No resolve flags.
RESOLVE_AUTO_GEN_MIPS                : c.uint8_t  : 0x01                // Auto-generate mip maps on resolve.

PCI_ID_NONE                          : c.uint16_t : 0x0000              // Autoselect adapter.
PCI_ID_SOFTWARE_RASTERIZER           : c.uint16_t : 0x0001              // Software rasterizer.
PCI_ID_AMD                           : c.uint16_t : 0x1002              // AMD adapter.
PCI_ID_APPLE                         : c.uint16_t : 0x106b              // Apple adapter.
PCI_ID_INTEL                         : c.uint16_t : 0x8086              // Intel adapter.
PCI_ID_NVIDIA                        : c.uint16_t : 0x10de              // nVidia adapter.
PCI_ID_MICROSOFT                     : c.uint16_t : 0x1414              // Microsoft adapter.
PCI_ID_ARM                           : c.uint16_t : 0x13b5              // ARM adapter.

CUBE_MAP_POSITIVE_X                  : c.uint8_t  : 0x00                // Cubemap +x.
CUBE_MAP_NEGATIVE_X                  : c.uint8_t  : 0x01                // Cubemap -x.
CUBE_MAP_POSITIVE_Y                  : c.uint8_t  : 0x02                // Cubemap +y.
CUBE_MAP_NEGATIVE_Y                  : c.uint8_t  : 0x03                // Cubemap -y.
CUBE_MAP_POSITIVE_Z                  : c.uint8_t  : 0x04                // Cubemap +z.
CUBE_MAP_NEGATIVE_Z                  : c.uint8_t  : 0x05                // Cubemap -z.

Fatal :: enum c.int {
    DebugCheck,
    InvalidShader,
    UnableToInitialize,
    UnableToCreateTexture,
    DeviceLost,
    Count
}

// Renderer types:
Renderer_Type :: enum c.int {
    Noop,                            // No rendering.
    Agc,                             // AGC
    Direct3D11,                      // Direct3D 11.0
    Direct3D12,                      // Direct3D 12.0
    Gnm,                             // GNM
    Metal,                           // Metal
    Nvn,                             // NVN
    OpenGLES,                        // OpenGL ES 2.0+
    OpenGL,                          // OpenGL 2.1+
    Vulkan,                          // Vulkan
    Count
}

// Access:
Access :: enum c.int {
    Read,                            // Read.
    Write,                           // Write.
    ReadWrite,                       // Read and write.
    Count
}

// Corresponds to vertex shader attribute.
Attrib :: enum c.int {
    Position,                        // a_position
    Normal,                          // a_normal
    Tangent,                         // a_tangent
    Bitangent,                       // a_bitangent
    Color0,                          // a_color0
    Color1,                          // a_color1
    Color2,                          // a_color2
    Color3,                          // a_color3
    Indices,                         // a_indices
    Weight,                          // a_weight
    TexCoord0,                       // a_texcoord0
    TexCoord1,                       // a_texcoord1
    TexCoord2,                       // a_texcoord2
    TexCoord3,                       // a_texcoord3
    TexCoord4,                       // a_texcoord4
    TexCoord5,                       // a_texcoord5
    TexCoord6,                       // a_texcoord6
    TexCoord7,                       // a_texcoord7
    Count
}

// Attribute types:
Attrib_Type :: enum c.int {
    Uint8,                           // Uint8
    Uint10,                          // Uint10, availability depends on: `BGFX_CAPS_VERTEX_ATTRIB_UINT10`.
    Int16,                           // Int16
    Half,                            // Half, availability depends on: `BGFX_CAPS_VERTEX_ATTRIB_HALF`.
    Float,                           // Float
    Count
}

// Texture formats:
Texture_Format :: enum c.int {
    BC1,                             // DXT1 R5G6B5A1
    BC2,                             // DXT3 R5G6B5A4
    BC3,                             // DXT5 R5G6B5A8
    BC4,                             // LATC1/ATI1 R8
    BC5,                             // LATC2/ATI2 RG8
    BC6H,                            // BC6H RGB16F
    BC7,                             // BC7 RGB 4-7 bits per color channel, 0-8 bits alpha
    ETC1,                            // ETC1 RGB8
    ETC2,                            // ETC2 RGB8
    ETC2A,                           // ETC2 RGBA8
    ETC2A1,                          // ETC2 RGB8A1
    PTC12,                           // PVRTC1 RGB 2BPP
    PTC14,                           // PVRTC1 RGB 4BPP
    PTC12A,                          // PVRTC1 RGBA 2BPP
    PTC14A,                          // PVRTC1 RGBA 4BPP
    PTC22,                           // PVRTC2 RGBA 2BPP
    PTC24,                           // PVRTC2 RGBA 4BPP
    ATC,                             // ATC RGB 4BPP
    ATCE,                            // ATCE RGBA 8 BPP explicit alpha
    ATCI,                            // ATCI RGBA 8 BPP interpolated alpha
    ASTC4x4,                         // ASTC 4x4 8.0 BPP
    ASTC5x4,                         // ASTC 5x4 6.40 BPP
    ASTC5x5,                         // ASTC 5x5 5.12 BPP
    ASTC6x5,                         // ASTC 6x5 4.27 BPP
    ASTC6x6,                         // ASTC 6x6 3.56 BPP
    ASTC8x5,                         // ASTC 8x5 3.20 BPP
    ASTC8x6,                         // ASTC 8x6 2.67 BPP
    ASTC8x8,                         // ASTC 8x8 2.00 BPP
    ASTC10x5,                        // ASTC 10x5 2.56 BPP
    ASTC10x6,                        // ASTC 10x6 2.13 BPP
    ASTC10x8,                        // ASTC 10x8 1.60 BPP
    ASTC10x10,                       // ASTC 10x10 1.28 BPP
    ASTC12x10,                       // ASTC 12x10 1.07 BPP
    ASTC12x12,                       // ASTC 12x12 0.89 BPP
    Unknown,                         // Compressed formats above.
    R1,
    A8,
    R8,
    R8I,
    R8U,
    R8S,
    R16,
    R16I,
    R16U,
    R16F,
    R16S,
    R32I,
    R32U,
    R32F,
    RG8,
    RG8I,
    RG8U,
    RG8S,
    RG16,
    RG16I,
    RG16U,
    RG16F,
    RG16S,
    RG32I,
    RG32U,
    RG32F,
    RGB8,
    RGB8I,
    RGB8U,
    RGB8S,
    RGB9E5F,
    BGRA8,
    RGBA8,
    RGBA8I,
    RGBA8U,
    RGBA8S,
    RGBA16,
    RGBA16I,
    RGBA16U,
    RGBA16F,
    RGBA16S,
    RGBA32I,
    RGBA32U,
    RGBA32F,
    B5G6R5,
    R5G6B5,
    BGRA4,
    RGBA4,
    BGR5A1,
    RGB5A1,
    RGB10A2,
    RG11B10F,
    UnknownDepth,                    // Depth formats below.
    D16,
    D24,
    D24S8,
    D32,
    D16F,
    D24F,
    D32F,
    D0S8,
    Count
}

// Uniform types:
Uniform_Type :: enum c.int {
    Sampler,                         // Sampler.
    End,                             // Reserved, do not use.
    Vec4,                            // 4 floats vector.
    Mat3,                            // 3x3 matrix.
    Mat4,                            // 4x4 matrix.
    Count
}

// Backbuffer ratios:
Backbuffer_Ratio :: enum c.int {
    Equal,                           // Equal to backbuffer.
    Half,                            // One half size of backbuffer.
    Quarter,                         // One quarter size of backbuffer.
    Eighth,                          // One eighth size of backbuffer.
    Sixteenth,                       // One sixteenth size of backbuffer.
    Double,                          // Double size of backbuffer.
    Count
}

// Occlusion query results:
Occlusion_Query_Result :: enum c.int {
    Invisible,                       // Query failed test.
    Visible,                         // Query passed test.
    NoResult,                        // Query result is not available yet.
    Count
}

// Primitive topology:
Topology :: enum c.int {
    TriList,                         // Triangle list.
    TriStrip,                        // Triangle strip.
    LineList,                        // Line list.
    LineStrip,                       // Line strip.
    PointList,                       // Point list.
    Count
}

// Topology conversion functions:
Topology_Convert :: enum c.int {
    TriListFlipWinding,              // Flip winding order of triangle list.
    TriStripFlipWinding,             // Flip winding order of triangle strip.
    TriListToLineList,               // Convert triangle list to line list.
    TriStripToTriList,               // Convert triangle strip to triangle list.
    LineStripToLineList,             // Convert line strip to line list.
    Count
}

// Topology sort order:
Topology_Sort :: enum c.int {
    DirectionFrontToBackMin,
    DirectionFrontToBackAvg,
    DirectionFrontToBackMax,
    DirectionBackToFrontMin,
    DirectionBackToFrontAvg,
    DirectionBackToFrontMax,
    DistanceFrontToBackMin,
    DistanceFrontToBackAvg,
    DistanceFrontToBackMax,
    DistanceBackToFrontMin,
    DistanceBackToFrontAvg,
    DistanceBackToFrontMax,
    Count
}

// View modes:
View_Mode :: enum c.int {
    Default,                         // Default sort order.
    Sequential,                      // Sort in the same order in which submit calls were called.
    DepthAscending,                  // Sort draw call depth in ascending order.
    DepthDescending,                 // Sort draw call depth in descending order.
    Count
}

// Native Window handle type:
Native_Window_Handle_Type :: enum c.int {
    Default,                         // Platform default handle type (X11 on Linux).
    Wayland,                         // Wayland.
    Count
}

Render_Frame :: enum c.int {
    NoContext,                       // Renderer context is not created yet.
    Render,                          // Renderer context is created and rendering.
    Timeout,                         // Renderer context wait for main thread signal timed out without rendering.
    Exiting,                         // Renderer context is getting destroyed.
    Count
}

// GPU info.
Caps_GPU :: struct {
    vendor_id                   : c.uint16_t,                 // Vendor PCI id. See `BGFX_PCI_ID_*`.
    device_id                   : c.uint16_t,                 // Device id.
}

// Renderer runtime limits.
Caps_Limits :: struct {
    max_draw_calls              : c.uint32_t,                 // Maximum number of draw calls.
    max_blits                   : c.uint32_t,                 // Maximum number of blit calls.
    max_texture_size            : c.uint32_t,                 // Maximum texture size.
    max_texture_layers          : c.uint32_t,                 // Maximum texture layers.
    max_views                   : c.uint32_t,                 // Maximum number of views.
    max_frame_buffers           : c.uint32_t,                 // Maximum number of frame buffer handles.
    max_fbattachments           : c.uint32_t,                 // Maximum number of frame buffer attachments.
    max_programs                : c.uint32_t,                 // Maximum number of program handles.
    max_shaders                 : c.uint32_t,                 // Maximum number of shader handles.
    max_textures                : c.uint32_t,                 // Maximum number of texture handles.
    max_texture_samplers        : c.uint32_t,                 // Maximum number of texture samplers.
    max_compute_bindings        : c.uint32_t,                 // Maximum number of compute bindings.
    max_vertex_layouts          : c.uint32_t,                 // Maximum number of vertex format layouts.
    max_vertex_streams          : c.uint32_t,                 // Maximum number of vertex streams.
    max_index_buffers           : c.uint32_t,                 // Maximum number of index buffer handles.
    max_vertex_buffers          : c.uint32_t,                 // Maximum number of vertex buffer handles.
    max_dynamic_index_buffers   : c.uint32_t,                 // Maximum number of dynamic index buffer handles.
    max_dynamic_vertex_buffers  : c.uint32_t,                 // Maximum number of dynamic vertex buffer handles.
    max_uniforms                : c.uint32_t,                 // Maximum number of uniform handles.
    max_occlusion_queries       : c.uint32_t,                 // Maximum number of occlusion query handles.
    max_encoders                : c.uint32_t,                 // Maximum number of encoder threads.
    min_resource_cb_size        : c.uint32_t,                 // Minimum resource command buffer size.
    transient_vb_size           : c.uint32_t,                 // Maximum transient vertex buffer size.
    transient_ib_size           : c.uint32_t,                 // Maximum transient index buffer size.
}

// Renderer capabilities.
Caps :: struct {
    renderer_type               : Renderer_Type,              // Renderer backend type. See: `bgfx::RendererType`

    // Supported functionality.
    //   @attention See `BGFX_CAPS_*` flags at https://bkaradzic.github.io/bgfx/bgfx.html#available-caps
    supported                   : c.uint64_t,
    vendor_id                   : c.uint16_t,                 // Selected GPU vendor PCI id.
    device_id                   : c.uint16_t,                 // Selected GPU device id.
    homogeneous_depth           : bool,                       // True when NDC depth is in [-1, 1] range, otherwise its [0, 1].
    origin_bottom_left          : bool,                       // True when NDC origin is at bottom left.
    num_gpus                    : c.uint8_t,                  // Number of enumerated GPUs.
    gpu                         : [4]Caps_GPU,                // Enumerated GPUs.
    limits                      : Caps_Limits,                // Renderer runtime limits.

    // Supported texture format capabilities flags:
    //   - `BGFX_CAPS_FORMAT_TEXTURE_NONE` - Texture format is not supported.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_2D` - Texture format is supported.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_2D_SRGB` - Texture as sRGB format is supported.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_2D_EMULATED` - Texture format is emulated.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_3D` - Texture format is supported.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_3D_SRGB` - Texture as sRGB format is supported.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_3D_EMULATED` - Texture format is emulated.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_CUBE` - Texture format is supported.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_CUBE_SRGB` - Texture as sRGB format is supported.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_CUBE_EMULATED` - Texture format is emulated.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_VERTEX` - Texture format can be used from vertex shader.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_IMAGE_READ` - Texture format can be used as image
    //     and read from.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_IMAGE_WRITE` - Texture format can be used as image
    //     and written to.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER` - Texture format can be used as frame
    //     buffer.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER_MSAA` - Texture format can be used as MSAA
    //     frame buffer.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_MSAA` - Texture can be sampled as MSAA.
    //   - `BGFX_CAPS_FORMAT_TEXTURE_MIP_AUTOGEN` - Texture format supports auto-generated
    //     mips.
    formats                     : [Texture_Format.Count]c.uint16_t,
}

// Internal data.
Internal_Data :: struct {
    caps                        : ^Caps,                      // Renderer capabilities.
    ctx                         : rawptr,                     // GL context, or D3D device.
}

// Platform data.
Platform_Data :: struct {
    ndt                         : rawptr,                     // Native display type (*nix specific).

    // Native window handle. If `NULL`, bgfx will create a headless
    // context/device, provided the rendering API supports it.
    nwh                         : rawptr,

    // GL context, D3D device, or Vulkan device. If `NULL`, bgfx
    // will create context/device.
    ctx                         : rawptr,

    // GL back-buffer, or D3D render target view. If `NULL` bgfx will
    // create back-buffer color surface.
    back_buffer                 : rawptr,

    // Backbuffer depth/stencil. If `NULL`, bgfx will create a back-buffer
    // depth/stencil surface.
    back_buffer_ds              : rawptr,
    type                        : Native_Window_Handle_Type,  // Handle type. Needed for platforms having more than one option.
}

// Backbuffer resolution and reset parameters.
Resolution :: struct {
    format                      : Texture_Format,             // Backbuffer format.
    width                       : c.uint32_t,                 // Backbuffer width.
    height                      : c.uint32_t,                 // Backbuffer height.
    reset                       : c.uint32_t,                 // Reset parameters.
    num_back_buffers            : c.uint8_t,                  // Number of back buffers.
    max_frame_latency           : c.uint8_t,                  // Maximum frame latency.
    debug_text_scale            : c.uint8_t,                  // Scale factor for debug text.
}

// Configurable runtime limits parameters.
Init_Limits :: struct {
    max_encoders                : c.uint16_t,                 // Maximum number of encoder threads.
    min_resource_cb_size        : c.uint32_t,                 // Minimum resource command buffer size.
    transient_vb_size           : c.uint32_t,                 // Maximum transient vertex buffer size.
    transient_ib_size           : c.uint32_t,                 // Maximum transient index buffer size.
}

// Initialization parameters used by `bgfx::init`.
Init :: struct {

    // Select rendering backend. When set to RendererType::Count
    // a default rendering backend will be selected appropriate to the platform.
    // See: `bgfx::RendererType`
    type                        : Renderer_Type,

    // Vendor PCI ID. If set to `BGFX_PCI_ID_NONE`, discrete and integrated
    // GPUs will be prioritised.
    //   - `BGFX_PCI_ID_NONE` - Autoselect adapter.
    //   - `BGFX_PCI_ID_SOFTWARE_RASTERIZER` - Software rasterizer.
    //   - `BGFX_PCI_ID_AMD` - AMD adapter.
    //   - `BGFX_PCI_ID_APPLE` - Apple adapter.
    //   - `BGFX_PCI_ID_INTEL` - Intel adapter.
    //   - `BGFX_PCI_ID_NVIDIA` - NVIDIA adapter.
    //   - `BGFX_PCI_ID_MICROSOFT` - Microsoft adapter.
    vendor_id                   : c.uint16_t,

    // Device ID. If set to 0 it will select first device, or device with
    // matching ID.
    device_id                   : c.uint16_t,
    capabilities                : c.uint64_t,                 // Capabilities initialization mask (default: UINT64_MAX).
    debug                       : bool,                       // Enable device for debugging.
    profile                     : bool,                       // Enable device for profiling.
    platform_data               : Platform_Data,              // Platform data.
    resolution                  : Resolution,                 // Backbuffer resolution and reset parameters. See: `bgfx::Resolution`.
    limits                      : Init_Limits,                // Configurable runtime limits parameters.

    // Provide application specific callback interface.
    // See: `bgfx::CallbackI`
    callback                    : ^Callback_Interface,

    // Custom allocator. When a custom allocator is not
    // specified, bgfx uses the CRT allocator. Bgfx assumes
    // custom allocator is thread safe.
    allocator                   : ^Allocator_Interface,
}

// Memory must be obtained by calling `bgfx::alloc`, `bgfx::copy`, or `bgfx::makeRef`.
// @attention It is illegal to create this structure on stack and pass it to any bgfx API.
Memory :: struct {
    data                        : ^c.uint8_t,                 // Pointer to data.
    size                        : c.uint32_t,                 // Data size.
}

// Transient index buffer.
Transient_Index_Buffer :: struct {
    data                        : ^c.uint8_t,                 // Pointer to data.
    size                        : c.uint32_t,                 // Data size.
    start_index                 : c.uint32_t,                 // First index.
    handle                      : Index_Buffer_Handle,        // Index buffer handle.
    is_index16                  : bool,                       // Index buffer format is 16-bits if true, otherwise it is 32-bit.
}

// Transient vertex buffer.
Transient_Vertex_Buffer :: struct {
    data                        : ^c.uint8_t,                 // Pointer to data.
    size                        : c.uint32_t,                 // Data size.
    start_vertex                : c.uint32_t,                 // First vertex.
    stride                      : c.uint16_t,                 // Vertex stride.
    handle                      : Vertex_Buffer_Handle,       // Vertex buffer handle.
    layout_handle               : Vertex_Layout_Handle,       // Vertex layout handle.
}

// Instance data buffer info.
Instance_Data_Buffer :: struct {
    data                        : ^c.uint8_t,                 // Pointer to data.
    size                        : c.uint32_t,                 // Data size.
    offset                      : c.uint32_t,                 // Offset in vertex buffer.
    num                         : c.uint32_t,                 // Number of instances.
    stride                      : c.uint16_t,                 // Vertex buffer stride.
    handle                      : Vertex_Buffer_Handle,       // Vertex buffer object handle.
}

// Texture info.
Texture_Info :: struct {
    format                      : Texture_Format,             // Texture format.
    storage_size                : c.uint32_t,                 // Total amount of bytes required to store texture.
    width                       : c.uint16_t,                 // Texture width.
    height                      : c.uint16_t,                 // Texture height.
    depth                       : c.uint16_t,                 // Texture depth.
    num_layers                  : c.uint16_t,                 // Number of layers in texture array.
    num_mips                    : c.uint8_t,                  // Number of MIP maps.
    bits_per_pixel              : c.uint8_t,                  // Format bits per pixel.
    cube_map                    : bool,                       // Texture is cubemap.
}

// Uniform info.
Uniform_Info :: struct {
    name                        : [256]c.char,                // Uniform name.
    type                        : Uniform_Type,               // Uniform type.
    num                         : c.uint16_t,                 // Number of elements in array.
}

// Frame buffer texture attachment info.
Attachment :: struct {
    access                      : Access,                     // Attachment access. See `Access::Enum`.
    handle                      : Texture_Handle,             // Render target texture handle.
    mip                         : c.uint16_t,                 // Mip level.
    layer                       : c.uint16_t,                 // Cubemap side or depth layer/slice to use.
    num_layers                  : c.uint16_t,                 // Number of texture layer/slice(s) in array to use.
    resolve                     : c.uint8_t,                  // Resolve flags. See: `BGFX_RESOLVE_*`
}

// Transform data.
Transform :: struct {
    data                        : ^c.float,                   // Pointer to first 4x4 matrix.
    num                         : c.uint16_t,                 // Number of matrices.
}

// View stats.
View_Stats :: struct {
    name                        : [256]c.char,                // View name.
    view                        : View_Id,                    // View id.
    cpu_time_begin              : c.int64_t,                  // CPU (submit) begin time.
    cpu_time_end                : c.int64_t,                  // CPU (submit) end time.
    gpu_time_begin              : c.int64_t,                  // GPU begin time.
    gpu_time_end                : c.int64_t,                  // GPU end time.
    gpu_frame_num               : c.uint32_t,                 // Frame which generated gpuTimeBegin, gpuTimeEnd.
}

// Encoder stats.
Encoder_Stats :: struct {
    cpu_time_begin              : c.int64_t,                  // Encoder thread CPU submit begin time.
    cpu_time_end                : c.int64_t,                  // Encoder thread CPU submit end time.
}

// Renderer statistics data.
// @remarks All time values are high-resolution timestamps, while
// time frequencies define timestamps-per-second for that hardware.
Stats :: struct {
    cpu_time_frame              : c.int64_t,                  // CPU time between two `bgfx::frame` calls.
    cpu_time_begin              : c.int64_t,                  // Render thread CPU submit begin time.
    cpu_time_end                : c.int64_t,                  // Render thread CPU submit end time.
    cpu_timer_freq              : c.int64_t,                  // CPU timer frequency. Timestamps-per-second
    gpu_time_begin              : c.int64_t,                  // GPU frame begin time.
    gpu_time_end                : c.int64_t,                  // GPU frame end time.
    gpu_timer_freq              : c.int64_t,                  // GPU timer frequency.
    wait_render                 : c.int64_t,                  // Time spent waiting for render backend thread to finish issuing draw commands to underlying graphics API.
    wait_submit                 : c.int64_t,                  // Time spent waiting for submit thread to advance to next frame.
    num_draw                    : c.uint32_t,                 // Number of draw calls submitted.
    num_compute                 : c.uint32_t,                 // Number of compute calls submitted.
    num_blit                    : c.uint32_t,                 // Number of blit calls submitted.
    max_gpu_latency             : c.uint32_t,                 // GPU driver latency.
    gpu_frame_num               : c.uint32_t,                 // Frame which generated gpuTimeBegin, gpuTimeEnd.
    num_dynamic_index_buffers   : c.uint16_t,                 // Number of used dynamic index buffers.
    num_dynamic_vertex_buffers  : c.uint16_t,                 // Number of used dynamic vertex buffers.
    num_frame_buffers           : c.uint16_t,                 // Number of used frame buffers.
    num_index_buffers           : c.uint16_t,                 // Number of used index buffers.
    num_occlusion_queries       : c.uint16_t,                 // Number of used occlusion queries.
    num_programs                : c.uint16_t,                 // Number of used programs.
    num_shaders                 : c.uint16_t,                 // Number of used shaders.
    num_textures                : c.uint16_t,                 // Number of used textures.
    num_uniforms                : c.uint16_t,                 // Number of used uniforms.
    num_vertex_buffers          : c.uint16_t,                 // Number of used vertex buffers.
    num_vertex_layouts          : c.uint16_t,                 // Number of used vertex layouts.
    texture_memory_used         : c.int64_t,                  // Estimate of texture memory used.
    rt_memory_used              : c.int64_t,                  // Estimate of render target memory used.
    transient_vb_used           : c.int32_t,                  // Amount of transient vertex buffer used.
    transient_ib_used           : c.int32_t,                  // Amount of transient index buffer used.
    num_prims                   : [Topology.Count]c.uint32_t, // Number of primitives rendered.
    gpu_memory_max              : c.int64_t,                  // Maximum available GPU memory for application.
    gpu_memory_used             : c.int64_t,                  // Amount of GPU memory used by the application.
    width                       : c.uint16_t,                 // Backbuffer width in pixels.
    height                      : c.uint16_t,                 // Backbuffer height in pixels.
    text_width                  : c.uint16_t,                 // Debug text width in characters.
    text_height                 : c.uint16_t,                 // Debug text height in characters.
    num_views                   : c.uint16_t,                 // Number of view stats.
    view_stats                  : ^View_Stats,                // Array of View stats.
    num_encoders                : c.uint8_t,                  // Number of encoders used during frame.
    encoder_stats               : ^Encoder_Stats,             // Array of encoder stats.
}

// Vertex layout.
Vertex_Layout :: struct {
    hash                        : c.uint32_t,                 // Hash.
    stride                      : c.uint16_t,                 // Stride.
    offset                      : [Attrib.Count]c.uint16_t,   // Attribute offsets.
    attributes                  : [Attrib.Count]c.uint16_t,   // Used attributes.
}

// Encoders are used for submitting draw calls from multiple threads. Only one encoder
// per thread should be used. Use `bgfx::begin()` to obtain an encoder for a thread.
Encoder :: struct {
}

Dynamic_Index_Buffer_Handle  :: struct { idx : c.uint16_t }

Dynamic_Vertex_Buffer_Handle :: struct { idx : c.uint16_t }

Frame_Buffer_Handle          :: struct { idx : c.uint16_t }

Index_Buffer_Handle          :: struct { idx : c.uint16_t }

Indirect_Buffer_Handle       :: struct { idx : c.uint16_t }

Occlusion_Query_Handle       :: struct { idx : c.uint16_t }

Program_Handle               :: struct { idx : c.uint16_t }

Shader_Handle                :: struct { idx : c.uint16_t }

Texture_Handle               :: struct { idx : c.uint16_t }

Uniform_Handle               :: struct { idx : c.uint16_t }

Vertex_Buffer_Handle         :: struct { idx : c.uint16_t }

Vertex_Layout_Handle         :: struct { idx : c.uint16_t }


is_valid :: #force_inline proc (handle : $T) -> bool {
    return handle.idx != INVALID_HANDLE
}


// Blend function separate.
STATE_BLEND_FUNC_SEPARATE :: #force_inline proc(srcRGB, dstRGB, srcA, dstA : c.uint64_t) -> c.uint64_t {
    return (srcRGB | (dstRGB << 4)) | ((srcA | (dstA << 4)) << 8)
}

// Blend equation separate.
STATE_BLEND_EQUATION_SEPARATE :: #force_inline proc(equationRGB, equationA : c.uint64_t) -> c.uint64_t {
    return equationRGB | (equationA << 3)
}

// Blend function.
STATE_BLEND_FUNC :: #force_inline proc(src, dst : c.uint64_t) -> c.uint64_t {
    return STATE_BLEND_FUNC_SEPARATE(src, dst, src, dst)
}

// Blend equation.
STATE_BLEND_EQUATION :: #force_inline proc(equation : c.uint64_t) -> c.uint64_t {
    return STATE_BLEND_EQUATION_SEPARATE(equation, equation)
}

// Utility predefined blend modes.

// Additive blending.
STATE_BLEND_ADD :: #force_inline proc() -> c.uint64_t {
    return STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_ONE)
}

// Alpha blend.
STATE_BLEND_ALPHA :: #force_inline proc() -> c.uint64_t {
    return STATE_BLEND_FUNC(STATE_BLEND_SRC_ALPHA, STATE_BLEND_INV_SRC_ALPHA)
}

// Selects darker color of blend.
STATE_BLEND_DARKEN :: #force_inline proc() -> c.uint64_t {
    return STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_ONE) | STATE_BLEND_EQUATION(STATE_BLEND_EQUATION_MIN)
}

// Selects lighter color of blend.
STATE_BLEND_LIGHTEN :: #force_inline proc() -> c.uint64_t {
    return STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_ONE) | STATE_BLEND_EQUATION(STATE_BLEND_EQUATION_MAX)
}

// Multiplies colors.
STATE_BLEND_MULTIPLY :: #force_inline proc() -> c.uint64_t {
    return STATE_BLEND_FUNC(STATE_BLEND_DST_COLOR, STATE_BLEND_ZERO)
}

// Opaque pixels will cover the pixels directly below them without any math or algorithm applied to them.
STATE_BLEND_NORMAL :: #force_inline proc() -> c.uint64_t {
    return STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_INV_SRC_ALPHA)
}

// Multiplies the inverse of the blend and base colors.
STATE_BLEND_SCREEN :: #force_inline proc() -> c.uint64_t {
    return STATE_BLEND_FUNC(STATE_BLEND_ONE, STATE_BLEND_INV_SRC_COLOR)
}

// Decreases the brightness of the base color based on the value of the blend color.
STATE_BLEND_LINEAR_BURN :: #force_inline proc() -> c.uint64_t {
    return STATE_BLEND_FUNC(STATE_BLEND_DST_COLOR, STATE_BLEND_INV_DST_COLOR) | STATE_BLEND_EQUATION(STATE_BLEND_EQUATION_SUB)
}

//
STATE_BLEND_FUNC_RT_x :: #force_inline proc(src, dst : c.uint32_t) -> c.uint32_t {
    return (src >> STATE_BLEND_SHIFT) | ((dst >> STATE_BLEND_SHIFT) << 4)
}

//
STATE_BLEND_FUNC_RT_xE :: #force_inline proc(src, dst, equation : c.uint32_t) -> c.uint32_t {
    return STATE_BLEND_FUNC_RT_x(src, dst) | ((equation >> STATE_BLEND_EQUATION_SHIFT) << 8)
}

STATE_BLEND_FUNC_RT_1 :: #force_inline proc(src, dst : c.uint32_t) -> c.uint32_t {
    return STATE_BLEND_FUNC_RT_x(src, dst) << 0
}
STATE_BLEND_FUNC_RT_2 :: #force_inline proc(src, dst : c.uint32_t) -> c.uint32_t {
    return STATE_BLEND_FUNC_RT_x(src, dst) << 11
}
STATE_BLEND_FUNC_RT_3 :: #force_inline proc(src, dst : c.uint32_t) -> c.uint32_t {
    return STATE_BLEND_FUNC_RT_x(src, dst) << 22
}

STATE_BLEND_FUNC_RT_1E :: #force_inline proc(src, dst, equation : c.uint32_t) -> c.uint32_t {
    return STATE_BLEND_FUNC_RT_xE(src, dst, equation) << 0
}
STATE_BLEND_FUNC_RT_2E :: #force_inline proc(src, dst, equation : c.uint32_t) -> c.uint32_t {
    return STATE_BLEND_FUNC_RT_xE(src, dst, equation) << 11
}
STATE_BLEND_FUNC_RT_3E :: #force_inline proc(src, dst, equation : c.uint32_t) -> c.uint32_t {
    return STATE_BLEND_FUNC_RT_xE(src, dst, equation) << 22
}


@(default_calling_convention="c", link_prefix="bgfx_")
foreign lib {

// Init attachment.
// @param    in  handle            Render target texture handle.
// @param    in  access            Access. See `Access::Enum`.
// @param    in  layer             Cubemap side or depth layer/slice to use.
// @param    in  num_layers        Number of texture layer/slice(s) in array to use.
// @param    in  mip               Mip level.
// @param    in  resolve           Resolve flags. See: `BGFX_RESOLVE_*`
attachment_init :: proc(
    this              : ^Attachment,
    handle            : Texture_Handle,
    access            : Access,
    layer             : c.uint16_t,
    num_layers        : c.uint16_t,
    mip               : c.uint16_t,
    resolve           : c.uint8_t
) ---

// Start VertexLayout.
// @param    in  renderer_type     Renderer backend type. See: `bgfx::RendererType`
// @returns Returns itself.
vertex_layout_begin :: proc(
    this              : ^Vertex_Layout,
    renderer_type     : Renderer_Type
) -> ^Vertex_Layout ---

// Add attribute to VertexLayout.
// @remarks Must be called between begin/end.
// @param    in  attrib            Attribute semantics. See: `bgfx::Attrib`
// @param    in  num               Number of elements 1, 2, 3 or 4.
// @param    in  type              Element type.
// @param    in  normalized        When using fixed point AttribType (f.e. Uint8)
//                                 value will be normalized for vertex shader usage. When normalized
//                                 is set to true, AttribType::Uint8 value in range 0-255 will be
//                                 in range 0.0-1.0 in vertex shader.
// @param    in  as_int            Packaging rule for vertexPack, vertexUnpack, and
//                                 vertexConvert for AttribType::Uint8 and AttribType::Int16.
//                                 Unpacking code must be implemented inside vertex shader.
// @returns Returns itself.
vertex_layout_add :: proc(
    this              : ^Vertex_Layout,
    attrib            : Attrib,
    num               : c.uint8_t,
    type              : Attrib_Type,
    normalized        : bool,
    as_int            : bool
) -> ^Vertex_Layout ---

// Decode attribute.
// @param    in  attrib            Attribute semantics. See: `bgfx::Attrib`
// @param   out  num               Number of elements.
// @param   out  type              Element type.
// @param   out  normalized        Attribute is normalized.
// @param   out  as_int            Attribute is packed as int.
vertex_layout_decode :: proc(
    this              : ^Vertex_Layout,
    attrib            : Attrib,
    num               : ^c.uint8_t,
    type              : ^Attrib_Type,
    normalized        : ^bool,
    as_int            : ^bool
) ---

// Returns `true` if VertexLayout contains attribute.
// @param    in  attrib            Attribute semantics. See: `bgfx::Attrib`
// @returns True if VertexLayout contains attribute.
vertex_layout_has :: proc(
    this              : ^Vertex_Layout,
    attrib            : Attrib
) -> bool ---

// Skip `_num` bytes in vertex stream.
// @param    in  num               Number of bytes to skip.
// @returns Returns itself.
vertex_layout_skip :: proc(
    this              : ^Vertex_Layout,
    num               : c.uint8_t
) -> ^Vertex_Layout ---

// End VertexLayout.
vertex_layout_end :: proc(
    this              : ^Vertex_Layout
) ---

// Pack vertex attribute into vertex stream format.
// @param    in  input             Value to be packed into vertex stream.
// @param    in  input_normalized  `true` if input value is already normalized.
// @param    in  attr              Attribute to pack.
// @param    in  layout            Vertex stream layout.
// @param    in  data              Destination vertex stream where data will be packed.
// @param    in  index             Vertex index that will be modified.
vertex_pack :: proc(
    input             : [4]c.float,
    input_normalized  : bool,
    attr              : Attrib,
    layout            : ^Vertex_Layout,
    data              : rawptr,
    index             : c.uint32_t
) ---

// Unpack vertex attribute from vertex stream format.
// @param   out  output            Result of unpacking.
// @param    in  attr              Attribute to unpack.
// @param    in  layout            Vertex stream layout.
// @param    in  data              Source vertex stream from where data will be unpacked.
// @param    in  index             Vertex index that will be unpacked.
vertex_unpack :: proc(
    output            : [4]c.float,
    attr              : Attrib,
    layout            : ^Vertex_Layout,
    data              : rawptr,
    index             : c.uint32_t
) ---

// Converts vertex stream data from one vertex stream format to another.
// @param    in  dst_layout        Destination vertex stream layout.
// @param    in  dst_data          Destination vertex stream.
// @param    in  src_layout        Source vertex stream layout.
// @param    in  src_data          Source vertex stream data.
// @param    in  num               Number of vertices to convert from source to destination.
vertex_convert :: proc(
    dst_layout        : ^Vertex_Layout,
    dst_data          : rawptr,
    src_layout        : ^Vertex_Layout,
    src_data          : rawptr,
    num               : c.uint32_t
) ---

// Weld vertices.
// @param    in  output            Welded vertices remapping table. The size of buffer
//                                 must be the same as number of vertices.
// @param    in  layout            Vertex stream layout.
// @param    in  data              Vertex stream.
// @param    in  num               Number of vertices in vertex stream.
// @param    in  index32           Set to `true` if input indices are 32-bit.
// @param    in  epsilon           Error tolerance for vertex position comparison.
// @returns Number of unique vertices after vertex welding.
weld_vertices :: proc(
    output            : rawptr,
    layout            : ^Vertex_Layout,
    data              : rawptr,
    num               : c.uint32_t,
    index32           : bool,
    epsilon           : c.float
) -> c.uint32_t ---

// Convert index buffer for use with different primitive topologies.
// @param    in  conversion        Conversion type, see `TopologyConvert::Enum`.
// @param   out  dst               Destination index buffer. If this argument is NULL
//                                 function will return number of indices after conversion.
// @param    in  dst_size          Destination index buffer in bytes. It must be
//                                 large enough to contain output indices. If destination size is
//                                 insufficient index buffer will be truncated.
// @param    in  indices           Source indices.
// @param    in  num_indices       Number of input indices.
// @param    in  index32           Set to `true` if input indices are 32-bit.
// @returns Number of output indices after conversion.
topology_convert :: proc(
    conversion        : Topology_Convert,
    dst               : rawptr,
    dst_size          : c.uint32_t,
    indices           : rawptr,
    num_indices       : c.uint32_t,
    index32           : bool
) -> c.uint32_t ---

// Sort indices.
// @param    in  sort              Sort order, see `TopologySort::Enum`.
// @param   out  dst               Destination index buffer.
// @param    in  dst_size          Destination index buffer in bytes. It must be
//                                 large enough to contain output indices. If destination size is
//                                 insufficient index buffer will be truncated.
// @param    in  dir               Direction (vector must be normalized).
// @param    in  pos               Position.
// @param    in  vertices          Pointer to first vertex represented as
//                                 float x, y, z. Must contain at least number of vertices
//                                 referencende by index buffer.
// @param    in  stride            Vertex stride.
// @param    in  indices           Source indices.
// @param    in  num_indices       Number of input indices.
// @param    in  index32           Set to `true` if input indices are 32-bit.
topology_sort_tri_list :: proc(
    sort              : Topology_Sort,
    dst               : rawptr,
    dst_size          : c.uint32_t,
    dir               : [3]c.float,
    pos               : [3]c.float,
    vertices          : rawptr,
    stride            : c.uint32_t,
    indices           : rawptr,
    num_indices       : c.uint32_t,
    index32           : bool
) ---

// Returns supported backend API renderers.
// @param    in  max               Maximum number of elements in _enum array.
// @param inout  type              Array where supported renderers will be written.
// @returns Number of supported renderers.
get_supported_renderers :: proc(
    max               : c.uint8_t,
    type              : ^Renderer_Type
) -> c.uint8_t ---

// Returns name of renderer.
// @param    in  type              Renderer backend type. See: `bgfx::RendererType`
// @returns Name of renderer.
get_renderer_name :: proc(
    type              : Renderer_Type
) -> cstring ---

// Fill bgfx::Init struct with default values, before using it to initialize the library.
// @param    in  init              Pointer to structure to be initialized. See: `bgfx::Init` for more info.
init_ctor :: proc(
    init              : ^Init
) ---

// Initialize the bgfx library.
// @param    in  init              Initialization parameters. See: `bgfx::Init` for more info.
// @returns `true` if initialization was successful.
init :: proc(
    init              : ^Init
) -> bool ---

// Shutdown bgfx library.
shutdown :: proc() ---

// Reset graphic settings and back-buffer size.
// @attention This call doesn’t change the window size, it just resizes
//   the back-buffer. Your windowing code controls the window size.
// @param    in  width             Back-buffer width.
// @param    in  height            Back-buffer height.
// @param    in  flags             See: `BGFX_RESET_*` for more info.
//                                   - `BGFX_RESET_NONE` - No reset flags.
//                                   - `BGFX_RESET_FULLSCREEN` - Not supported yet.
//                                   - `BGFX_RESET_MSAA_X[2/4/8/16]` - Enable 2, 4, 8 or 16 x MSAA.
//                                   - `BGFX_RESET_VSYNC` - Enable V-Sync.
//                                   - `BGFX_RESET_MAXANISOTROPY` - Turn on/off max anisotropy.
//                                   - `BGFX_RESET_CAPTURE` - Begin screen capture.
//                                   - `BGFX_RESET_FLUSH_AFTER_RENDER` - Flush rendering after submitting to GPU.
//                                   - `BGFX_RESET_FLIP_AFTER_RENDER` - This flag  specifies where flip
//                                     occurs. Default behaviour is that flip occurs before rendering new
//                                     frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`.
//                                   - `BGFX_RESET_SRGB_BACKBUFFER` - Enable sRGB back-buffer.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
reset :: proc(
    width             : c.uint32_t,
    height            : c.uint32_t,
    flags             : c.uint32_t,
    format            : Texture_Format
) ---

// Advance to next frame. When using multithreaded renderer, this call
// just swaps internal buffers, kicks render thread, and returns. In
// singlethreaded renderer this call does frame rendering.
// @param    in  capture           Capture frame with graphics debugger.
// @returns Current frame number. This might be used in conjunction with double/multi buffering data outside the library and passing it to library via `bgfx::makeRef` calls.
frame :: proc(
    capture           : bool
) -> c.uint32_t ---

// Returns current renderer backend API type.
// @remarks
//   Library must be initialized.
// @returns Renderer backend type. See: `bgfx::RendererType`
get_renderer_type :: proc() -> Renderer_Type ---

// Returns renderer capabilities.
// @remarks
//   Library must be initialized.
// @returns Pointer to static `bgfx::Caps` structure.
get_caps :: proc() -> ^Caps ---

// Returns performance counters.
// @attention Pointer returned is valid until `bgfx::frame` is called.
get_stats :: proc() -> ^Stats ---

// Allocate buffer to pass to bgfx calls. Data will be freed inside bgfx.
// @param    in  size              Size to allocate.
// @returns Allocated memory.
alloc :: proc(
    size              : c.uint32_t
) -> ^Memory ---

// Allocate buffer and copy data into it. Data will be freed inside bgfx.
// @param    in  data              Pointer to data to be copied.
// @param    in  size              Size of data to be copied.
// @returns Allocated memory.
copy :: proc(
    data              : rawptr,
    size              : c.uint32_t
) -> ^Memory ---

// Make reference to data to pass to bgfx. Unlike `bgfx::alloc`, this call
// doesn't allocate memory for data. It just copies the _data pointer. You
// can pass `ReleaseFn` function pointer to release this memory after it's
// consumed, otherwise you must make sure _data is available for at least 2
// `bgfx::frame` calls. `ReleaseFn` function must be able to be called
// from any thread.
// @attention Data passed must be available for at least 2 `bgfx::frame` calls.
// @param    in  data              Pointer to data.
// @param    in  size              Size of data.
// @returns Referenced memory.
make_ref :: proc(
    data              : rawptr,
    size              : c.uint32_t
) -> ^Memory ---

// Make reference to data to pass to bgfx. Unlike `bgfx::alloc`, this call
// doesn't allocate memory for data. It just copies the _data pointer. You
// can pass `ReleaseFn` function pointer to release this memory after it's
// consumed, otherwise you must make sure _data is available for at least 2
// `bgfx::frame` calls. `ReleaseFn` function must be able to be called
// from any thread.
// @attention Data passed must be available for at least 2 `bgfx::frame` calls.
// @param    in  data              Pointer to data.
// @param    in  size              Size of data.
// @param    in  release_fn        Callback function to release memory after use.
// @param    in  user_data         User data to be passed to callback function.
// @returns Referenced memory.
make_ref_release :: proc(
    data              : rawptr,
    size              : c.uint32_t,
    release_fn        : Release_Fn,
    user_data         : rawptr
) -> ^Memory ---

// Set debug flags.
// @param    in  debug             Available flags:
//                                   - `BGFX_DEBUG_IFH` - Infinitely fast hardware. When this flag is set
//                                     all rendering calls will be skipped. This is useful when profiling
//                                     to quickly assess potential bottlenecks between CPU and GPU.
//                                   - `BGFX_DEBUG_PROFILER` - Enable profiler.
//                                   - `BGFX_DEBUG_STATS` - Display internal statistics.
//                                   - `BGFX_DEBUG_TEXT` - Display debug text.
//                                   - `BGFX_DEBUG_WIREFRAME` - Wireframe rendering. All rendering
//                                     primitives will be rendered as lines.
set_debug :: proc(
    debug             : c.uint32_t
) ---

// Clear internal debug text buffer.
// @param    in  attr              Background color.
// @param    in  small             Default 8x16 or 8x8 font.
dbg_text_clear :: proc(
    attr              : c.uint8_t,
    small             : bool
) ---

// Print formatted data to internal debug text character-buffer (VGA-compatible text mode).
// @param    in  x                 Position x from the left corner of the window.
// @param    in  y                 Position y from the top corner of the window.
// @param    in  attr              Color palette. Where top 4-bits represent index of background, and bottom
//                                 4-bits represent foreground color from standard VGA text palette (ANSI escape codes).
// @param    in  format            `printf` style format.
dbg_text_printf :: proc(
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    attr              : c.uint8_t,
    format            : cstring,
    #c_vararg args    : ..any
) ---

// Draw image into internal debug text buffer.
// @param    in  x                 Position x from the left corner of the window.
// @param    in  y                 Position y from the top corner of the window.
// @param    in  width             Image width.
// @param    in  height            Image height.
// @param    in  data              Raw image data (character/attribute raw encoding).
// @param    in  pitch             Image pitch in bytes.
dbg_text_image :: proc(
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t,
    data              : rawptr,
    pitch             : c.uint16_t
) ---

// Create static index buffer.
// @param    in  mem               Index buffer data.
// @param    in  flags             Buffer creation flags.
//                                   - `BGFX_BUFFER_NONE` - No flags.
//                                   - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
//                                   - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
//                                       is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
//                                   - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
//                                   - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
//                                       data is passed. If this flag is not specified, and more data is passed on update, the buffer
//                                       will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
//                                       buffers.
//                                   - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
//                                       index buffers.
create_index_buffer :: proc(
    mem               : ^Memory,
    flags             : c.uint16_t
) -> Index_Buffer_Handle ---

// Set static index buffer debug name.
// @param    in  handle            Static index buffer handle.
// @param    in  name              Static index buffer name.
// @param    in  len               Static index buffer name length (if length is INT32_MAX, it's expected
//                                 that _name is zero terminated string.
set_index_buffer_name :: proc(
    handle            : Index_Buffer_Handle,
    name              : cstring,
    len               : c.int32_t
) ---

// Destroy static index buffer.
// @param    in  handle            Static index buffer handle.
destroy_index_buffer :: proc(
    handle            : Index_Buffer_Handle
) ---

// Create vertex layout.
// @param    in  layout            Vertex layout.
create_vertex_layout :: proc(
    layout            : ^Vertex_Layout
) -> Vertex_Layout_Handle ---

// Destroy vertex layout.
// @param    in  layout_handle     Vertex layout handle.
destroy_vertex_layout :: proc(
    layout_handle     : Vertex_Layout_Handle
) ---

// Create static vertex buffer.
// @param    in  mem               Vertex buffer data.
// @param    in  layout            Vertex layout.
// @param    in  flags             Buffer creation flags.
//                                  - `BGFX_BUFFER_NONE` - No flags.
//                                  - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
//                                  - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
//                                      is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
//                                  - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
//                                  - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
//                                      data is passed. If this flag is not specified, and more data is passed on update, the buffer
//                                      will be trimmed to fit the existing buffer size. This flag has effect only on dynamic buffers.
//                                  - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on index buffers.
// @returns Static vertex buffer handle.
create_vertex_buffer :: proc(
    mem               : ^Memory,
    layout            : ^Vertex_Layout,
    flags             : c.uint16_t
) -> Vertex_Buffer_Handle ---

// Set static vertex buffer debug name.
// @param    in  handle            Static vertex buffer handle.
// @param    in  name              Static vertex buffer name.
// @param    in  len               Static vertex buffer name length (if length is INT32_MAX, it's expected
//                                 that _name is zero terminated string.
set_vertex_buffer_name :: proc(
    handle            : Vertex_Buffer_Handle,
    name              : cstring,
    len               : c.int32_t
) ---

// Destroy static vertex buffer.
// @param    in  handle            Static vertex buffer handle.
destroy_vertex_buffer :: proc(
    handle            : Vertex_Buffer_Handle
) ---

// Create empty dynamic index buffer.
// @param    in  num               Number of indices.
// @param    in  flags             Buffer creation flags.
//                                   - `BGFX_BUFFER_NONE` - No flags.
//                                   - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
//                                   - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
//                                       is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
//                                   - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
//                                   - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
//                                       data is passed. If this flag is not specified, and more data is passed on update, the buffer
//                                       will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
//                                       buffers.
//                                   - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
//                                       index buffers.
// @returns Dynamic index buffer handle.
create_dynamic_index_buffer :: proc(
    num               : c.uint32_t,
    flags             : c.uint16_t
) -> Dynamic_Index_Buffer_Handle ---

// Create a dynamic index buffer and initialize it.
// @param    in  mem               Index buffer data.
// @param    in  flags             Buffer creation flags.
//                                   - `BGFX_BUFFER_NONE` - No flags.
//                                   - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
//                                   - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
//                                       is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
//                                   - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
//                                   - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
//                                       data is passed. If this flag is not specified, and more data is passed on update, the buffer
//                                       will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
//                                       buffers.
//                                   - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
//                                       index buffers.
// @returns Dynamic index buffer handle.
create_dynamic_index_buffer_mem :: proc(
    mem               : ^Memory,
    flags             : c.uint16_t
) -> Dynamic_Index_Buffer_Handle ---

// Update dynamic index buffer.
// @param    in  handle            Dynamic index buffer handle.
// @param    in  start_index       Start index.
// @param    in  mem               Index buffer data.
update_dynamic_index_buffer :: proc(
    handle            : Dynamic_Index_Buffer_Handle,
    start_index       : c.uint32_t,
    mem               : ^Memory
) ---

// Destroy dynamic index buffer.
// @param    in  handle            Dynamic index buffer handle.
destroy_dynamic_index_buffer :: proc(
    handle            : Dynamic_Index_Buffer_Handle
) ---

// Create empty dynamic vertex buffer.
// @param    in  num               Number of vertices.
// @param    in  layout            Vertex layout.
// @param    in  flags             Buffer creation flags.
//                                   - `BGFX_BUFFER_NONE` - No flags.
//                                   - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
//                                   - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
//                                       is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
//                                   - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
//                                   - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
//                                       data is passed. If this flag is not specified, and more data is passed on update, the buffer
//                                       will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
//                                       buffers.
//                                   - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
//                                       index buffers.
// @returns Dynamic vertex buffer handle.
create_dynamic_vertex_buffer :: proc(
    num               : c.uint32_t,
    layout            : ^Vertex_Layout,
    flags             : c.uint16_t
) -> Dynamic_Vertex_Buffer_Handle ---

// Create dynamic vertex buffer and initialize it.
// @param    in  mem               Vertex buffer data.
// @param    in  layout            Vertex layout.
// @param    in  flags             Buffer creation flags.
//                                   - `BGFX_BUFFER_NONE` - No flags.
//                                   - `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
//                                   - `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
//                                       is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
//                                   - `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
//                                   - `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
//                                       data is passed. If this flag is not specified, and more data is passed on update, the buffer
//                                       will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
//                                       buffers.
//                                   - `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
//                                       index buffers.
// @returns Dynamic vertex buffer handle.
create_dynamic_vertex_buffer_mem :: proc(
    mem               : ^Memory,
    layout            : ^Vertex_Layout,
    flags             : c.uint16_t
) -> Dynamic_Vertex_Buffer_Handle ---

// Update dynamic vertex buffer.
// @param    in  handle            Dynamic vertex buffer handle.
// @param    in  start_vertex      Start vertex.
// @param    in  mem               Vertex buffer data.
update_dynamic_vertex_buffer :: proc(
    handle            : Dynamic_Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    mem               : ^Memory
) ---

// Destroy dynamic vertex buffer.
// @param    in  handle            Dynamic vertex buffer handle.
destroy_dynamic_vertex_buffer :: proc(
    handle            : Dynamic_Vertex_Buffer_Handle
) ---

// Returns number of requested or maximum available indices.
// @param    in  num               Number of required indices.
// @param    in  index32           Set to `true` if input indices will be 32-bit.
// @returns Number of requested or maximum available indices.
get_avail_transient_index_buffer :: proc(
    num               : c.uint32_t,
    index32           : bool
) -> c.uint32_t ---

// Returns number of requested or maximum available vertices.
// @param    in  num               Number of required vertices.
// @param    in  layout            Vertex layout.
// @returns Number of requested or maximum available vertices.
get_avail_transient_vertex_buffer :: proc(
    num               : c.uint32_t,
    layout            : ^Vertex_Layout
) -> c.uint32_t ---

// Returns number of requested or maximum available instance buffer slots.
// @param    in  num               Number of required instances.
// @param    in  stride            Stride per instance.
// @returns Number of requested or maximum available instance buffer slots.
get_avail_instance_data_buffer :: proc(
    num               : c.uint32_t,
    stride            : c.uint16_t
) -> c.uint32_t ---

// Allocate transient index buffer.
// @param   out  tib               TransientIndexBuffer structure will be filled, and will be valid
//                                 for the duration of frame, and can be reused for multiple draw
//                                 calls.
// @param    in  num               Number of indices to allocate.
// @param    in  index32           Set to `true` if input indices will be 32-bit.
alloc_transient_index_buffer :: proc(
    tib               : ^Transient_Index_Buffer,
    num               : c.uint32_t,
    index32           : bool
) ---

// Allocate transient vertex buffer.
// @param   out  tvb               TransientVertexBuffer structure will be filled, and will be valid
//                                 for the duration of frame, and can be reused for multiple draw
//                                 calls.
// @param    in  num               Number of vertices to allocate.
// @param    in  layout            Vertex layout.
alloc_transient_vertex_buffer :: proc(
    tvb               : ^Transient_Vertex_Buffer,
    num               : c.uint32_t,
    layout            : ^Vertex_Layout
) ---

// Check for required space and allocate transient vertex and index
// buffers. If both space requirements are satisfied function returns
// true.
// @param   out  tvb               TransientVertexBuffer structure will be filled, and will be valid
//                                 for the duration of frame, and can be reused for multiple draw
//                                 calls.
// @param    in  layout            Vertex layout.
// @param    in  num_vertices      Number of vertices to allocate.
// @param   out  tib               TransientIndexBuffer structure will be filled, and will be valid
//                                 for the duration of frame, and can be reused for multiple draw
//                                 calls.
// @param    in  num_indices       Number of indices to allocate.
// @param    in  index32           Set to `true` if input indices will be 32-bit.
alloc_transient_buffers :: proc(
    tvb               : ^Transient_Vertex_Buffer,
    layout            : ^Vertex_Layout,
    num_vertices      : c.uint32_t,
    tib               : ^Transient_Index_Buffer,
    num_indices       : c.uint32_t,
    index32           : bool
) -> bool ---

// Allocate instance data buffer.
// @param   out  idb               InstanceDataBuffer structure will be filled, and will be valid
//                                 for duration of frame, and can be reused for multiple draw
//                                 calls.
// @param    in  num               Number of instances.
// @param    in  stride            Instance stride. Must be multiple of 16.
alloc_instance_data_buffer :: proc(
    idb               : ^Instance_Data_Buffer,
    num               : c.uint32_t,
    stride            : c.uint16_t
) ---

// Create draw indirect buffer.
// @param    in  num               Number of indirect calls.
// @returns Indirect buffer handle.
create_indirect_buffer :: proc(
    num               : c.uint32_t
) -> Indirect_Buffer_Handle ---

// Destroy draw indirect buffer.
// @param    in  handle            Indirect buffer handle.
destroy_indirect_buffer :: proc(
    handle            : Indirect_Buffer_Handle
) ---

// Create shader from memory buffer.
// @remarks
//   Shader binary is obtained by compiling shader offline with shaderc command line tool.
// @param    in  mem               Shader binary.
// @returns Shader handle.
create_shader :: proc(
    mem               : ^Memory
) -> Shader_Handle ---

// Returns the number of uniforms and uniform handles used inside a shader.
// @remarks
//   Only non-predefined uniforms are returned.
// @param    in  handle            Shader handle.
// @param   out  uniforms          UniformHandle array where data will be stored.
// @param    in  max               Maximum capacity of array.
// @returns Number of uniforms used by shader.
get_shader_uniforms :: proc(
    handle            : Shader_Handle,
    uniforms          : ^Uniform_Handle,
    max               : c.uint16_t
) -> c.uint16_t ---

// Set shader debug name.
// @param    in  handle            Shader handle.
// @param    in  name              Shader name.
// @param    in  len               Shader name length (if length is INT32_MAX, it's expected
//                                 that _name is zero terminated string).
set_shader_name :: proc(
    handle            : Shader_Handle,
    name              : cstring,
    len               : c.int32_t
) ---

// Destroy shader.
// @remark Once a shader program is created with _handle,
//   it is safe to destroy that shader.
// @param    in  handle            Shader handle.
destroy_shader :: proc(
    handle            : Shader_Handle
) ---

// Create program with vertex and fragment shaders.
// @param    in  vsh               Vertex shader.
// @param    in  fsh               Fragment shader.
// @param    in  destroy_shaders   If true, shaders will be destroyed when program is destroyed.
// @returns Program handle if vertex shader output and fragment shader input are matching, otherwise returns invalid program handle.
create_program :: proc(
    vsh               : Shader_Handle,
    fsh               : Shader_Handle,
    destroy_shaders   : bool
) -> Program_Handle ---

// Create program with compute shader.
// @param    in  csh               Compute shader.
// @param    in  destroy_shaders   If true, shaders will be destroyed when program is destroyed.
// @returns Program handle.
create_compute_program :: proc(
    csh               : Shader_Handle,
    destroy_shaders   : bool
) -> Program_Handle ---

// Destroy program.
// @param    in  handle            Program handle.
destroy_program :: proc(
    handle            : Program_Handle
) ---

// Validate texture parameters.
// @param    in  depth             Depth dimension of volume texture.
// @param    in  cube_map          Indicates that texture contains cubemap.
// @param    in  num_layers        Number of layers in texture array.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
// @param    in  flags             Texture flags. See `BGFX_TEXTURE_*`.
// @returns True if a texture with the same parameters can be created.
is_texture_valid :: proc(
    depth             : c.uint16_t,
    cube_map          : bool,
    num_layers        : c.uint16_t,
    format            : Texture_Format,
    flags             : c.uint64_t
) -> bool ---

// Validate frame buffer parameters.
// @param    in  num               Number of attachments.
// @param    in  attachment        Attachment texture info. See: `bgfx::Attachment`.
// @returns True if a frame buffer with the same parameters can be created.
is_frame_buffer_valid :: proc(
    num               : c.uint8_t,
    attachment        : ^Attachment
) -> bool ---

// Calculate amount of memory required for texture.
// @param   out  info              Resulting texture info structure. See: `TextureInfo`.
// @param    in  width             Width.
// @param    in  height            Height.
// @param    in  depth             Depth dimension of volume texture.
// @param    in  cube_map          Indicates that texture contains cubemap.
// @param    in  has_mips          Indicates that texture contains full mip-map chain.
// @param    in  num_layers        Number of layers in texture array.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
calc_texture_size :: proc(
    info              : ^Texture_Info,
    width             : c.uint16_t,
    height            : c.uint16_t,
    depth             : c.uint16_t,
    cube_map          : bool,
    has_mips          : bool,
    num_layers        : c.uint16_t,
    format            : Texture_Format
) ---

// Create texture from memory buffer.
// @param    in  mem               DDS, KTX or PVR texture binary data.
// @param    in  flags             Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
//                                 flags. Default texture sampling mode is linear, and wrap mode is repeat.
//                                 - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                   mode.
//                                 - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                   sampling.
// @param    in  skip              Skip top level mips when parsing texture.
// @param   out  info              When non-`NULL` is specified it returns parsed texture information.
// @returns Texture handle.
create_texture :: proc(
    mem               : ^Memory,
    flags             : c.uint64_t,
    skip              : c.uint8_t,
    info              : ^Texture_Info
) -> Texture_Handle ---

// Create 2D texture.
// @param    in  width             Width.
// @param    in  height            Height.
// @param    in  has_mips          Indicates that texture contains full mip-map chain.
// @param    in  num_layers        Number of layers in texture array. Must be 1 if caps
//                                 `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
// @param    in  flags             Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
//                                 flags. Default texture sampling mode is linear, and wrap mode is repeat.
//                                 - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                   mode.
//                                 - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                   sampling.
// @param    in  mem               Texture data. If `_mem` is non-NULL, created texture will be immutable. If
//                                 `_mem` is NULL content of the texture is uninitialized. When `_numLayers` is more than
//                                 1, expected memory layout is texture and all mips together for each array element.
// @returns Texture handle.
create_texture_2d :: proc(
    width             : c.uint16_t,
    height            : c.uint16_t,
    has_mips          : bool,
    num_layers        : c.uint16_t,
    format            : Texture_Format,
    flags             : c.uint64_t,
    mem               : ^Memory
) -> Texture_Handle ---

// Create texture with size based on back-buffer ratio. Texture will maintain ratio
// if back buffer resolution changes.
// @param    in  ratio             Texture size in respect to back-buffer size. See: `BackbufferRatio::Enum`.
// @param    in  has_mips          Indicates that texture contains full mip-map chain.
// @param    in  num_layers        Number of layers in texture array. Must be 1 if caps
//                                 `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
// @param    in  flags             Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
//                                 flags. Default texture sampling mode is linear, and wrap mode is repeat.
//                                 - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                   mode.
//                                 - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                   sampling.
// @returns Texture handle.
create_texture_2d_scaled :: proc(
    ratio             : Backbuffer_Ratio,
    has_mips          : bool,
    num_layers        : c.uint16_t,
    format            : Texture_Format,
    flags             : c.uint64_t
) -> Texture_Handle ---

// Create 3D texture.
// @param    in  width             Width.
// @param    in  height            Height.
// @param    in  depth             Depth.
// @param    in  has_mips          Indicates that texture contains full mip-map chain.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
// @param    in  flags             Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
//                                 flags. Default texture sampling mode is linear, and wrap mode is repeat.
//                                 - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                   mode.
//                                 - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                   sampling.
// @param    in  mem               Texture data. If `_mem` is non-NULL, created texture will be immutable. If
//                                 `_mem` is NULL content of the texture is uninitialized. When `_numLayers` is more than
//                                 1, expected memory layout is texture and all mips together for each array element.
// @returns Texture handle.
create_texture_3d :: proc(
    width             : c.uint16_t,
    height            : c.uint16_t,
    depth             : c.uint16_t,
    has_mips          : bool,
    format            : Texture_Format,
    flags             : c.uint64_t,
    mem               : ^Memory
) -> Texture_Handle ---

// Create Cube texture.
// @param    in  size              Cube side size.
// @param    in  has_mips          Indicates that texture contains full mip-map chain.
// @param    in  num_layers        Number of layers in texture array. Must be 1 if caps
//                                 `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
// @param    in  flags             Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
//                                 flags. Default texture sampling mode is linear, and wrap mode is repeat.
//                                 - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                   mode.
//                                 - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                   sampling.
// @param    in  mem               Texture data. If `_mem` is non-NULL, created texture will be immutable. If
//                                 `_mem` is NULL content of the texture is uninitialized. When `_numLayers` is more than
//                                 1, expected memory layout is texture and all mips together for each array element.
// @returns Texture handle.
create_texture_cube :: proc(
    size              : c.uint16_t,
    has_mips          : bool,
    num_layers        : c.uint16_t,
    format            : Texture_Format,
    flags             : c.uint64_t,
    mem               : ^Memory
) -> Texture_Handle ---

// Update 2D texture.
// @attention It's valid to update only mutable texture. See `bgfx::createTexture2D` for more info.
// @param    in  handle            Texture handle.
// @param    in  layer             Layer in texture array.
// @param    in  mip               Mip level.
// @param    in  x                 X offset in texture.
// @param    in  y                 Y offset in texture.
// @param    in  width             Width of texture block.
// @param    in  height            Height of texture block.
// @param    in  mem               Texture update data.
// @param    in  pitch             Pitch of input image (bytes). When _pitch is set to
//                                 UINT16_MAX, it will be calculated internally based on _width.
update_texture_2d :: proc(
    handle            : Texture_Handle,
    layer             : c.uint16_t,
    mip               : c.uint8_t,
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t,
    mem               : ^Memory,
    pitch             : c.uint16_t
) ---

// Update 3D texture.
// @attention It's valid to update only mutable texture. See `bgfx::createTexture3D` for more info.
// @param    in  handle            Texture handle.
// @param    in  mip               Mip level.
// @param    in  x                 X offset in texture.
// @param    in  y                 Y offset in texture.
// @param    in  z                 Z offset in texture.
// @param    in  width             Width of texture block.
// @param    in  height            Height of texture block.
// @param    in  depth             Depth of texture block.
// @param    in  mem               Texture update data.
update_texture_3d :: proc(
    handle            : Texture_Handle,
    mip               : c.uint8_t,
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    z                 : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t,
    depth             : c.uint16_t,
    mem               : ^Memory
) ---

// Update Cube texture.
// @attention It's valid to update only mutable texture. See `bgfx::createTextureCube` for more info.
// @param    in  handle            Texture handle.
// @param    in  layer             Layer in texture array.
// @param    in  side              Cubemap side `BGFX_CUBE_MAP_<POSITIVE or NEGATIVE>_<X, Y or Z>`,
//                                   where 0 is +X, 1 is -X, 2 is +Y, 3 is -Y, 4 is +Z, and 5 is -Z.
//                                                  +----------+
//                                                  |-z       2|
//                                                  | ^  +y    |
//                                                  | |        |    Unfolded cube:
//                                                  | +---->+x |
//                                       +----------+----------+----------+----------+
//                                       |+y       1|+y       4|+y       0|+y       5|
//                                       | ^  -x    | ^  +z    | ^  +x    | ^  -z    |
//                                       | |        | |        | |        | |        |
//                                       | +---->+z | +---->+x | +---->-z | +---->-x |
//                                       +----------+----------+----------+----------+
//                                                  |+z       3|
//                                                  | ^  -y    |
//                                                  | |        |
//                                                  | +---->+x |
//                                                  +----------+
// @param    in  mip               Mip level.
// @param    in  x                 X offset in texture.
// @param    in  y                 Y offset in texture.
// @param    in  width             Width of texture block.
// @param    in  height            Height of texture block.
// @param    in  mem               Texture update data.
// @param    in  pitch             Pitch of input image (bytes). When _pitch is set to
//                                 UINT16_MAX, it will be calculated internally based on _width.
update_texture_cube :: proc(
    handle            : Texture_Handle,
    layer             : c.uint16_t,
    side              : c.uint8_t,
    mip               : c.uint8_t,
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t,
    mem               : ^Memory,
    pitch             : c.uint16_t
) ---

// Read back texture content.
// @attention Texture must be created with `BGFX_TEXTURE_READ_BACK` flag.
// @attention Availability depends on: `BGFX_CAPS_TEXTURE_READ_BACK`.
// @param    in  handle            Texture handle.
// @param    in  data              Destination buffer.
// @param    in  mip               Mip level.
// @returns Frame number when the result will be available. See: `bgfx::frame`.
read_texture :: proc(
    handle            : Texture_Handle,
    data              : rawptr,
    mip               : c.uint8_t
) -> c.uint32_t ---

// Set texture debug name.
// @param    in  handle            Texture handle.
// @param    in  name              Texture name.
// @param    in  len               Texture name length (if length is INT32_MAX, it's expected
//                                 that _name is zero terminated string.
set_texture_name :: proc(
    handle            : Texture_Handle,
    name              : cstring,
    len               : c.int32_t
) ---

// Returns texture direct access pointer.
// @attention Availability depends on: `BGFX_CAPS_TEXTURE_DIRECT_ACCESS`. This feature
//   is available on GPUs that have unified memory architecture (UMA) support.
// @param    in  handle            Texture handle.
// @returns Pointer to texture memory. If returned pointer is `NULL` direct access is not available for this texture. If pointer is `UINTPTR_MAX` sentinel value it means texture is pending creation. Pointer returned can be cached and it will be valid until texture is destroyed.
get_direct_access_ptr :: proc(
    handle            : Texture_Handle
) ---

// Destroy texture.
// @param    in  handle            Texture handle.
destroy_texture :: proc(
    handle            : Texture_Handle
) ---

// Create frame buffer (simple).
// @param    in  width             Texture width.
// @param    in  height            Texture height.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
// @param    in  texture_flags     Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
//                                 flags. Default texture sampling mode is linear, and wrap mode is repeat.
//                                 - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                   mode.
//                                 - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                   sampling.
// @returns Frame buffer handle.
create_frame_buffer :: proc(
    width             : c.uint16_t,
    height            : c.uint16_t,
    format            : Texture_Format,
    texture_flags     : c.uint64_t
) -> Frame_Buffer_Handle ---

// Create frame buffer with size based on back-buffer ratio. Frame buffer will maintain ratio
// if back buffer resolution changes.
// @param    in  ratio             Frame buffer size in respect to back-buffer size. See:
//                                 `BackbufferRatio::Enum`.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
// @param    in  texture_flags     Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
//                                 flags. Default texture sampling mode is linear, and wrap mode is repeat.
//                                 - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                   mode.
//                                 - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                   sampling.
// @returns Frame buffer handle.
create_frame_buffer_scaled :: proc(
    ratio             : Backbuffer_Ratio,
    format            : Texture_Format,
    texture_flags     : c.uint64_t
) -> Frame_Buffer_Handle ---

// Create MRT frame buffer from texture handles (simple).
// @param    in  num               Number of texture handles.
// @param    in  handles           Texture attachments.
// @param    in  destroy_texture   If true, textures will be destroyed when
//                                 frame buffer is destroyed.
// @returns Frame buffer handle.
create_frame_buffer_from_handles :: proc(
    num               : c.uint8_t,
    handles           : ^Texture_Handle,
    destroy_texture   : bool
) -> Frame_Buffer_Handle ---

// Create MRT frame buffer from texture handles with specific layer and
// mip level.
// @param    in  num               Number of attachments.
// @param    in  attachment        Attachment texture info. See: `bgfx::Attachment`.
// @param    in  destroy_texture   If true, textures will be destroyed when
//                                 frame buffer is destroyed.
// @returns Frame buffer handle.
create_frame_buffer_from_attachment :: proc(
    num               : c.uint8_t,
    attachment        : ^Attachment,
    destroy_texture   : bool
) -> Frame_Buffer_Handle ---

// Create frame buffer for multiple window rendering.
// @remarks
//   Frame buffer cannot be used for sampling.
// @attention Availability depends on: `BGFX_CAPS_SWAP_CHAIN`.
// @param    in  nwh               OS' target native window handle.
// @param    in  width             Window back buffer width.
// @param    in  height            Window back buffer height.
// @param    in  format            Window back buffer color format.
// @param    in  depth_format      Window back buffer depth format.
// @returns Frame buffer handle.
create_frame_buffer_from_nwh :: proc(
    nwh               : rawptr,
    width             : c.uint16_t,
    height            : c.uint16_t,
    format            : Texture_Format,
    depth_format      : Texture_Format
) -> Frame_Buffer_Handle ---

// Set frame buffer debug name.
// @param    in  handle            Frame buffer handle.
// @param    in  name              Frame buffer name.
// @param    in  len               Frame buffer name length (if length is INT32_MAX, it's expected
//                                 that _name is zero terminated string.
set_frame_buffer_name :: proc(
    handle            : Frame_Buffer_Handle,
    name              : cstring,
    len               : c.int32_t
) ---

// Obtain texture handle of frame buffer attachment.
// @param    in  handle            Frame buffer handle.
get_texture :: proc(
    handle            : Frame_Buffer_Handle,
    attachment        : c.uint8_t
) -> Texture_Handle ---

// Destroy frame buffer.
// @param    in  handle            Frame buffer handle.
destroy_frame_buffer :: proc(
    handle            : Frame_Buffer_Handle
) ---

// Create shader uniform parameter.
// @remarks
//   1. Uniform names are unique. It's valid to call `bgfx::createUniform`
//      multiple times with the same uniform name. The library will always
//      return the same handle, but the handle reference count will be
//      incremented. This means that the same number of `bgfx::destroyUniform`
//      must be called to properly destroy the uniform.
//   2. Predefined uniforms (declared in `bgfx_shader.sh`):
//      - `u_viewRect vec4(x, y, width, height)` - view rectangle for current
//        view, in pixels.
//      - `u_viewTexel vec4(1.0/width, 1.0/height, undef, undef)` - inverse
//        width and height
//      - `u_view mat4` - view matrix
//      - `u_invView mat4` - inverted view matrix
//      - `u_proj mat4` - projection matrix
//      - `u_invProj mat4` - inverted projection matrix
//      - `u_viewProj mat4` - concatenated view projection matrix
//      - `u_invViewProj mat4` - concatenated inverted view projection matrix
//      - `u_model mat4[BGFX_CONFIG_MAX_BONES]` - array of model matrices.
//      - `u_modelView mat4` - concatenated model view matrix, only first
//        model matrix from array is used.
//      - `u_modelViewProj mat4` - concatenated model view projection matrix.
//      - `u_alphaRef float` - alpha reference value for alpha test.
// @param    in  name              Uniform name in shader.
// @param    in  type              Type of uniform (See: `bgfx::UniformType`).
// @param    in  num               Number of elements in array.
// @returns Handle to uniform object.
create_uniform :: proc(
    name              : cstring,
    type              : Uniform_Type,
    num               : c.uint16_t
) -> Uniform_Handle ---

// Retrieve uniform info.
// @param    in  handle            Handle to uniform object.
// @param   out  info              Uniform info.
get_uniform_info :: proc(
    handle            : Uniform_Handle,
    info              : ^Uniform_Info
) ---

// Destroy shader uniform parameter.
// @param    in  handle            Handle to uniform object.
destroy_uniform :: proc(
    handle            : Uniform_Handle
) ---

// Create occlusion query.
// @returns Handle to occlusion query object.
create_occlusion_query :: proc() -> Occlusion_Query_Handle ---

// Retrieve occlusion query result from previous frame.
// @param    in  handle            Handle to occlusion query object.
// @param   out  result            Number of pixels that passed test. This argument
//                                 can be `NULL` if result of occlusion query is not needed.
// @returns Occlusion query result.
get_result :: proc(
    handle            : Occlusion_Query_Handle,
    result            : ^c.int32_t
) -> Occlusion_Query_Result ---

// Destroy occlusion query.
// @param    in  handle            Handle to occlusion query object.
destroy_occlusion_query :: proc(
    handle            : Occlusion_Query_Handle
) ---

// Set palette color value.
// @param    in  index             Index into palette.
// @param    in  rgba              RGBA floating point values.
set_palette_color :: proc(
    index             : c.uint8_t,
    rgba              : [4]c.float
) ---

// Set palette color value.
// @param    in  index             Index into palette.
// @param    in  rgba              Packed 32-bit RGBA value.
set_palette_color_rgba8 :: proc(
    index             : c.uint8_t,
    rgba              : c.uint32_t
) ---

// Set view name.
// @remarks
//   This is debug only feature.
//   In graphics debugger view name will appear as:
//       "nnnc <view name>"
//        ^  ^ ^
//        |  +--- compute (C)
//        +------ view id
// @param    in  id                View id.
// @param    in  name              View name.
// @param    in  len               View name length (if length is INT32_MAX, it's expected
//                                 that _name is zero terminated string.
set_view_name :: proc(
    id                : View_Id,
    name              : cstring,
    len               : c.int32_t
) ---

// Set view rectangle. Draw primitive outside view will be clipped.
// @param    in  id                View id.
// @param    in  x                 Position x from the left corner of the window.
// @param    in  y                 Position y from the top corner of the window.
// @param    in  width             Width of view port region.
// @param    in  height            Height of view port region.
set_view_rect :: proc(
    id                : View_Id,
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t
) ---

// Set view rectangle. Draw primitive outside view will be clipped.
// @param    in  id                View id.
// @param    in  x                 Position x from the left corner of the window.
// @param    in  y                 Position y from the top corner of the window.
// @param    in  ratio             Width and height will be set in respect to back-buffer size.
//                                 See: `BackbufferRatio::Enum`.
set_view_rect_ratio :: proc(
    id                : View_Id,
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    ratio             : Backbuffer_Ratio
) ---

// Set view scissor. Draw primitive outside view will be clipped. When
// _x, _y, _width and _height are set to 0, scissor will be disabled.
// @param    in  id                View id.
// @param    in  x                 Position x from the left corner of the window.
// @param    in  y                 Position y from the top corner of the window.
// @param    in  width             Width of view scissor region.
// @param    in  height            Height of view scissor region.
set_view_scissor :: proc(
    id                : View_Id,
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t
) ---

// Set view clear flags.
// @param    in  id                View id.
// @param    in  flags             Clear flags. Use `BGFX_CLEAR_NONE` to remove any clear
//                                 operation. See: `BGFX_CLEAR_*`.
// @param    in  rgba              Color clear value.
// @param    in  depth             Depth clear value.
// @param    in  stencil           Stencil clear value.
set_view_clear :: proc(
    id                : View_Id,
    flags             : c.uint16_t,
    rgba              : c.uint32_t,
    depth             : c.float,
    stencil           : c.uint8_t
) ---

// Set view clear flags with different clear color for each
// frame buffer texture. `bgfx::setPaletteColor` must be used to set up a
// clear color palette.
// @param    in  id                View id.
// @param    in  flags             Clear flags. Use `BGFX_CLEAR_NONE` to remove any clear
//                                 operation. See: `BGFX_CLEAR_*`.
// @param    in  depth             Depth clear value.
// @param    in  stencil           Stencil clear value.
// @param    in  c0                Palette index for frame buffer attachment 0.
// @param    in  c1                Palette index for frame buffer attachment 1.
// @param    in  c2                Palette index for frame buffer attachment 2.
// @param    in  c3                Palette index for frame buffer attachment 3.
// @param    in  c4                Palette index for frame buffer attachment 4.
// @param    in  c5                Palette index for frame buffer attachment 5.
// @param    in  c6                Palette index for frame buffer attachment 6.
// @param    in  c7                Palette index for frame buffer attachment 7.
set_view_clear_mrt :: proc(
    id                : View_Id,
    flags             : c.uint16_t,
    depth             : c.float,
    stencil           : c.uint8_t,
    c0                : c.uint8_t,
    c1                : c.uint8_t,
    c2                : c.uint8_t,
    c3                : c.uint8_t,
    c4                : c.uint8_t,
    c5                : c.uint8_t,
    c6                : c.uint8_t,
    c7                : c.uint8_t
) ---

// Set view sorting mode.
// @remarks
//   View mode must be set prior calling `bgfx::submit` for the view.
// @param    in  id                View id.
// @param    in  mode              View sort mode. See `ViewMode::Enum`.
set_view_mode :: proc(
    id                : View_Id,
    mode              : View_Mode
) ---

// Set view frame buffer.
// @remarks
//   Not persistent after `bgfx::reset` call.
// @param    in  id                View id.
// @param    in  handle            Frame buffer handle. Passing `BGFX_INVALID_HANDLE` as
//                                 frame buffer handle will draw primitives from this view into
//                                 default back buffer.
set_view_frame_buffer :: proc(
    id                : View_Id,
    handle            : Frame_Buffer_Handle
) ---

// Set view's view matrix and projection matrix,
// all draw primitives in this view will use these two matrices.
// @param    in  id                View id.
// @param    in  view              View matrix.
// @param    in  proj              Projection matrix.
set_view_transform :: proc(
    id                : View_Id,
    view              : rawptr,
    proj              : rawptr
) ---

// Post submit view reordering.
// @param    in  id                First view id.
// @param    in  num               Number of views to remap.
// @param    in  order             View remap id table. Passing `NULL` will reset view ids
//                                 to default state.
set_view_order :: proc(
    id                : View_Id,
    num               : c.uint16_t,
    order             : ^View_Id
) ---

// Reset all view settings to default.
reset_view :: proc(
    id                : View_Id
) ---

// Begin submitting draw calls from thread.
// @param    in  for_thread        Explicitly request an encoder for a worker thread.
// @returns Encoder.
encoder_begin :: proc(
    for_thread        : bool
) -> ^Encoder ---

// End submitting draw calls from thread.
// @param    in  encoder           Encoder.
encoder_end :: proc(
    encoder           : ^Encoder
) ---

// Sets a debug marker. This allows you to group graphics calls together for easy browsing in
// graphics debugging tools.
// @param    in  name              Marker name.
// @param    in  len               Marker name length (if length is INT32_MAX, it's expected
//                                 that _name is zero terminated string.
encoder_set_marker :: proc(
    this              : ^Encoder,
    name              : cstring,
    len               : c.int32_t
) ---

// Set render states for draw primitive.
// @remarks
//   1. To set up more complex states use:
//      `BGFX_STATE_ALPHA_REF(_ref)`,
//      `BGFX_STATE_POINT_SIZE(_size)`,
//      `BGFX_STATE_BLEND_FUNC(_src, _dst)`,
//      `BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)`,
//      `BGFX_STATE_BLEND_EQUATION(_equation)`,
//      `BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)`
//   2. `BGFX_STATE_BLEND_EQUATION_ADD` is set when no other blend
//      equation is specified.
// @param    in  state             State flags. Default state for primitive type is
//                                   triangles. See: `BGFX_STATE_DEFAULT`.
//                                   - `BGFX_STATE_DEPTH_TEST_*` - Depth test function.
//                                   - `BGFX_STATE_BLEND_*` - See remark 1 about BGFX_STATE_BLEND_FUNC.
//                                   - `BGFX_STATE_BLEND_EQUATION_*` - See remark 2.
//                                   - `BGFX_STATE_CULL_*` - Backface culling mode.
//                                   - `BGFX_STATE_WRITE_*` - Enable R, G, B, A or Z write.
//                                   - `BGFX_STATE_MSAA` - Enable hardware multisample antialiasing.
//                                   - `BGFX_STATE_PT_[TRISTRIP/LINES/POINTS]` - Primitive type.
// @param    in  rgba              Sets blend factor used by `BGFX_STATE_BLEND_FACTOR` and
//                                   `BGFX_STATE_BLEND_INV_FACTOR` blend modes.
encoder_set_state :: proc(
    this              : ^Encoder,
    state             : c.uint64_t,
    rgba              : c.uint32_t
) ---

// Set condition for rendering.
// @param    in  handle            Occlusion query handle.
// @param    in  visible           Render if occlusion query is visible.
encoder_set_condition :: proc(
    this              : ^Encoder,
    handle            : Occlusion_Query_Handle,
    visible           : bool
) ---

// Set stencil test state.
// @param    in  fstencil          Front stencil state.
// @param    in  bstencil          Back stencil state. If back is set to `BGFX_STENCIL_NONE`
//                                 _fstencil is applied to both front and back facing primitives.
encoder_set_stencil :: proc(
    this              : ^Encoder,
    fstencil          : c.uint32_t,
    bstencil          : c.uint32_t
) ---

// Set scissor for draw primitive.
// @remark
//   To scissor for all primitives in view see `bgfx::setViewScissor`.
// @param    in  x                 Position x from the left corner of the window.
// @param    in  y                 Position y from the top corner of the window.
// @param    in  width             Width of view scissor region.
// @param    in  height            Height of view scissor region.
// @returns Scissor cache index.
encoder_set_scissor :: proc(
    this              : ^Encoder,
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t
) -> c.uint16_t ---

// Set scissor from cache for draw primitive.
// @remark
//   To scissor for all primitives in view see `bgfx::setViewScissor`.
// @param    in  cache             Index in scissor cache.
encoder_set_scissor_cached :: proc(
    this              : ^Encoder,
    cache             : c.uint16_t
) ---

// Set model matrix for draw primitive. If it is not called,
// the model will be rendered with an identity model matrix.
// @param    in  mtx               Pointer to first matrix in array.
// @param    in  num               Number of matrices in array.
// @returns Index into matrix cache in case the same model matrix has to be used for other draw primitive call.
encoder_set_transform :: proc(
    this              : ^Encoder,
    mtx               : rawptr,
    num               : c.uint16_t
) -> c.uint32_t ---

//  Set model matrix from matrix cache for draw primitive.
// @param    in  cache             Index in matrix cache.
// @param    in  num               Number of matrices from cache.
encoder_set_transform_cached :: proc(
    this              : ^Encoder,
    cache             : c.uint32_t,
    num               : c.uint16_t
) ---

// Reserve matrices in internal matrix cache.
// @attention Pointer returned can be modified until `bgfx::frame` is called.
// @param   out  transform         Pointer to `Transform` structure.
// @param    in  num               Number of matrices.
// @returns Index in matrix cache.
encoder_alloc_transform :: proc(
    this              : ^Encoder,
    transform         : ^Transform,
    num               : c.uint16_t
) -> c.uint32_t ---

// Set shader uniform parameter for draw primitive.
// @param    in  handle            Uniform.
// @param    in  value             Pointer to uniform data.
// @param    in  num               Number of elements. Passing `UINT16_MAX` will
//                                 use the _num passed on uniform creation.
encoder_set_uniform :: proc(
    this              : ^Encoder,
    handle            : Uniform_Handle,
    value             : rawptr,
    num               : c.uint16_t
) ---

// Set index buffer for draw primitive.
// @param    in  handle            Index buffer.
// @param    in  first_index       First index to render.
// @param    in  num_indices       Number of indices to render.
encoder_set_index_buffer :: proc(
    this              : ^Encoder,
    handle            : Index_Buffer_Handle,
    first_index       : c.uint32_t,
    num_indices       : c.uint32_t
) ---

// Set index buffer for draw primitive.
// @param    in  handle            Dynamic index buffer.
// @param    in  first_index       First index to render.
// @param    in  num_indices       Number of indices to render.
encoder_set_dynamic_index_buffer :: proc(
    this              : ^Encoder,
    handle            : Dynamic_Index_Buffer_Handle,
    first_index       : c.uint32_t,
    num_indices       : c.uint32_t
) ---

// Set index buffer for draw primitive.
// @param    in  tib               Transient index buffer.
// @param    in  first_index       First index to render.
// @param    in  num_indices       Number of indices to render.
encoder_set_transient_index_buffer :: proc(
    this              : ^Encoder,
    tib               : ^Transient_Index_Buffer,
    first_index       : c.uint32_t,
    num_indices       : c.uint32_t
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  handle            Vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
encoder_set_vertex_buffer :: proc(
    this              : ^Encoder,
    stream            : c.uint8_t,
    handle            : Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  handle            Vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
// @param    in  layout_handle     Vertex layout for aliasing vertex buffer. If invalid
//                                 handle is used, vertex layout used for creation
//                                 of vertex buffer will be used.
encoder_set_vertex_buffer_with_layout :: proc(
    this              : ^Encoder,
    stream            : c.uint8_t,
    handle            : Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t,
    layout_handle     : Vertex_Layout_Handle
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  handle            Dynamic vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
encoder_set_dynamic_vertex_buffer :: proc(
    this              : ^Encoder,
    stream            : c.uint8_t,
    handle            : Dynamic_Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t
) ---

// @param    in  stream            Vertex stream.
// @param    in  handle            Dynamic vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
// @param    in  layout_handle     Vertex layout for aliasing vertex buffer. If invalid
//                                 handle is used, vertex layout used for creation
//                                 of vertex buffer will be used.
encoder_set_dynamic_vertex_buffer_with_layout :: proc(
    this              : ^Encoder,
    stream            : c.uint8_t,
    handle            : Dynamic_Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t,
    layout_handle     : Vertex_Layout_Handle
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  tvb               Transient vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
encoder_set_transient_vertex_buffer :: proc(
    this              : ^Encoder,
    stream            : c.uint8_t,
    tvb               : ^Transient_Vertex_Buffer,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  tvb               Transient vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
// @param    in  layout_handle     Vertex layout for aliasing vertex buffer. If invalid
//                                 handle is used, vertex layout used for creation
//                                 of vertex buffer will be used.
encoder_set_transient_vertex_buffer_with_layout :: proc(
    this              : ^Encoder,
    stream            : c.uint8_t,
    tvb               : ^Transient_Vertex_Buffer,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t,
    layout_handle     : Vertex_Layout_Handle
) ---

// Set number of vertices for auto generated vertices use in conjunction
// with gl_VertexID.
// @attention Availability depends on: `BGFX_CAPS_VERTEX_ID`.
// @param    in  num_vertices      Number of vertices.
encoder_set_vertex_count :: proc(
    this              : ^Encoder,
    num_vertices      : c.uint32_t
) ---

// Set instance data buffer for draw primitive.
// @param    in  idb               Transient instance data buffer.
// @param    in  start             First instance data.
// @param    in  num               Number of data instances.
encoder_set_instance_data_buffer :: proc(
    this              : ^Encoder,
    idb               : ^Instance_Data_Buffer,
    start             : c.uint32_t,
    num               : c.uint32_t
) ---

// Set instance data buffer for draw primitive.
// @param    in  handle            Vertex buffer.
// @param    in  start_vertex      First instance data.
// @param    in  num               Number of data instances.
encoder_set_instance_data_from_vertex_buffer :: proc(
    this              : ^Encoder,
    handle            : Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num               : c.uint32_t
) ---

// Set instance data buffer for draw primitive.
// @param    in  handle            Dynamic vertex buffer.
// @param    in  start_vertex      First instance data.
// @param    in  num               Number of data instances.
encoder_set_instance_data_from_dynamic_vertex_buffer :: proc(
    this              : ^Encoder,
    handle            : Dynamic_Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num               : c.uint32_t
) ---

// Set number of instances for auto generated instances use in conjunction
// with gl_InstanceID.
// @attention Availability depends on: `BGFX_CAPS_VERTEX_ID`.
encoder_set_instance_count :: proc(
    this              : ^Encoder,
    num_instances     : c.uint32_t
) ---

// Set texture stage for draw primitive.
// @param    in  stage             Texture unit.
// @param    in  sampler           Program sampler.
// @param    in  handle            Texture handle.
// @param    in  flags             Texture sampling mode. Default value UINT32_MAX uses
//                                   texture sampling settings from the texture.
//                                   - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                     mode.
//                                   - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                     sampling.
encoder_set_texture :: proc(
    this              : ^Encoder,
    stage             : c.uint8_t,
    sampler           : Uniform_Handle,
    handle            : Texture_Handle,
    flags             : c.uint32_t
) ---

// Submit an empty primitive for rendering. Uniforms and draw state
// will be applied but no geometry will be submitted. Useful in cases
// when no other draw/compute primitive is submitted to view, but it's
// desired to execute clear view.
// @remark
//   These empty draw calls will sort before ordinary draw calls.
// @param    in  id                View id.
encoder_touch :: proc(
    this              : ^Encoder,
    id                : View_Id
) ---

// Submit primitive for rendering.
// @param    in  id                View id.
// @param    in  program           Program.
// @param    in  depth             Depth for sorting.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
encoder_submit :: proc(
    this              : ^Encoder,
    id                : View_Id,
    program           : Program_Handle,
    depth             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Submit primitive with occlusion query for rendering.
// @param    in  id                View id.
// @param    in  program           Program.
// @param    in  occlusion_query   Occlusion query.
// @param    in  depth             Depth for sorting.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
encoder_submit_occlusion_query :: proc(
    this              : ^Encoder,
    id                : View_Id,
    program           : Program_Handle,
    occlusion_query   : Occlusion_Query_Handle,
    depth             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Submit primitive for rendering with index and instance data info from
// indirect buffer.
// @attention Availability depends on: `BGFX_CAPS_DRAW_INDIRECT`.
// @param    in  id                View id.
// @param    in  program           Program.
// @param    in  indirect_handle   Indirect buffer.
// @param    in  start             First element in indirect buffer.
// @param    in  num               Number of draws.
// @param    in  depth             Depth for sorting.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
encoder_submit_indirect :: proc(
    this              : ^Encoder,
    id                : View_Id,
    program           : Program_Handle,
    indirect_handle   : Indirect_Buffer_Handle,
    start             : c.uint32_t,
    num               : c.uint32_t,
    depth             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Submit primitive for rendering with index and instance data info and
// draw count from indirect buffers.
// @attention Availability depends on: `BGFX_CAPS_DRAW_INDIRECT_COUNT`.
// @param    in  id                View id.
// @param    in  program           Program.
// @param    in  indirect_handle   Indirect buffer.
// @param    in  start             First element in indirect buffer.
// @param    in  num_handle        Buffer for number of draws. Must be
//                                   created with `BGFX_BUFFER_INDEX32` and `BGFX_BUFFER_DRAW_INDIRECT`.
// @param    in  num_index         Element in number buffer.
// @param    in  num_max           Max number of draws.
// @param    in  depth             Depth for sorting.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
encoder_submit_indirect_count :: proc(
    this              : ^Encoder,
    id                : View_Id,
    program           : Program_Handle,
    indirect_handle   : Indirect_Buffer_Handle,
    start             : c.uint32_t,
    num_handle        : Index_Buffer_Handle,
    num_index         : c.uint32_t,
    num_max           : c.uint32_t,
    depth             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Set compute index buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Index buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
encoder_set_compute_index_buffer :: proc(
    this              : ^Encoder,
    stage             : c.uint8_t,
    handle            : Index_Buffer_Handle,
    access            : Access
) ---

// Set compute vertex buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Vertex buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
encoder_set_compute_vertex_buffer :: proc(
    this              : ^Encoder,
    stage             : c.uint8_t,
    handle            : Vertex_Buffer_Handle,
    access            : Access
) ---

// Set compute dynamic index buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Dynamic index buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
encoder_set_compute_dynamic_index_buffer :: proc(
    this              : ^Encoder,
    stage             : c.uint8_t,
    handle            : Dynamic_Index_Buffer_Handle,
    access            : Access
) ---

// Set compute dynamic vertex buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Dynamic vertex buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
encoder_set_compute_dynamic_vertex_buffer :: proc(
    this              : ^Encoder,
    stage             : c.uint8_t,
    handle            : Dynamic_Vertex_Buffer_Handle,
    access            : Access
) ---

// Set compute indirect buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Indirect buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
encoder_set_compute_indirect_buffer :: proc(
    this              : ^Encoder,
    stage             : c.uint8_t,
    handle            : Indirect_Buffer_Handle,
    access            : Access
) ---

// Set compute image from texture.
// @param    in  stage             Compute stage.
// @param    in  handle            Texture handle.
// @param    in  mip               Mip level.
// @param    in  access            Image access. See `Access::Enum`.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
encoder_set_image :: proc(
    this              : ^Encoder,
    stage             : c.uint8_t,
    handle            : Texture_Handle,
    mip               : c.uint8_t,
    access            : Access,
    format            : Texture_Format
) ---

// Dispatch compute.
// @param    in  id                View id.
// @param    in  program           Compute program.
// @param    in  num_x             Number of groups X.
// @param    in  num_y             Number of groups Y.
// @param    in  num_z             Number of groups Z.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
encoder_dispatch :: proc(
    this              : ^Encoder,
    id                : View_Id,
    program           : Program_Handle,
    num_x             : c.uint32_t,
    num_y             : c.uint32_t,
    num_z             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Dispatch compute indirect.
// @param    in  id                View id.
// @param    in  program           Compute program.
// @param    in  indirect_handle   Indirect buffer.
// @param    in  start             First element in indirect buffer.
// @param    in  num               Number of dispatches.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
encoder_dispatch_indirect :: proc(
    this              : ^Encoder,
    id                : View_Id,
    program           : Program_Handle,
    indirect_handle   : Indirect_Buffer_Handle,
    start             : c.uint32_t,
    num               : c.uint32_t,
    flags             : c.uint8_t
) ---

// Discard previously set state for draw or compute call.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
encoder_discard :: proc(
    this              : ^Encoder,
    flags             : c.uint8_t
) ---

// Blit 2D texture region between two 2D textures.
// @attention Destination texture must be created with `BGFX_TEXTURE_BLIT_DST` flag.
// @attention Availability depends on: `BGFX_CAPS_TEXTURE_BLIT`.
// @param    in  id                View id.
// @param    in  dst               Destination texture handle.
// @param    in  dst_mip           Destination texture mip level.
// @param    in  dst_x             Destination texture X position.
// @param    in  dst_y             Destination texture Y position.
// @param    in  dst_z             If texture is 2D this argument should be 0. If destination texture is cube
//                                 this argument represents destination texture cube face. For 3D texture this argument
//                                 represents destination texture Z position.
// @param    in  src               Source texture handle.
// @param    in  src_mip           Source texture mip level.
// @param    in  src_x             Source texture X position.
// @param    in  src_y             Source texture Y position.
// @param    in  src_z             If texture is 2D this argument should be 0. If source texture is cube
//                                 this argument represents source texture cube face. For 3D texture this argument
//                                 represents source texture Z position.
// @param    in  width             Width of region.
// @param    in  height            Height of region.
// @param    in  depth             If texture is 3D this argument represents depth of region, otherwise it's
//                                 unused.
encoder_blit :: proc(
    this              : ^Encoder,
    id                : View_Id,
    dst               : Texture_Handle,
    dst_mip           : c.uint8_t,
    dst_x             : c.uint16_t,
    dst_y             : c.uint16_t,
    dst_z             : c.uint16_t,
    src               : Texture_Handle,
    src_mip           : c.uint8_t,
    src_x             : c.uint16_t,
    src_y             : c.uint16_t,
    src_z             : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t,
    depth             : c.uint16_t
) ---

// Request screen shot of window back buffer.
// @remarks
//   `bgfx::CallbackI::screenShot` must be implemented.
// @attention Frame buffer handle must be created with OS' target native window handle.
// @param    in  handle            Frame buffer handle. If handle is `BGFX_INVALID_HANDLE` request will be
//                                 made for main window back buffer.
// @param    in  file_path         Will be passed to `bgfx::CallbackI::screenShot` callback.
request_screen_shot :: proc(
    handle            : Frame_Buffer_Handle,
    file_path         : cstring
) ---

// Render frame.
// @attention `bgfx::renderFrame` is blocking call. It waits for
//   `bgfx::frame` to be called from API thread to process frame.
//   If timeout value is passed call will timeout and return even
//   if `bgfx::frame` is not called.
// @warning This call should be only used on platforms that don't
//   allow creating separate rendering thread. If it is called before
//   to bgfx::init, render thread won't be created by bgfx::init call.
// @param    in  msecs             Timeout in milliseconds.
// @returns Current renderer context state. See: `bgfx::RenderFrame`.
render_frame :: proc(
    msecs             : c.int32_t
) -> Render_Frame ---

// Set platform data.
// @warning Must be called before `bgfx::init`.
// @param    in  data              Platform data.
set_platform_data :: proc(
    data              : ^Platform_Data
) ---

// Get internal data for interop.
// @attention It's expected you understand some bgfx internals before you
//   use this call.
// @warning Must be called only on render thread.
// @returns Internal data.
get_internal_data :: proc() -> ^Internal_Data ---

// Override internal texture with externally created texture. Previously
// created internal texture will released.
// @attention It's expected you understand some bgfx internals before you
//   use this call.
// @warning Must be called only on render thread.
// @param    in  handle            Texture handle.
// @param    in  ptr               Native API pointer to texture.
// @returns Native API pointer to texture. If result is 0, texture is not created yet from the main thread.
override_internal_texture_ptr :: proc(
    handle            : Texture_Handle,
    ptr               : c.uintptr_t
) -> c.uintptr_t ---

// Override internal texture by creating new texture. Previously created
// internal texture will released.
// @attention It's expected you understand some bgfx internals before you
//   use this call.
// @returns Native API pointer to texture. If result is 0, texture is not created yet from the
//   main thread.
// @warning Must be called only on render thread.
// @param    in  handle            Texture handle.
// @param    in  width             Width.
// @param    in  height            Height.
// @param    in  num_mips          Number of mip-maps.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
// @param    in  flags             Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
//                                 flags. Default texture sampling mode is linear, and wrap mode is repeat.
//                                 - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                   mode.
//                                 - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                   sampling.
// @returns Native API pointer to texture. If result is 0, texture is not created yet from the main thread.
override_internal_texture :: proc(
    handle            : Texture_Handle,
    width             : c.uint16_t,
    height            : c.uint16_t,
    num_mips          : c.uint8_t,
    format            : Texture_Format,
    flags             : c.uint64_t
) -> c.uintptr_t ---

// Sets a debug marker. This allows you to group graphics calls together for easy browsing in
// graphics debugging tools.
// @param    in  name              Marker name.
// @param    in  len               Marker name length (if length is INT32_MAX, it's expected
//                                 that _name is zero terminated string.
set_marker :: proc(
    name              : cstring,
    len               : c.int32_t
) ---

// Set render states for draw primitive.
// @remarks
//   1. To set up more complex states use:
//      `BGFX_STATE_ALPHA_REF(_ref)`,
//      `BGFX_STATE_POINT_SIZE(_size)`,
//      `BGFX_STATE_BLEND_FUNC(_src, _dst)`,
//      `BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)`,
//      `BGFX_STATE_BLEND_EQUATION(_equation)`,
//      `BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)`
//   2. `BGFX_STATE_BLEND_EQUATION_ADD` is set when no other blend
//      equation is specified.
// @param    in  state             State flags. Default state for primitive type is
//                                   triangles. See: `BGFX_STATE_DEFAULT`.
//                                   - `BGFX_STATE_DEPTH_TEST_*` - Depth test function.
//                                   - `BGFX_STATE_BLEND_*` - See remark 1 about BGFX_STATE_BLEND_FUNC.
//                                   - `BGFX_STATE_BLEND_EQUATION_*` - See remark 2.
//                                   - `BGFX_STATE_CULL_*` - Backface culling mode.
//                                   - `BGFX_STATE_WRITE_*` - Enable R, G, B, A or Z write.
//                                   - `BGFX_STATE_MSAA` - Enable hardware multisample antialiasing.
//                                   - `BGFX_STATE_PT_[TRISTRIP/LINES/POINTS]` - Primitive type.
// @param    in  rgba              Sets blend factor used by `BGFX_STATE_BLEND_FACTOR` and
//                                   `BGFX_STATE_BLEND_INV_FACTOR` blend modes.
set_state :: proc(
    state             : c.uint64_t,
    rgba              : c.uint32_t
) ---

// Set condition for rendering.
// @param    in  handle            Occlusion query handle.
// @param    in  visible           Render if occlusion query is visible.
set_condition :: proc(
    handle            : Occlusion_Query_Handle,
    visible           : bool
) ---

// Set stencil test state.
// @param    in  fstencil          Front stencil state.
// @param    in  bstencil          Back stencil state. If back is set to `BGFX_STENCIL_NONE`
//                                 _fstencil is applied to both front and back facing primitives.
set_stencil :: proc(
    fstencil          : c.uint32_t,
    bstencil          : c.uint32_t
) ---

// Set scissor for draw primitive.
// @remark
//   To scissor for all primitives in view see `bgfx::setViewScissor`.
// @param    in  x                 Position x from the left corner of the window.
// @param    in  y                 Position y from the top corner of the window.
// @param    in  width             Width of view scissor region.
// @param    in  height            Height of view scissor region.
// @returns Scissor cache index.
set_scissor :: proc(
    x                 : c.uint16_t,
    y                 : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t
) -> c.uint16_t ---

// Set scissor from cache for draw primitive.
// @remark
//   To scissor for all primitives in view see `bgfx::setViewScissor`.
// @param    in  cache             Index in scissor cache.
set_scissor_cached :: proc(
    cache             : c.uint16_t
) ---

// Set model matrix for draw primitive. If it is not called,
// the model will be rendered with an identity model matrix.
// @param    in  mtx               Pointer to first matrix in array.
// @param    in  num               Number of matrices in array.
// @returns Index into matrix cache in case the same model matrix has to be used for other draw primitive call.
set_transform :: proc(
    mtx               : rawptr,
    num               : c.uint16_t
) -> c.uint32_t ---

//  Set model matrix from matrix cache for draw primitive.
// @param    in  cache             Index in matrix cache.
// @param    in  num               Number of matrices from cache.
set_transform_cached :: proc(
    cache             : c.uint32_t,
    num               : c.uint16_t
) ---

// Reserve matrices in internal matrix cache.
// @attention Pointer returned can be modified until `bgfx::frame` is called.
// @param   out  transform         Pointer to `Transform` structure.
// @param    in  num               Number of matrices.
// @returns Index in matrix cache.
alloc_transform :: proc(
    transform         : ^Transform,
    num               : c.uint16_t
) -> c.uint32_t ---

// Set shader uniform parameter for draw primitive.
// @param    in  handle            Uniform.
// @param    in  value             Pointer to uniform data.
// @param    in  num               Number of elements. Passing `UINT16_MAX` will
//                                 use the _num passed on uniform creation.
set_uniform :: proc(
    handle            : Uniform_Handle,
    value             : rawptr,
    num               : c.uint16_t
) ---

// Set index buffer for draw primitive.
// @param    in  handle            Index buffer.
// @param    in  first_index       First index to render.
// @param    in  num_indices       Number of indices to render.
set_index_buffer :: proc(
    handle            : Index_Buffer_Handle,
    first_index       : c.uint32_t,
    num_indices       : c.uint32_t
) ---

// Set index buffer for draw primitive.
// @param    in  handle            Dynamic index buffer.
// @param    in  first_index       First index to render.
// @param    in  num_indices       Number of indices to render.
set_dynamic_index_buffer :: proc(
    handle            : Dynamic_Index_Buffer_Handle,
    first_index       : c.uint32_t,
    num_indices       : c.uint32_t
) ---

// Set index buffer for draw primitive.
// @param    in  tib               Transient index buffer.
// @param    in  first_index       First index to render.
// @param    in  num_indices       Number of indices to render.
set_transient_index_buffer :: proc(
    tib               : ^Transient_Index_Buffer,
    first_index       : c.uint32_t,
    num_indices       : c.uint32_t
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  handle            Vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
set_vertex_buffer :: proc(
    stream            : c.uint8_t,
    handle            : Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  handle            Vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
// @param    in  layout_handle     Vertex layout for aliasing vertex buffer. If invalid
//                                 handle is used, vertex layout used for creation
//                                 of vertex buffer will be used.
set_vertex_buffer_with_layout :: proc(
    stream            : c.uint8_t,
    handle            : Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t,
    layout_handle     : Vertex_Layout_Handle
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  handle            Dynamic vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
set_dynamic_vertex_buffer :: proc(
    stream            : c.uint8_t,
    handle            : Dynamic_Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  handle            Dynamic vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
// @param    in  layout_handle     Vertex layout for aliasing vertex buffer. If invalid
//                                 handle is used, vertex layout used for creation
//                                 of vertex buffer will be used.
set_dynamic_vertex_buffer_with_layout :: proc(
    stream            : c.uint8_t,
    handle            : Dynamic_Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t,
    layout_handle     : Vertex_Layout_Handle
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  tvb               Transient vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
set_transient_vertex_buffer :: proc(
    stream            : c.uint8_t,
    tvb               : ^Transient_Vertex_Buffer,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t
) ---

// Set vertex buffer for draw primitive.
// @param    in  stream            Vertex stream.
// @param    in  tvb               Transient vertex buffer.
// @param    in  start_vertex      First vertex to render.
// @param    in  num_vertices      Number of vertices to render.
// @param    in  layout_handle     Vertex layout for aliasing vertex buffer. If invalid
//                                 handle is used, vertex layout used for creation
//                                 of vertex buffer will be used.
set_transient_vertex_buffer_with_layout :: proc(
    stream            : c.uint8_t,
    tvb               : ^Transient_Vertex_Buffer,
    start_vertex      : c.uint32_t,
    num_vertices      : c.uint32_t,
    layout_handle     : Vertex_Layout_Handle
) ---

// Set number of vertices for auto generated vertices use in conjunction
// with gl_VertexID.
// @attention Availability depends on: `BGFX_CAPS_VERTEX_ID`.
// @param    in  num_vertices      Number of vertices.
set_vertex_count :: proc(
    num_vertices      : c.uint32_t
) ---

// Set instance data buffer for draw primitive.
// @param    in  idb               Transient instance data buffer.
// @param    in  start             First instance data.
// @param    in  num               Number of data instances.
set_instance_data_buffer :: proc(
    idb               : ^Instance_Data_Buffer,
    start             : c.uint32_t,
    num               : c.uint32_t
) ---

// Set instance data buffer for draw primitive.
// @param    in  handle            Vertex buffer.
// @param    in  start_vertex      First instance data.
// @param    in  num               Number of data instances.
set_instance_data_from_vertex_buffer :: proc(
    handle            : Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num               : c.uint32_t
) ---

// Set instance data buffer for draw primitive.
// @param    in  handle            Dynamic vertex buffer.
// @param    in  start_vertex      First instance data.
// @param    in  num               Number of data instances.
set_instance_data_from_dynamic_vertex_buffer :: proc(
    handle            : Dynamic_Vertex_Buffer_Handle,
    start_vertex      : c.uint32_t,
    num               : c.uint32_t
) ---

// Set number of instances for auto generated instances use in conjunction
// with gl_InstanceID.
// @attention Availability depends on: `BGFX_CAPS_VERTEX_ID`.
set_instance_count :: proc(
    num_instances     : c.uint32_t
) ---

// Set texture stage for draw primitive.
// @param    in  stage             Texture unit.
// @param    in  sampler           Program sampler.
// @param    in  handle            Texture handle.
// @param    in  flags             Texture sampling mode. Default value UINT32_MAX uses
//                                   texture sampling settings from the texture.
//                                   - `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
//                                     mode.
//                                   - `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
//                                     sampling.
set_texture :: proc(
    stage             : c.uint8_t,
    sampler           : Uniform_Handle,
    handle            : Texture_Handle,
    flags             : c.uint32_t
) ---

// Submit an empty primitive for rendering. Uniforms and draw state
// will be applied but no geometry will be submitted.
// @remark
//   These empty draw calls will sort before ordinary draw calls.
// @param    in  id                View id.
touch :: proc(
    id                : View_Id
) ---

// Submit primitive for rendering.
// @param    in  id                View id.
// @param    in  program           Program.
// @param    in  depth             Depth for sorting.
// @param    in  flags             Which states to discard for next draw. See `BGFX_DISCARD_*`.
submit :: proc(
    id                : View_Id,
    program           : Program_Handle,
    depth             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Submit primitive with occlusion query for rendering.
// @param    in  id                View id.
// @param    in  program           Program.
// @param    in  occlusion_query   Occlusion query.
// @param    in  depth             Depth for sorting.
// @param    in  flags             Which states to discard for next draw. See `BGFX_DISCARD_*`.
submit_occlusion_query :: proc(
    id                : View_Id,
    program           : Program_Handle,
    occlusion_query   : Occlusion_Query_Handle,
    depth             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Submit primitive for rendering with index and instance data info from
// indirect buffer.
// @attention Availability depends on: `BGFX_CAPS_DRAW_INDIRECT`.
// @param    in  id                View id.
// @param    in  program           Program.
// @param    in  indirect_handle   Indirect buffer.
// @param    in  start             First element in indirect buffer.
// @param    in  num               Number of draws.
// @param    in  depth             Depth for sorting.
// @param    in  flags             Which states to discard for next draw. See `BGFX_DISCARD_*`.
submit_indirect :: proc(
    id                : View_Id,
    program           : Program_Handle,
    indirect_handle   : Indirect_Buffer_Handle,
    start             : c.uint32_t,
    num               : c.uint32_t,
    depth             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Submit primitive for rendering with index and instance data info and
// draw count from indirect buffers.
// @attention Availability depends on: `BGFX_CAPS_DRAW_INDIRECT_COUNT`.
// @param    in  id                View id.
// @param    in  program           Program.
// @param    in  indirect_handle   Indirect buffer.
// @param    in  start             First element in indirect buffer.
// @param    in  num_handle        Buffer for number of draws. Must be
//                                   created with `BGFX_BUFFER_INDEX32` and `BGFX_BUFFER_DRAW_INDIRECT`.
// @param    in  num_index         Element in number buffer.
// @param    in  num_max           Max number of draws.
// @param    in  depth             Depth for sorting.
// @param    in  flags             Which states to discard for next draw. See `BGFX_DISCARD_*`.
submit_indirect_count :: proc(
    id                : View_Id,
    program           : Program_Handle,
    indirect_handle   : Indirect_Buffer_Handle,
    start             : c.uint32_t,
    num_handle        : Index_Buffer_Handle,
    num_index         : c.uint32_t,
    num_max           : c.uint32_t,
    depth             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Set compute index buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Index buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
set_compute_index_buffer :: proc(
    stage             : c.uint8_t,
    handle            : Index_Buffer_Handle,
    access            : Access
) ---

// Set compute vertex buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Vertex buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
set_compute_vertex_buffer :: proc(
    stage             : c.uint8_t,
    handle            : Vertex_Buffer_Handle,
    access            : Access
) ---

// Set compute dynamic index buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Dynamic index buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
set_compute_dynamic_index_buffer :: proc(
    stage             : c.uint8_t,
    handle            : Dynamic_Index_Buffer_Handle,
    access            : Access
) ---

// Set compute dynamic vertex buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Dynamic vertex buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
set_compute_dynamic_vertex_buffer :: proc(
    stage             : c.uint8_t,
    handle            : Dynamic_Vertex_Buffer_Handle,
    access            : Access
) ---

// Set compute indirect buffer.
// @param    in  stage             Compute stage.
// @param    in  handle            Indirect buffer handle.
// @param    in  access            Buffer access. See `Access::Enum`.
set_compute_indirect_buffer :: proc(
    stage             : c.uint8_t,
    handle            : Indirect_Buffer_Handle,
    access            : Access
) ---

// Set compute image from texture.
// @param    in  stage             Compute stage.
// @param    in  handle            Texture handle.
// @param    in  mip               Mip level.
// @param    in  access            Image access. See `Access::Enum`.
// @param    in  format            Texture format. See: `TextureFormat::Enum`.
set_image :: proc(
    stage             : c.uint8_t,
    handle            : Texture_Handle,
    mip               : c.uint8_t,
    access            : Access,
    format            : Texture_Format
) ---

// Dispatch compute.
// @param    in  id                View id.
// @param    in  program           Compute program.
// @param    in  num_x             Number of groups X.
// @param    in  num_y             Number of groups Y.
// @param    in  num_z             Number of groups Z.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
dispatch :: proc(
    id                : View_Id,
    program           : Program_Handle,
    num_x             : c.uint32_t,
    num_y             : c.uint32_t,
    num_z             : c.uint32_t,
    flags             : c.uint8_t
) ---

// Dispatch compute indirect.
// @param    in  id                View id.
// @param    in  program           Compute program.
// @param    in  indirect_handle   Indirect buffer.
// @param    in  start             First element in indirect buffer.
// @param    in  num               Number of dispatches.
// @param    in  flags             Discard or preserve states. See `BGFX_DISCARD_*`.
dispatch_indirect :: proc(
    id                : View_Id,
    program           : Program_Handle,
    indirect_handle   : Indirect_Buffer_Handle,
    start             : c.uint32_t,
    num               : c.uint32_t,
    flags             : c.uint8_t
) ---

// Discard previously set state for draw or compute call.
// @param    in  flags             Draw/compute states to discard.
discard :: proc(
    flags             : c.uint8_t
) ---

// Blit 2D texture region between two 2D textures.
// @attention Destination texture must be created with `BGFX_TEXTURE_BLIT_DST` flag.
// @attention Availability depends on: `BGFX_CAPS_TEXTURE_BLIT`.
// @param    in  id                View id.
// @param    in  dst               Destination texture handle.
// @param    in  dst_mip           Destination texture mip level.
// @param    in  dst_x             Destination texture X position.
// @param    in  dst_y             Destination texture Y position.
// @param    in  dst_z             If texture is 2D this argument should be 0. If destination texture is cube
//                                 this argument represents destination texture cube face. For 3D texture this argument
//                                 represents destination texture Z position.
// @param    in  src               Source texture handle.
// @param    in  src_mip           Source texture mip level.
// @param    in  src_x             Source texture X position.
// @param    in  src_y             Source texture Y position.
// @param    in  src_z             If texture is 2D this argument should be 0. If source texture is cube
//                                 this argument represents source texture cube face. For 3D texture this argument
//                                 represents source texture Z position.
// @param    in  width             Width of region.
// @param    in  height            Height of region.
// @param    in  depth             If texture is 3D this argument represents depth of region, otherwise it's
//                                 unused.
blit :: proc(
    id                : View_Id,
    dst               : Texture_Handle,
    dst_mip           : c.uint8_t,
    dst_x             : c.uint16_t,
    dst_y             : c.uint16_t,
    dst_z             : c.uint16_t,
    src               : Texture_Handle,
    src_mip           : c.uint8_t,
    src_x             : c.uint16_t,
    src_y             : c.uint16_t,
    src_z             : c.uint16_t,
    width             : c.uint16_t,
    height            : c.uint16_t,
    depth             : c.uint16_t
) ---

} // foreign lib
