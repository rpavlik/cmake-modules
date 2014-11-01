# - Add flags to enable specific language dialect
#
#  enable_language_dialect(<targetname> <dialect>)
#  globally_enable_language_dialect(<language> <dialect>) - modifies CMAKE_C[XX]_FLAGS
#   globally enables the dialect specified
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

if(__enable_language_dialect)
    return()
endif()
set(__enable_language_dialect YES)

include(CompilerUtils)
include(TargetUtils)

function(enable_language_dialect _target _dialect)
    get_property(language TARGET ${_target} PROPERTY LINKER_LANGUAGE)
    language_dialect_flags(${language} ${_dialect} flags)
    add_target_property(${_target} COMPILE_FLAGS ${flags})
endfunction()

function(globally_enable_language_dialect _language _dialect)
    language_dialect_flags(${language} ${_dialect} flags)
    set(CMAKE_${language}_FLAGS "${CMAKE_${language}_FLAGS} ${flags}" PARENT_SCOPE)
endfunction()
