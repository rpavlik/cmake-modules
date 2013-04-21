# - Handy functions regarding compilers
#
#  check_compile_flags(<language> <flagslist> <SUPPORTED> <UNSUPPORTED>)
#    for every compile flag, checks if the compiler for the given language
#    supports it and sorts it out in the appropriate output list
#    supported languages are C and CXX
#    flags should be given in a list of pairs (space separated), for which
#    the first item is the compile flag iself, while the second should be
#    an identifier that uniquely identifies the given flag
#    Eg. "-flag1 flag1; /flag2 flag2; -flag3=on flag3_on"
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

if(__compiler_utils)
    return()
endif()
set(__compiler_utils YES)

function(check_compile_flags _language _flags _supported _unsupported)
    include(CheckCCompilerFlag)
    include(CheckCXXCompilerFlag)
    set(supported)
    set(unsupported)
    foreach(item ${_flags})
        string(REGEX REPLACE "([^ ]+) .+" "\\1" flag ${item})
        string(REGEX REPLACE "[^ ]+ (.+)" "supports_\\1_${_language}_flag" flag_name ${item})
        string(TOUPPER ${flag_name} flag_name)

        if("${_language}" STREQUAL "C")
            check_c_compiler_flag(${flag} ${flag_name})
        elseif("${_language}" STREQUAL "CXX")
            check_cxx_compiler_flag(${flag} ${flag_name})
        else()
            message(FATAL_ERROR "unsupported language: ${_language}")
        endif()
        if(${flag_name})
            set(supported "${supported}" "${flag}")
        else()
            set(unsupported "${unsupported}" "${flag}")
        endif()
    endforeach()

    set(${_supported} ${supported} PARENT_SCOPE)
    set(${_unsupported} ${unsupported} PARENT_SCOPE)
endfunction()

