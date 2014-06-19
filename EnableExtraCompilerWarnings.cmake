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

function(enable_extra_compiler_warnings _target)
    get_property(language TARGET ${_target} PROPERTY LINKER_LANGUAGE)
    extra_compiler_warnings(${language} flags)
    add_target_property(${_target} COMPILE_FLAGS ${flags})
endfunction()

function(globally_enable_extra_compiler_warnings)
    if(${ARGC})
        set(languages ${ARGV})
    else()
        get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)
    endif()
    foreach(language ${languages})
        extra_compiler_warnings(${language} flags)
        set(CMAKE_${language}_FLAGS "${CMAKE_${language}_FLAGS} ${flags}" PARENT_SCOPE)
    endforeach()
endfunction()
