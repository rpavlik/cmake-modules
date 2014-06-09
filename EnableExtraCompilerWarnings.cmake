# - Add flags to compile with extra warnings
#
#  enable_extra_compiler_warnings(<targetname>)
#  globally_enable_extra_compiler_warnings() - modifies CMAKE_C_FLAGS and CMAKE_CXX_FLAGS
#    to change for all targets declared after the command, instead of per-command
#
# Requires:
#   CompilerUtils
#   TargetUtils
#
# Original Author:
# 2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright Iowa State University 2009-2010.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# 2013 Bruno Dutra <brunocodutra@gmail.com>

if(__enable_extra_compiler_warnings)
    return()
endif()
set(__enable_extra_compiler_warnings YES)

include(CompilerUtils)
include(TargetUtils)

macro(_enable_extra_compiler_warnings_flags)
    set(c_flags)
    set(cxx_flags)
    if(MSVC)
        option(COMPILER_WARNINGS_EXTREME
            "Use compiler warnings that are probably overkill."
            off)
        mark_as_advanced(COMPILER_WARNINGS_EXTREME)
        set(c_flags "/W4")
        if(COMPILER_WARNINGS_EXTREME)
            set(c_flags "${c_flags} /Wall /wd4619 /wd4668 /wd4820 /wd4571 /wd4710")
        endif()
        set(cxx_flags ${c_flags})
    else()
        set(c_supported_flags)
        set(c_unsupported_flags)
        set(cxx_supported_flags)
        set(cxx_unsupported_flags)

        get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)
        foreach(language ${languages})
            string(TOLOWER ${language} prefix)
            check_compile_flags(${language} "-W w;-Wall wall;-Wextra wextra;-Weffc++ weffcxx" ${prefix}_supported_flags ${prefix}_unsupported_flags)
        endforeach()

        string(REPLACE ";" " " c_flags "${c_supported_flags}")
        string(REPLACE ";" " " cxx_flags "${cxx_supported_flags}")
    endif()
endmacro()

function(enable_extra_compiler_warnings _target)
    _enable_extra_compiler_warnings_flags()
    get_property(language TARGET ${_target} PROPERTY LINKER_LANGUAGE)
    if("${language}" STREQUAL "C")
        add_target_property(${_target} COMPILE_FLAGS "${c_flags}")
    elseif("${language}" STREQUAL "CXX")
        add_target_property(${_target} COMPILE_FLAGS "${cxx_flags}")
    endif()
endfunction()

function(globally_enable_extra_compiler_warnings)
    _enable_extra_compiler_warnings_flags()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${c_flags}" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${cxx_flags}" PARENT_SCOPE)
endfunction()
