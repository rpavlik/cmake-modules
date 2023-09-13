# Copyright 2019-2022, Collabora, Ltd.
#
# SPDX-License-Identifier: BSL-1.0
#
# Maintained by:
# 2019-2022 Ryan Pavlik <ryan.pavlik@collabora.com> <ryan.pavlik@gmail.com>

#[[.rst:
GenerateKhrManifest
-------------------

This is a utility module, usually wrapped by more usage-specific modules.
The general goal is to be able to generate a (JSON) manifest describing targets
with some absolute, relative, or unspecified path, such as required by the OpenXR
and Vulkan loaders for runtimes and API layers.

The following functions are provided by this module:

- :command:`generate_khr_manifest_buildtree`
- :command:`generate_khr_manifest_at_install`


.. command:: generate_khr_manifest_buildtree

  Generates a manifest suitable for use in the build tree,
  with absolute paths, at configure time::

    generate_khr_manifest_buildtree(
        MANIFEST_TEMPLATE <template>    # The template for your manifest file
        TARGET <target>                 # Name of your target (layer, runtime, etc)
        OUT_FILE <outfile>              # Name of the manifest file (with path) to generate
        MANIFEST_DESCRIPTION "<desc>"   # A brief description of the thing we're generating (e.g. "Vulkan API layer manifest")
        )


.. command:: generate_khr_manifest_at_install

  Generates a manifest at install time and installs it where desired::

    generate_khr_manifest_at_install(
        MANIFEST_TEMPLATE <template>    # The template for your manifest file
        TARGET <target>                 # Name of your target (layer, runtime, etc)
        DESTINATION <dest>              # The install-prefix-relative path to install the manifest to.
        RELATIVE_TARGET_DIR <dir>       # The install-prefix-relative path that the target library is installed to.
        MANIFEST_DESCRIPTION "<desc>"   # A brief description of the thing we're generating (e.g. "Vulkan API layer manifest")
        [COMPONENT <comp>]              # If present, the component to place the manifest in.
        [ABSOLUTE_TARGET_PATH|          # If present, path in generated manifest is absolute
         TARGET_DIR_RELATIVE_TO_MANIFEST <dir>]
                                        # If present (and ABSOLUTE_TARGET_PATH not present), specifies the
                                        # target directory relative to the manifest directory in the installed layout
        [OUT_FILENAME <outfilename>     # Optional: Alternate name of the manifest file to generate (defaults to target name + .json)
        )
#]]
get_filename_component(_KHR_MANIFEST_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}"
                       PATH)
set(_KHR_MANIFEST_SCRIPT
    "${_KHR_MANIFEST_CMAKE_DIR}/GenerateKhrManifestInternals.cmake.in"
    CACHE INTERNAL "" FORCE)

function(generate_khr_manifest_buildtree)
    set(options)
    set(oneValueArgs MANIFEST_TEMPLATE TARGET OUT_FILE MANIFEST_DESCRIPTION)
    set(multiValueArgs)
    cmake_parse_arguments(_genmanifest "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    if(NOT _genmanifest_MANIFEST_TEMPLATE)
        message(FATAL_ERROR "Need MANIFEST_TEMPLATE specified!")
    endif()
    if(NOT _genmanifest_TARGET)
        message(FATAL_ERROR "Need TARGET specified!")
    endif()
    if(NOT _genmanifest_OUT_FILE)
        message(FATAL_ERROR "Need OUT_FILE specified!")
    endif()
    if(NOT _genmanifest_MANIFEST_DESCRIPTION)
        message(FATAL_ERROR "Need MANIFEST_DESCRIPTION specified!")
    endif()

    # Set template values
    set(_genmanifest_INTERMEDIATE_MANIFEST
        ${CMAKE_CURRENT_BINARY_DIR}/intermediate_manifest_buildtree_${_genmanifest_TARGET}.json
    )
    set(_genmanifest_IS_INSTALL OFF)

    set(_script
        ${CMAKE_CURRENT_BINARY_DIR}/make_build_manifest_${_genmanifest_TARGET}.cmake
    )
    configure_file("${_KHR_MANIFEST_SCRIPT}" "${_script}" @ONLY)
    add_custom_command(
        TARGET ${_genmanifest_TARGET}
        POST_BUILD
        BYPRODUCTS "${_genmanifest_OUT_FILE}"
        COMMAND
            "${CMAKE_COMMAND}" "-DOUT_FILE=${_genmanifest_OUT_FILE}"
            "-DTARGET_PATH=$<TARGET_FILE:${_genmanifest_TARGET}>" -P
            "${_script}" DEPENDS "${_script}"
        COMMENT
            "Generating ${_genmanifest_MANIFEST_DESCRIPTION} named ${_genmanifest_OUT_FILE} for build tree usage"
    )
endfunction()

function(generate_khr_manifest_at_install)
    set(options ABSOLUTE_TARGET_PATH)
    set(oneValueArgs
        MANIFEST_TEMPLATE
        TARGET
        DESTINATION
        OUT_FILENAME
        TARGET_DIR_RELATIVE_TO_MANIFEST
        RELATIVE_TARGET_DIR
        MANIFEST_DESCRIPTION
        COMPONENT)
    set(multiValueArgs)
    cmake_parse_arguments(_genmanifest "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    if(NOT _genmanifest_MANIFEST_TEMPLATE)
        message(FATAL_ERROR "Need MANIFEST_TEMPLATE specified!")
    endif()
    if(NOT _genmanifest_TARGET)
        message(FATAL_ERROR "Need TARGET specified!")
    endif()
    if(NOT _genmanifest_DESTINATION)
        message(FATAL_ERROR "Need DESTINATION specified!")
    endif()
    if(NOT _genmanifest_RELATIVE_TARGET_DIR)
        message(FATAL_ERROR "Need RELATIVE_TARGET_DIR specified!")
    endif()
    if(NOT _genmanifest_OUT_FILENAME)
        set(_genmanifest_OUT_FILENAME "${_genmanifest_TARGET}.json")
    endif()
    if(NOT _genmanifest_COMPONENT)
        set(_genmanifest_COMPONENT Unspecified)
    endif()
    set(_genmanifest_INTERMEDIATE_MANIFEST
        "${CMAKE_CURRENT_BINARY_DIR}/${_genmanifest_OUT_FILENAME}")
    set(_genmanifest_IS_INSTALL ON)
    # Template value
    set(TARGET_FILENAME
        ${CMAKE_SHARED_MODULE_PREFIX}${_genmanifest_TARGET}${CMAKE_SHARED_MODULE_SUFFIX}
    )

    set(_script
        ${CMAKE_CURRENT_BINARY_DIR}/make_manifest_${_genmanifest_TARGET}.cmake)
    configure_file("${_KHR_MANIFEST_SCRIPT}" "${_script}" @ONLY)
    install(SCRIPT "${_script}" COMPONENT ${_genmanifest_COMPONENT})
endfunction()
