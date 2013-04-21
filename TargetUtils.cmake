# - Handy functions regarding targets
#
#  set_target_property(<targetname> <propertyname> <value>)
#    the inverse analogous of get_target_property
#  add_target_property(<targetname> <propertyname> <value>)
#    adds value to the given target property as a string
#  add_binary_target(<type> <targetname>)
#    groups the functionality of add_executable, add_library, add_dependencies,
#    target_link_libraries in a handy wraper
#    supported types: EXECUTABLE, LIBRARY
#    required args:
#      SOURCES              <source1 [source2 [... [sourceN]]]>
#    optional args:
#      LANGUAGE             <C|CXX>
#      ARGS                 <arguments to be passed on to add_{executable, library}>
#      ADITIONAL_FLAGS      <{c,cxx}_flags to be added to the target>
#      DEPENDENCIES         <depend-target1 [depend-target2 [... [depend-targetN]]]>
#      LIBRARIES            <[item1 [item2 [... [itemN]]]]>
#                             (following target_link_libraries' conventions>
#
# Requires:
# 	CMakeParseArguments
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

if(__target_utils)
    return()
endif()
set(__target_utils YES)

include(CMakeParseArguments)

function(set_target_property _target _property _value)
    set_target_properties(${_target} PROPERTIES ${_property} ${_value})
endfunction()

function(add_target_property _target _property _value)
    get_target_property(previous_value ${_target} ${_property})
    if(previous_value)
        set(_value "${previous_value} ${_value}")
    endif()
    set_target_property(${_target} ${_property} ${_value})
endfunction()

function(add_binary_target _type _target)
    set(is_executable FALSE)
    set(is_library FALSE)
    if("${_type}" STREQUAL "EXECUTABLE")
        set(is_executable TRUE)
    elseif("${_type}" STREQUAL "LIBRARY")
        set(is_library TRUE)
    else()
        message(FATAL_ERROR "unsupported target type: ${_type}")
    endif()

    set(options)
    set(one_value_args LANGUAGE)
    set(multi_value_args ARGS SOURCES ADITIONAL_FLAGS DEPENDENCIES LIBRARIES)
    cmake_parse_arguments("" "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    if(UNPARSED_ARGUMENTS)
        message(ERROR "could not parse all the arguments: ${UNPARSED_ARGUMENTS}")
    endif()

    if(is_executable)
        add_executable(${_target} ${_ARGS} ${_SOURCES})
    elseif(is_library)
        add_library(${_target} ${_ARGS} ${_SOURCES})
    endif()

    if(_LANGUAGE)
        set_property(TARGET ${_target} PROPERTY LINKER_LANGUAGE "${_LANGUAGE}")
    endif()
    if(_ADITIONAL_FLAGS)
        add_target_property(${_target} COMPILE_FLAGS "${_ADITIONAL_FLAGS}")
    endif()
    if(_DEPENDENCIES)
        add_dependencies(${_target} "${_DEPENDENCIES}")
    endif()
    target_link_libraries(${_target} "${_LIBRARIES}")
endfunction()

