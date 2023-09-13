# Copyright 2019-2023, Collabora, Ltd.
#
# SPDX-License-Identifier: BSL-1.0
#
# Maintained by:
# 2019-2023 Ryan Pavlik <ryan.pavlik@collabora.com> <ryan.pavlik@gmail.com>

#[[.rst:
GenerateVulkanApiLayerManifest
---------------

The following functions are provided by this module:

- :command:`generate_vulkan_api_layer_manifest_buildtree`
- :command:`generate_vulkan_api_layer_manifest_at_install`


.. command:: generate_vulkan_api_layer_manifest_buildtree

  Generates a layer manifest suitable for use in the build tree,
  with absolute paths, at configure time::

    generate_vulkan_api_layer_manifest_buildtree(
        MANIFEST_TEMPLATE <template>     # The template for your manifest file
        LAYER_TARGET <target>            # Name of your layer target
        OUT_FILE <outfile>               # Name of the manifest file (with path) to generate
        )


.. command:: generate_vulkan_api_layer_manifest_at_install

  Generates a layer manifest at install time and installs it where desired::

    generate_vulkan_api_layer_manifest_at_install(
        MANIFEST_TEMPLATE <template>       # The template for your manifest file
        LAYER_TARGET <target>              # Name of your layer target
        DESTINATION <dest>                 # The install-prefix-relative path to install the manifest to.
        RELATIVE_LAYER_DIR <dir>           # The install-prefix-relative path that the layer library is installed to.
        [COMPONENT <comp>]                 # If present, the component to place the manifest in.
        [ABSOLUTE_LAYER_PATH|              # If present, path in generated manifest is absolute
         LAYER_DIR_RELATIVE_TO_MANIFEST <dir>]
                                           # If present (and ABSOLUTE_LAYER_PATH not present), specifies the
                                           # layer directory relative to the manifest directory in the installed layout
        [OUT_FILENAME <outfilename>        # Optional: Alternate name of the manifest file to generate
        )
#]]

# This module is mostly just argument parsing, the guts are in GenerateKhrManifest

get_filename_component(_VK_MANIFEST_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
include("${_VK_MANIFEST_CMAKE_DIR}/GenerateKhrManifest.cmake")

function(generate_vulkan_api_layer_manifest_buildtree)
    set(options)
    set(oneValueArgs MANIFEST_TEMPLATE LAYER_TARGET OUT_FILE)
    set(multiValueArgs)
    cmake_parse_arguments(_genmanifest "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    if(NOT _genmanifest_MANIFEST_TEMPLATE)
        message(FATAL_ERROR "Need MANIFEST_TEMPLATE specified!")
    endif()
    if(NOT _genmanifest_LAYER_TARGET)
        message(FATAL_ERROR "Need LAYER_TARGET specified!")
    endif()
    if(NOT _genmanifest_OUT_FILE)
        message(FATAL_ERROR "Need OUT_FILE specified!")
    endif()

    generate_khr_manifest_buildtree(
        MANIFEST_DESCRIPTION
        "Vulkan API layer manifest"
        MANIFEST_TEMPLATE
        "${_genmanifest_MANIFEST_TEMPLATE}"
        TARGET
        "${_genmanifest_LAYER_TARGET}"
        OUT_FILE
        "${_genmanifest_OUT_FILE}")

endfunction()

function(generate_vulkan_api_layer_manifest_at_install)
    set(options ABSOLUTE_LAYER_PATH)
    set(oneValueArgs
        MANIFEST_TEMPLATE
        DESTINATION
        OUT_FILENAME
        COMPONENT
        LAYER_TARGET
        LAYER_DIR_RELATIVE_TO_MANIFEST
        RELATIVE_LAYER_DIR)
    set(multiValueArgs)
    cmake_parse_arguments(_genmanifest "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    if(NOT _genmanifest_MANIFEST_TEMPLATE)
        message(FATAL_ERROR "Need MANIFEST_TEMPLATE specified!")
    endif()
    if(NOT _genmanifest_LAYER_TARGET)
        message(FATAL_ERROR "Need LAYER_TARGET specified!")
    endif()
    if(NOT _genmanifest_DESTINATION)
        message(FATAL_ERROR "Need DESTINATION specified!")
    endif()
    if(NOT _genmanifest_RELATIVE_LAYER_DIR)
        message(FATAL_ERROR "Need RELATIVE_LAYER_DIR specified!")
    endif()
    if(NOT _genmanifest_OUT_FILENAME)
        set(_genmanifest_OUT_FILENAME "${_genmanifest_LAYER_TARGET}.json")
    endif()

    set(_genmanifest_fwdargs)

    if(_genmanifest_ABSOLUTE_LAYER_PATH)
        list(APPEND _genmanifest_fwdargs ABSOLUTE_TARGET_PATH)
    endif()

    if(_genmanifest_LAYER_DIR_RELATIVE_TO_MANIFEST)
        list(APPEND _genmanifest_fwdargs TARGET_DIR_RELATIVE_TO_MANIFEST
             "${_genmanifest_LAYER_DIR_RELATIVE_TO_MANIFEST}")
    endif()
    if(_genmanifest_COMPONENT)
        list(APPEND _genmanifest_fwdargs COMPONENT "${_genmanifest_COMPONENT}")
    endif()

    generate_khr_manifest_at_install(
        ${_genmanifest_fwdargs}
        MANIFEST_DESCRIPTION
        "Vulkan API layer manifest"
        MANIFEST_TEMPLATE
        "${_genmanifest_MANIFEST_TEMPLATE}"
        TARGET
        "${_genmanifest_LAYER_TARGET}"
        DESTINATION
        "${_genmanifest_DESTINATION}"
        RELATIVE_TARGET_DIR
        "${_genmanifest_RELATIVE_LAYER_DIR}"
        OUT_FILENAME
        "${_genmanifest_OUT_FILENAME}")
endfunction()
