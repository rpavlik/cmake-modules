# - Handy functions regarding compilers
#
#  check_compile_flags(<language> <flagslist> <SUPPORTED> <UNSUPPORTED>)
#   - for every compile flag, checks whether it is supported by the compiler enabled for the given language
#   - supported languages are C and CXX
#
# Original Author:
# 2013 Bruno Dutra <brunocodutra@gmail.com>
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

if(__compiler_utils)
    return()
endif()
set(__compiler_utils YES)

function(check_compile_flags _language _flags _supported)
    include(CheckCCompilerFlag)
    include(CheckCXXCompilerFlag)
    set(supported)
    foreach(flag ${_flags})
        string(TOUPPER "${flag}" flag_name)
        string(REGEX REPLACE "^/" "" flag_name "${flag_name}") 
        string(REGEX REPLACE "^-" "" flag_name "${flag_name}") 
        string(REGEX REPLACE "[-]" "_" flag_name "${flag_name}") 
        string(REGEX REPLACE "[^A-z]" "" flag_name "${flag_name}") 
        set(flag_name "HAS_${flag_name}")
        
        if("${_language}" STREQUAL "C")
            check_c_compiler_flag(${flag} ${flag_name})
        elseif("${_language}" STREQUAL "CXX")
            check_cxx_compiler_flag(${flag} ${flag_name})
        else()
            message(FATAL_ERROR "unsupported language: ${_language}")
        endif()
        
        if(${flag_name})
            set(supported "${supported} ${flag}")
        endif()
    endforeach()

    set(${_supported} ${supported} PARENT_SCOPE)
endfunction()

function(pedantic_compiler_flags _language _pedantic_flags)
        check_compile_flags(${_language} "-/Za;-pedantic-errors" supported_flags)
        
        set(${_pedantic_flags} ${supported_flags} PARENT_SCOPE)
endfunction()