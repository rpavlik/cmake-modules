# - Detects the toolchain in use for every enabled language
#
#  Defines <LANG>_COMPILER_IS_<MSVC|GNU|CLANG> according to the toolchain in use for <LANG>
#
# Original Author:
# 2013 Bruno Dutra <brunocodutra@gmail.com>
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

if(__detect_toolchain)
    return()
endif()
set(__detect_toolchain YES)

get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)
foreach(lang ${languages})
    if(MSVC)
        set(${lang}_COMPILER_IS_MSVC YES)
    elseif(lang STREQUAL "C" AND CMAKE_COMPILER_IS_GNUCC)
        set(${lang}_COMPILER_IS_GNU YES)
    elseif(lang STREQUAL "CXX" AND CMAKE_COMPILER_IS_GNUCXX)
        set(${lang}_COMPILER_IS_GNU YES)
    elseif(CMAKE_${lang}_COMPILER_ID STREQUAL "Clang")
        set(${lang}_COMPILER_IS_CLANG YES)
    endif()
endforeach()