# - Detects whether the toolchain in use is clang
#
#  Defines CMAKE_COMPILER_IS_CLANG if the toolchain in use is clang
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

if(__detect_clang)
    return()
endif()
set(__detect_clang YES)

if(NOT CMAKE_COMPILER_IS_CLANG AND CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    messagE("ksjhfjskfhd")
    set(CMAKE_COMPILER_IS_CLANG ON)
endif()
