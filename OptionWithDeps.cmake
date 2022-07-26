# Copyright 2022, Collabora, Ltd.
# Copyright 2000-2022, Kitware, Inc., Insight Software Consortium
#
# SPDX-License-Identifier: BSD-3-Clause
#
# CMake was initially developed by Kitware with the following sponsorship:
#  * National Library of Medicine at the National Institutes of Health
#    as part of the Insight Segmentation and Registration Toolkit (ITK).
#
#  * US National Labs (Los Alamos, Livermore, Sandia) ASC Parallel
#    Visualization Initiative.
#
#  * National Alliance for Medical Image Computing (NAMIC) is funded by the
#    National Institutes of Health through the NIH Roadmap for Medical Research,
#    Grant U54 EB005149.
#
#  * Kitware, Inc.
#
# (Based on CMakeDependentOption)

#[=======================================================================[.rst:
OptionWithDeps
--------------

Macro to provide an option dependent on other options.

This macro presents an option to the user only if a set of other
conditions are true. If it is already specified by the user but the
conditions are not true, it triggers an error.

This is based on cmake_dependent_options but meets common expectations better:
if you explicitly try to enable something that is not available, you get an error
instead of having it silently disabled.

.. command:: option_with_deps

  .. code-block:: cmake

    option_with_deps(<option> "<help_text>" [DEFAULT <default>] DEPENDS [<depends>...])

  Describes a build option that has dependencies. If the option is requested,
  but the depends are not satisfied, an error is issued. DEPENDS is a list of
  conditions to check: all must be true to make the option available.
  Otherwise, a local variable named ``<option>`` is set to ``OFF``.

  When ``<option>`` is available, the given ``<help_text>`` and initial
  ``<default>`` are used. Otherwise, any value set by the user is preserved for
  when ``<depends>`` is satisfied in the future.

  Note that the ``<option>`` variable only has a value which satisfies the
  ``<depends>`` condition within the scope of the caller because it is a local
  variable.

  Elements of ``<depends>`` cannot contain parentheses nor "AND" (each item is
  implicitly "ANDed" together). Be sure to quote OR and NOT expressions, and avoid
  complex expressions (such as with escaped quotes, etc) since they may fail,
  especially before CMake 3.18.

Example invocation:

.. code-block:: cmake

  option_with_deps(USE_PACKAGE_ABC "Use Abc" DEPENDS "USE_PACKAGE_XYZ" "NOT USE_CONFLICTING_PACKAGE")

If ``USE_PACKAGE_XYZ`` is true and ``USE_CONFLICTING_PACKAGE`` is false, this provides
an option called ``USE_PACKAGE_ABC`` that defaults to ON. Otherwise, it sets
``USE_PACKAGE_ABC`` to OFF and hides the option from the user. If the status of
``USE_PACKAGE_XYZ`` or ``USE_CONFLICTING_PACKAGE`` ever changes, any value for the
``USE_PACKAGE_ABC`` option is saved so that when the option is re-enabled it retains
its old value.

#]=======================================================================]

function(option_with_deps option doc)
    set(options)
    set(oneValueArgs DEFAULT)
    set(multiValueArgs DEPENDS)
    cmake_parse_arguments(_option_deps "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    if(NOT DEFINED _option_deps_DEFAULT)
        set(_option_deps_DEFAULT ON)
    endif()

    # Check for invalid/bad depends args
    foreach(d ${_option_deps_DEPENDS})
        if("${d}" MATCHES "[(]")
            message(
                FATAL_ERROR "option_with_deps does not support parens in deps")
        endif()
        if("${d}" MATCHES "\\bAND\\b")
            message(
                FATAL_ERROR
                    "option_with_deps treats every deps item as being implicitly 'ANDed' together"
            )
        endif()
        if("${d}" STREQUAL "OR")
            message(FATAL_ERROR "option_with_deps needs OR expressions quoted")
        endif()
        if("${d}" STREQUAL "NOT")
            message(FATAL_ERROR "option_with_deps needs NOT expressions quoted")
        endif()
    endforeach()

    # This is a case we removed from the original CMakeDependentOption module
    if(NOT (${option}_ISSET MATCHES "^${option}_ISSET$"))
        message(
            FATAL_ERROR
                "Probably too old of CMake version to cope with this module")
    endif()

    # Check the actual deps, determine if the option is available
    set(_avail ON)
    foreach(d ${_option_deps_DEPENDS})
        if(${CMAKE_VERSION} VERSION_GREATER_EQUAL 3.18)
            cmake_language(
                EVAL
                CODE
                "
                    if(${d})
                    else()
                        set(_avail OFF)
                        set(_cond ${d})
                    endif()")
        else()
            # cmake_language(EVAL CODE was added in 3.18 so evaluate it the "old" way before then.
            # turn spaces into semicolons so we have a list of arguments, signalling to CMAKE
            # to interpret the "if()" differently
            string(REGEX REPLACE " +" ";" CMAKE_DEPENDENT_OPTION_DEP "${d}")
            if(${CMAKE_DEPENDENT_OPTION_DEP})

            else()
                set(_avail OFF)
                set(_cond ${d})
            endif()
        endif()
    endforeach()

    # Error if option was requested but not available
    if("${${option}}" AND NOT "${_avail}")
        message(
            FATAL_ERROR
                "${option} specified but not available: failed check ${_cond}")
    endif()

    # Handle remaining cases
    set(_already_defined OFF)
    if(DEFINED ${option})
        set(_already_defined ON)
    endif()
    if(${_avail})
        # Set a cache variable: the value here will not override an already-set value.
        option(${option} "${doc}" "${_option_deps_DEFAULT}")

        if(NOT _already_defined)
            # Needed to force this for some reason
            set(${option}
                "${${option}}"
                CACHE BOOL "${doc}" FORCE)
        endif()
    else()
        # Don't set a cache variable for something that's not available
        set(${option}
            OFF
            PARENT_SCOPE)
    endif()
endfunction()
