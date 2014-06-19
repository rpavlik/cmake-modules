# - Handy functions regarding compilers
#
#  check_compile_flags(<language> <flagslist> <SUPPORTED> <UNSUPPORTED>)
#   - for every compile flag, checks whether it is supported by the compiler enabled for the given language
#   - supported languages are C and CXX
#
# Requires:
#   DetectToolchain
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

include(DetectToolchain)

function(check_compile_flags _language _flags _supported)
    set(CMAKE_${_language}_FLAGS) #making sure we are testing each flag alone
    set(${_supported})
    foreach(flag ${_flags})
        string(TOUPPER "${flag}" flag_name)
        string(REGEX REPLACE "^/" "" flag_name "${flag_name}") 
        string(REGEX REPLACE "^-" "" flag_name "${flag_name}") 
        string(REGEX REPLACE "[-]" "_" flag_name "${flag_name}")
        string(REGEX REPLACE "[+]" "P" flag_name "${flag_name}")
        string(REGEX REPLACE "[^A-z0-9]" "" flag_name "${flag_name}") 
        set(flag_name "HAS_${_language}_${flag_name}")
        
        if("${_language}" STREQUAL "C")
            include(CheckCCompilerFlag)
            check_c_compiler_flag(${flag} ${flag_name})
        elseif("${_language}" STREQUAL "CXX")
            include(CheckCXXCompilerFlag)
            check_cxx_compiler_flag(${flag} ${flag_name})
        else()
            message(FATAL_ERROR "unsupported language: ${_language}")
        endif()
        
        if(${flag_name})
            set(${_supported} "${${_supported}} ${flag}")
        endif()
    endforeach()

    set(${_supported} ${${_supported}} PARENT_SCOPE)
endfunction()

function(pedantic_compiler_flags _language _pedantic_flags)
    if(${_language}_COMPILER_IS_MSVC)
        set(${_pedantic_flags} "/Za")
    elseif(${_language}_COMPILER_IS_GNU OR ${_language}_COMPILER_IS_CLANG)
        set(${_pedantic_flags} "-pedantic-errors")
    else()
        message(WARNING "unsuported toolchain")
        return()
    endif()
    
    check_compile_flags(${_language} "${${_pedantic_flags}}" ${_pedantic_flags})
    set(${_pedantic_flags} ${${_pedantic_flags}} PARENT_SCOPE)
endfunction()

function(extra_compiler_warnings _language _extra_warnings)
    if(${_language}_COMPILER_IS_MSVC)
        option(COMPILER_WARNINGS_EXTREME
            "Use compiler warnings that are probably overkill."
            off)
        mark_as_advanced(COMPILER_WARNINGS_EXTREME)
        set(${_extra_warnings} "/W4")
        if(COMPILER_WARNINGS_EXTREME)
            set(${_extra_warnings} "${${_extra_warnings}};/Wall;/wd4619;/wd4668;/wd4820;/wd4571;/wd4710")
        endif()
    elseif(${_language}_COMPILER_IS_GNU OR ${_language}_COMPILER_IS_CLANG)
        set(${_extra_warnings} "-W;-Wall;-Wextra;-Weffc++")
    else()
        message(WARNING "unsuported toolchain")
        return()
    endif()

    check_compile_flags(${_language} "${${_extra_warnings}}" ${_extra_warnings})
    set(${_extra_warnings} ${${_extra_warnings}} PARENT_SCOPE)
endfunction()