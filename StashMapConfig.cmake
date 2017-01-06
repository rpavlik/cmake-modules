# Manipulate CMAKE_MAP_IMPORTED_CONFIG_ cautiously and reversibly.
#
# In all usage docs, <config> is a configuration name in all caps (RELEASE, DEBUG,
# RELWITHDEBINFO, MINSIZEREL, and NONE are the ones made by default - NONE is how
# targets are exported from single-config generators where CMAKE_BUILD_TYPE isn't set.)
#
#  stash_map_config(<config> <new list of configs for map imported>) and unstash_map_config(<config>)
#
# Saves and restores the value (or unset-ness) of CMAKE_MAP_IMPORTED_CONFIG_${config}
# - if not already between a stash and unstash call for this config. (That is,
# this is NOT a push/pop!) Calling while already between another pair is detected,
# however, and is a no-op for relative safety.
#
#  stash_common_map_config() and unstash_common_map_config()
#
# Calls stash_map_config/unstash_map_config for each configuration with sensible
# defaults based on the platform.
#
# Original Author:
# 2015, 2017 Ryan Pavlik <ryan@sensics.com> <abiryan@ryand.net>
# http://ryanpavlik.com
#
# Copyright Sensics, Inc. 2015, 2017.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

macro(stash_map_config config)
    # Re-entrancy protection - push an entry onto a list
    list(APPEND smc_IN_MAP_CONFIG_STASH_${config} yes)
    list(LENGTH smc_IN_MAP_CONFIG_STASH_${config} smc_IN_MAP_CONFIG_STASH_LEN)
    if(smc_IN_MAP_CONFIG_STASH_LEN GREATER 1)
        # Not the first stash, get out without doing anything.
        return()
    endif()

    # Actually perform the saving and replacement of CMAKE_MAP_IMPORTED_CONFIG_${config}
    if(DEFINED CMAKE_MAP_IMPORTED_CONFIG_${config})
        set(smc_OLD_CMAKE_MAP_IMPORTED_CONFIG_${config} ${CMAKE_MAP_IMPORTED_CONFIG_${config}})
    else()
        unset(smc_OLD_CMAKE_MAP_IMPORTED_CONFIG_${config})
    endif()
    set(CMAKE_MAP_IMPORTED_CONFIG_${config} ${ARGN})
endmacro()

macro(unstash_map_config config)
    if(NOT DEFINED smc_IN_MAP_CONFIG_STASH_${config})
        # Nobody actually called the matching stash...
        return()
    endif()
    # Other half of re-entrancy protection - pop an entry off a list
    list(REMOVE_AT smc_IN_MAP_CONFIG_STASH_${config} -1)
    list(LENGTH smc_IN_MAP_CONFIG_STASH_${config} smc_IN_MAP_CONFIG_STASH_LEN)
    if(smc_IN_MAP_CONFIG_STASH_LEN GREATER 0)
        # someone still in here, get out without doing anything more.
        return()
    endif()

    # Restoration of CMAKE_MAP_IMPORTED_CONFIG_${config} if we indeed are the last ones out.
    if(DEFINED smc_OLD_CMAKE_MAP_IMPORTED_CONFIG_${config})
        set(CMAKE_MAP_IMPORTED_CONFIG_${config} ${smc_OLD_CMAKE_MAP_IMPORTED_CONFIG_${config}})
        unset(smc_OLD_CMAKE_MAP_IMPORTED_CONFIG_${config})
    else()
        unset(CMAKE_MAP_IMPORTED_CONFIG_${config})
    endif()
endmacro()

macro(stash_common_map_config)
    if(MSVC)
        # Can't do this - different runtimes, incompatible ABI, etc.
        set(smc_DEBUG_FALLBACK)
        stash_map_config(DEBUG DEBUG)
    else()
        set(smc_DEBUG_FALLBACK DEBUG)
        stash_map_config(DEBUG DEBUG RELWITHDEBINFO RELEASE MINSIZEREL NONE)
    endif()
    stash_map_config(RELEASE RELEASE RELWITHDEBINFO MINSIZEREL NONE ${smc_DEBUG_FALLBACK})
    stash_map_config(RELWITHDEBINFO RELWITHDEBINFO RELEASE MINSIZEREL NONE ${smc_DEBUG_FALLBACK})
    stash_map_config(MINSIZEREL MINSIZEREL RELEASE RELWITHDEBINFO NONE ${smc_DEBUG_FALLBACK})
    stash_map_config(NONE NONE RELEASE RELWITHDEBINFO MINSIZEREL ${smc_DEBUG_FALLBACK})
endmacro()

macro(unstash_common_map_config)
    unstash_map_config(DEBUG)
    unstash_map_config(RELEASE)
    unstash_map_config(RELWITHDEBINFO)
    unstash_map_config(MINSIZEREL)
    unstash_map_config(NONE)
endmacro()
