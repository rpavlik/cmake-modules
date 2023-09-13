# Copyright 2019-2023, Collabora, Ltd.
#
# SPDX-License-Identifier: BSL-1.0
#
# Maintained by:
# 2019-2023 Ryan Pavlik <ryan.pavlik@collabora.com> <ryan.pavlik@gmail.com>

#[[.rst:
GenerateOpenXRRuntimeManifest
---------------

The following functions are provided by this module:

- :command:`generate_openxr_runtime_manifest_buildtree`
- :command:`generate_openxr_runtime_manifest_at_install`


.. command:: generate_openxr_runtime_manifest_buildtree

  Generates a runtime manifest suitable for use in the build tree,
  with absolute paths, at configure time::

    generate_openxr_runtime_manifest_buildtree(
        RUNTIME_TARGET <target>          # Name of your runtime target
        OUT_FILE <outfile>               # Name of the manifest file (with path) to generate
        [MANIFEST_TEMPLATE <template>]   # Optional: Specify an alternate template to use
        )


.. command:: generate_openxr_runtime_manifest_at_install

  Generates a runtime manifest at install time and installs it where desired::

    generate_openxr_runtime_manifest_buildtree(
        RUNTIME_TARGET <target>            # Name of your runtime target
        DESTINATION <dest>                 # The install-prefix-relative path to install the manifest to.
        RELATIVE_RUNTIME_DIR <dir>         # The install-prefix-relative path that the runtime library is installed to.
        [COMPONENT <comp>]                 # If present, the component to place the manifest in.
        [ABSOLUTE_RUNTIME_PATH|            # If present, path in generated manifest is absolute
         RUNTIME_DIR_RELATIVE_TO_MANIFEST <dir>]
                                           # If present (and ABSOLUTE_RUNTIME_PATH not present), specifies the
                                           # runtime directory relative to the manifest directory in the installed layout
        [OUT_FILENAME <outfilename>        # Optional: Alternate name of the manifest file to generate
        [MANIFEST_TEMPLATE <template>]     # Optional: Specify an alternate template to use
        )
#]]

# This module is mostly just argument parsing, the guts are in GenerateKhrManifest

get_filename_component(_OXR_MANIFEST_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}"
                       PATH)
include("${_OXR_MANIFEST_CMAKE_DIR}/GenerateKhrManifest.cmake")

set(_OXR_MANIFEST_TEMPLATE
    "${_OXR_MANIFEST_CMAKE_DIR}/openxr_manifest.in.json"
    CACHE INTERNAL "" FORCE)

function(generate_openxr_runtime_manifest_buildtree)
    set(options)
    set(oneValueArgs MANIFEST_TEMPLATE RUNTIME_TARGET OUT_FILE)
    set(multiValueArgs)
    cmake_parse_arguments(_genmanifest "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    if(NOT _genmanifest_MANIFEST_TEMPLATE)
        set(_genmanifest_MANIFEST_TEMPLATE "${_OXR_MANIFEST_TEMPLATE}")
    endif()
    if(NOT _genmanifest_RUNTIME_TARGET)
        message(FATAL_ERROR "Need RUNTIME_TARGET specified!")
    endif()
    if(NOT _genmanifest_OUT_FILE)
        message(FATAL_ERROR "Need OUT_FILE specified!")
    endif()

    generate_khr_manifest_buildtree(
        MANIFEST_DESCRIPTION
        "OpenXR runtime manifest"
        MANIFEST_TEMPLATE
        "${_genmanifest_MANIFEST_TEMPLATE}"
        TARGET
        "${_genmanifest_RUNTIME_TARGET}"
        OUT_FILE
        "${_genmanifest_OUT_FILE}")

endfunction()

function(generate_openxr_runtime_manifest_at_install)
    set(options ABSOLUTE_RUNTIME_PATH)
    set(oneValueArgs
        MANIFEST_TEMPLATE
        DESTINATION
        OUT_FILENAME
        COMPONENT
        RUNTIME_TARGET
        RUNTIME_DIR_RELATIVE_TO_MANIFEST
        RELATIVE_RUNTIME_DIR)
    set(multiValueArgs)
    cmake_parse_arguments(_genmanifest "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    if(NOT _genmanifest_MANIFEST_TEMPLATE)
        set(_genmanifest_MANIFEST_TEMPLATE "${_OXR_MANIFEST_TEMPLATE}")
    endif()
    if(NOT _genmanifest_RUNTIME_TARGET)
        message(FATAL_ERROR "Need RUNTIME_TARGET specified!")
    endif()
    if(NOT _genmanifest_DESTINATION)
        message(FATAL_ERROR "Need DESTINATION specified!")
    endif()
    if(NOT _genmanifest_RELATIVE_RUNTIME_DIR)
        message(FATAL_ERROR "Need RELATIVE_RUNTIME_DIR specified!")
    endif()
    if(NOT _genmanifest_OUT_FILENAME)
        set(_genmanifest_OUT_FILENAME "${_genmanifest_RUNTIME_TARGET}.json")
    endif()

    set(_genmanifest_fwdargs)

    if(_genmanifest_ABSOLUTE_RUNTIME_PATH)
        list(APPEND _genmanifest_fwdargs ABSOLUTE_TARGET_PATH)
    endif()

    if(_genmanifest_RUNTIME_DIR_RELATIVE_TO_MANIFEST)
        list(APPEND _genmanifest_fwdargs TARGET_DIR_RELATIVE_TO_MANIFEST
             "${_genmanifest_RUNTIME_DIR_RELATIVE_TO_MANIFEST}")
    endif()
    if(_genmanifest_COMPONENT)
        list(APPEND _genmanifest_fwdargs COMPONENT "${_genmanifest_COMPONENT}")
    endif()

    generate_khr_manifest_at_install(
        ${_genmanifest_fwdargs}
        MANIFEST_DESCRIPTION
        "OpenXR runtime manifest"
        MANIFEST_TEMPLATE
        "${_genmanifest_MANIFEST_TEMPLATE}"
        TARGET
        "${_genmanifest_RUNTIME_TARGET}"
        DESTINATION
        "${_genmanifest_DESTINATION}"
        RELATIVE_TARGET_DIR
        "${_genmanifest_RELATIVE_RUNTIME_DIR}"
        OUT_FILENAME
        "${_genmanifest_OUT_FILENAME}")
endfunction()
