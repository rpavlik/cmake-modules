# - Detects whether the toolchain in use is clang
#
#  Defines CMAKE_<LANG>_COMPILER_IS_CLANG if the toolchain in use for <LANG> is clang
#
# Original Author:
# 2013 Bruno Dutra <brunocodutra@gmail.com>
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

if(__detect_clang)
    return()
endif()
set(__detect_clang YES)

set(LANGUAGES "C;CXX")
foreach(LANG ${LANGUAGES})
    if(NOT CMAKE_${LANG}_COMPILER_IS_CLANG AND CMAKE_${LANG}_COMPILER_ID STREQUAL Clang)
        set(CMAKE_${LANG}_COMPILER_IS_CLANG TRUE)
    endif()
endforeach()