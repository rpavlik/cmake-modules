# - Add flags to compile without compiler specific and extensions
#
#  disable_compiler_extensions(<targetname>)
#  globally_disable_compiler_extensions() - modifies CMAKE_C[XX]_FLAGS
#    disable extensions for all c/c++ targets declared subsequently
#
# Requires:
#   DetectClang
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

if(__disable_compiler_extensions)
    return()
endif()
set(__disable_compiler_extensions YES)

include(DetectClang)
include(TargetUtils)

macro(_disable_compiler_extensions_flags)
    set(_flags)
    if(MSVC)
        set(c_flags "/Za")
        set(cxx_flags ${c_flags})
    else()
        set(c_supported_flags)
        set(c_unsupported_flags c_flags)
        set(cxx_supported_flags)
        set(cxx_unsupported_flags cxx_flags)

        get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)
        foreach(language ${languages})
            string(TOLOWER ${language} prefix)
            check_compile_flags(${language} "-pedantic-errors pedantic_errors" ${prefix}_supported_flags ${prefix}_unsupported_flags)
        endforeach()

        string(REPLACE ";" " " c_flags "${c_supported_flags}")
        string(REPLACE ";" " " cxx_flags "${cxx_supported_flags}")
    endif()
endmacro()

macro(_decay_to_base_standard _language _flags)
    if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
        string(REGEX REPLACE "-std=gnu" "-std=c" ${_flags} "${${_flags}}")
        if("${_language}" STREQUAL "C")
            set(language_regex "c")
            set(default_standard "c89")
        elseif("${_language}" STREQUAL "CXX")
            set(language_regex "c\\+\\+")
            set(default_standard "c++98")
        else()
            message(FATAL_ERROR "unsupported language: ${_language}")
        endif()
    endif()

    if(CMAKE_COMPILER_IS_GNUCXX)
        if(NOT "${${_flags}}" MATCHES "(-std=${language_regex})|(-ansi)")
            set(${_flags} "-ansi ${${_flags}}")
        endif()
    elseif(CMAKE_COMPILER_IS_CLANG)
        if(NOT "${${_flags}}" MATCHES "-std=${language_regex}")
            set(${_flags} "-std=${default_standard} ${${_flags}}")
        endif()
    endif()
endmacro()

function(disable_compiler_extensions _target)
    _disable_compiler_extensions_flags()
    get_property(language TARGET ${_target} PROPERTY LINKER_LANGUAGE)
    if("${language}" STREQUAL "C")
        add_target_property(${_target} COMPILE_FLAGS "${c_flags}")
    elseif("${language}" STREQUAL "CXX")
        add_target_property(${_target} COMPILE_FLAGS "${cxx_flags}")
    else()
        add_target_property(${_target} COMPILE_FLAGS "${c_flags} ${cxx_flags}")
    endif()
endfunction()

function(globally_disable_compiler_extensions)
        _disable_compiler_extensions_flags()
        _decay_to_base_standard(C CMAKE_C_FLAGS)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${c_flags}" PARENT_SCOPE)
        _decay_to_base_standard(CXX CMAKE_CXX_FLAGS)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${cxx_flags}" PARENT_SCOPE)
endfunction()
