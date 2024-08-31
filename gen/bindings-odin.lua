local codegen = require "codegen"
local idl = codegen.idl "bgfx.idl"

local odin_template = [[
//
// AUTO GENERATED! DO NOT EDIT!
//

package bgfx

import "core:c"


$version

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
        // ...
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
    vtable              : ^Callback_Vtable,
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
    vtable              : ^Allocator_Vtable,
}

Release_Fn :: #type proc "c" (ptr : rawptr, user_data : rawptr)


$types

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

$funcs
} // foreign lib]]

local function proc_template(has_args)
    if has_args then
        return "$func :: proc(\n    $params\n)$ret ---"
    else
        return "$func :: proc($params)$ret ---"
    end
end


local function is_empty(s)
    return s == nil or s == ''
end

local function has_prefix(str, prefix)
    return prefix == "" or str:sub(1, #prefix) == prefix
end

local function has_suffix(str, suffix)
    return suffix == "" or str:sub(- #suffix) == suffix
end


local function convert_const_name(name)
    -- ConstName -> CONST_NAME
    local ret = name:sub(1,1) .. name:sub(2):gsub("(%u)", function(uc)
        return "_" .. uc
    end)
    return string.upper(ret)
end

local function convert_type_name(cname)
    if cname:find("^%u") then
        -- TypeName -> Type_Name
        -- TypeABC -> Type_ABC
        return cname:sub(1,1) .. cname:sub(2):gsub("(%l%u)", function(c)
            return c:sub(1,1) .. "_" .. c:sub(2,2)
        end)
    end
    if not has_prefix(cname, "bgfx_") then
        return cname
    end
    -- bgfx_type_name_t -> Type_Name
    -- bgfx_type_name_t* -> Type_Name*
    local name = cname:gsub("^bgfx_", "")
    name = name:gsub("_t$", "")
    name = name:gsub("_t%*", "*")
    name = name:gsub("_t %*", " *")
    name = name:gsub("^%l", string.upper)
    name = name:gsub("_%l", string.upper)
    name = name:gsub("Gpu", "GPU") -- yikes...
    return name
end

local function convert_type(arg)
    local ctype = arg.ctype
    if ctype == nil then
        ctype = arg.fulltype
    end
    if ctype == nil then
        ctype = arg
    end

    ctype = ctype:gsub("const ",        "")
    ctype = ctype:gsub("char%*",        "cstring")
    ctype = ctype:gsub("void%*",        "rawptr")
    ctype = ctype:gsub("^int64_t",      "c.int64_t")
    ctype = ctype:gsub("^int32_t",      "c.int32_t")
    ctype = ctype:gsub("^uint64_t",     "c.uint64_t")
    ctype = ctype:gsub("^uint32_t",     "c.uint32_t")
    ctype = ctype:gsub("^uint16_t",     "c.uint16_t")
    ctype = ctype:gsub("^uint8_t",      "c.uint8_t")
    ctype = ctype:gsub("^uintptr_t",    "c.uintptr_t")
    ctype = ctype:gsub("char",          "c.char")
    ctype = ctype:gsub("float",         "c.float")
    ctype = convert_type_name(ctype)

    if has_suffix(ctype, "*") then
        ctype = "^" .. ctype:gsub("%s-%*", "")
    end

    if arg.array ~= nil then
        ctype = arg.array:gsub("(%a+)::", function(t)
            return convert_type_name(t) .. "."
        end) .. ctype
    end

    -- TODO: Default arguments
    --
    --if arg.default ~= nil then
    --    ctype = ctype .. " = " .. tostring(arg.default)
    --end

    return ctype
end

local function convert_ret_type(ret)
    if ret == nil
    or ret.type == "void" then
        return ""
    end
    return " -> " .. convert_type(ret)
end

local function convert_arg_name(arg_name)
    -- _argName -> argName
    local name = arg_name:gsub("^_", "")

    -- argNAME -> argName
    name = name:gsub("(%u%u+)", function(uc)
        return uc:sub(1,1) .. string.lower(uc:sub(2, -1))
    end)

    -- argName -> arg_name
    name = name:gsub("(%u)", function(uc)
        return "_" .. string.lower(uc)
    end)

    -- replace some reserved names...
    if name == "enum" then
        name = "type"
    end
    if name == "context" then
        name = "ctx"
    end

    return name
end


local yield = coroutine.yield
local converter = {}

function converter.types(ttype)
    -- funcptr doesn't seem to work?
    assert(ttype.funcptr == nil)

    if ttype.flag then

        local value_fmt = string.format("0x%%0%dx", ttype.bits / 4)
        local function format_value(val)
            local ret = string.format(value_fmt, val)
            return string.format("%-20s", ret)
        end

        local flag_type = string.format("%-10s", "c.uint" .. ttype.bits .. "_t")

        if ttype.comments then
            for _, line in ipairs(ttype.comments) do
                yield("// " .. line)
            end
        end

        for _, item in ipairs(ttype.flag) do
            if item.value then
                local flag_name = string.format("%-36s", convert_const_name(ttype.name .. item.name))
                local flag_comment = ""

                if item.comment then
                    flag_comment = "// " .. table.concat(item.comment, " ")
                end

                yield(flag_name .. " : " .. flag_type .. " : " .. format_value(item.value) .. flag_comment)
            else
                local flag_name = convert_const_name(ttype.name .. item.name)

                if item.comment then
                    yield("")
                    for _, cmt in ipairs(item.comment) do
                        yield("// " .. cmt)
                    end
                end
                yield(string.format("%-25s (", flag_name .. " ::"))
                local flag_item = ""
                for key, val in ipairs(item) do
                    if type(key) == "number" then
                        if not is_empty(flag_item) then yield(string.format("%-25s |", flag_item)) end
                        flag_item = "    " .. convert_const_name(ttype.name .. val)
                    end
                end
                yield(string.format("%-25s )", flag_item))
                yield("")
            end
        end

        if ttype.shift then
            yield(string.format("%-36s", convert_const_name(ttype.name .. "Shift"))
                .. " : " .. flag_type .. " : " .. string.format("%-20s", ttype.shift))
        end

        if ttype.mask then
            yield(string.format("%-36s", convert_const_name(ttype.name .. "Mask"))
                .. " : " .. flag_type .. " : " .. format_value(ttype.mask))
        end

        if ttype.helper then
            yield(string.format(
                "%s :: #force_inline proc(v : c.uint%s_t) -> c.uint%s_t { return (v << %s) & %s }",
                convert_const_name(ttype.name),
                ttype.bits,
                ttype.bits,
                convert_const_name(ttype.name .. "Shift"),
                convert_const_name(ttype.name .. "Mask")
            ))
        end

    elseif ttype.enum then

        if not is_empty(ttype.comment) then
            yield("// " .. ttype.comment)
        end
        yield(convert_type_name(ttype.typename) .. " :: enum c.int {")
        for _, item in ipairs(ttype.enum) do
            if item.comment then
                yield(string.format("    %-32s // %s", item.name .. ",", table.concat(item.comment, " ")))
            else
                yield("    " .. item.name .. ",")
            end
        end
        yield("    Count")
        yield("}")

    elseif ttype.struct then

        if ttype.comments then
            for _, cmt in ipairs(ttype.comments) do
                yield("// " .. cmt)
            end
        end

        local struct_name = ttype.name
        if ttype.namespace then
            struct_name = ttype.namespace .. struct_name
        end
        yield(convert_type_name(struct_name) .. " :: struct {")
        for _, member in ipairs(ttype.struct) do
            local member_name = string.format("%-27s", convert_arg_name(member.name))
            local member_type = convert_type(member) .. ","
            local member_comment = ""
            if member.comment then
                if #member.comment == 1 then
                    member_type = string.format("%-27s", member_type)
                    member_comment = " // " .. table.concat(member.comment, " ")
                else
                    yield("")
                    for _, cmt in ipairs(member.comment) do
                        yield("    // " .. cmt)
                    end
                end
            end
            yield("    " .. member_name .. " : " .. member_type .. member_comment)
        end
        yield("}")

    elseif ttype.handle then

        yield(string.format("%-28s :: struct { idx : c.uint16_t }", convert_type_name(ttype.cname)))

    end
end

function converter.funcs(func)
    if func.cpponly then
        return
    elseif func.cppinline and not func.conly then
        return
    end

    for _, arg in ipairs(func.args) do
        if arg.type == "va_list" then
            -- skip
            return
        end
    end


    if func.comments ~= nil then
        for _, line in ipairs(func.comments) do
            yield("// " .. line)
        end
    end
    for _, arg in ipairs(func.args) do
        if arg.comment ~= nil then
            local comment = table.concat(arg.comment, "\n//" .. string.rep(" ", 33))
            local inout = "in"
            if arg.out ~= nil then
                inout = "out"
            end
            if arg.inout ~= nil then
                inout = "inout"
            end
            comment = string.format("// @param %5s  %-17s %s", inout, convert_arg_name(arg.name), comment)
            yield(comment)
        end
    end
    if func.ret ~= nil and func.ret.comment ~= nil then
        local comment = table.concat(func.ret.comment, " ")
        yield("// @returns " .. comment)
    end


    local args = {}

    if func.class then
        local argf = string.format("%-17s : %s", "this", convert_type(func.this))
        table.insert(args, argf)
    end

    for _, arg in ipairs(func.args) do
        if arg.type == "..." then
            -- ???
            table.insert(args, "// ...")
        else
            if not is_empty(arg.name) then
                local argf = string.format("%-17s : %s", convert_arg_name(arg.name), convert_type(arg))
                table.insert(args, argf)
            else
                table.insert(args, convert_type(arg))
            end
        end
    end


    local odin_func = {}
    odin_func.func = func.cname
    odin_func.params = table.concat(args, ",\n    ")
    odin_func.ret = convert_ret_type(func.ret)
    yield(proc_template(#args > 0):gsub("$(%l+)", odin_func))
end


function generate()
    local r = odin_template:gsub("$(%l+)", function(what)
        if what == "version" then
            return "API_VERSION :: " .. (idl._version or 0)
        end

        local tmp = {}
        for _, object in ipairs(idl[what]) do
            local co = coroutine.create(converter[what])
            local any

            while true do
                local ok, v = coroutine.resume(co, object)
                assert(ok, debug.traceback(co, v))
                if not v then
                    break
                end
                table.insert(tmp, v)
                any = true
            end

            if any and tmp[#tmp] ~= "" then
                table.insert(tmp, "")
            end
        end
        -- remove trailing whitespace
        return table.concat(tmp, "\n"):gsub("[ ]+%f[\r\n%z]", "")
    end)
    return r
end

if (...) == nil then
    -- Run `lua bindings-odin.lua` in command line to output bindings.
    print(generate())
end
