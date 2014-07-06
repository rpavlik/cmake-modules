# - Add flags to disable compiler extensions
#
#  disable_compiler_extensions(<targetname>)
#  globally_disable_compiler_extensions([<language1> [<language2> [...]]]) - modifies CMAKE_C[XX]_FLAGS
#   globally disables extensions for the languages specified 
#   if no language is specified, disables extensions for all enabled languages
#
# Requires:
#   CompilerUtils
#   TargetUtils
#
# Original Author:
# 2013 Bruno Dutra <brunocodutra@gmail.com>
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

if(__disable_compiler_extensions)
    return()
endif()
set(__disable_compiler_extensions YES)

include(CompilerUtils)
include(TargetUtils)

macro(_disable_compiler_extensions _language _flags)
    string(REGEX REPLACE "std=gnu" "std=c" ${_flags} "${${_flags}}")
    pedantic_compiler_flags(${_language} pedantic_flags)
    set(${_flags} "${pedantic_flags} ${${_flags}}")
endmacro()

function(disable_compiler_extensions _target)
    get_property(language TARGET ${_target} PROPERTY LINKER_LANGUAGE)
    get_target_property(compile_flags ${_target} COMPILE_FLAGS)
    _disable_compiler_extensions(${language} compile_flags)
    set_target_property(${_target} COMPILE_FLAGS ${compile_flags})
endfunction()

function(globally_disable_compiler_extensions)
    if(${ARGC})
        set(languages ${ARGV})
    else()
        get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)
    endif()
    foreach(language ${languages})
        _disable_compiler_extensions(${language} CMAKE_${language}_FLAGS)
        set(CMAKE_${language}_FLAGS ${CMAKE_${language}_FLAGS} PARENT_SCOPE)
    endforeach()
endfunction()
