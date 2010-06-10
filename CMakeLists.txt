# CMake cross-platform build system
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu>
# http://academic.cleardefinition.com/
# Iowa State University HCI Graduate Program/VRAC

cmake_minimum_required(VERSION 2.6.2)

# Set package properties
project(SPARTA)

set(CPACK_PACKAGE_VENDOR "Iowa State University")
set(CPACK_PACKAGE_CONTACT "Ryan Pavlik <rpavlik@iastate.edu>")
set(CPACK_PACKAGE_VERSION_MAJOR "0")
set(CPACK_PACKAGE_VERSION_MINOR "1")
set(CPACK_PACKAGE_VERSION_PATCH "0")
set(CPACK_PACKAGE_VERSION
	"${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-src")

###
# Set up options
###

# Define Simple Options
option(BUILD_VERBOSE "Turn on lots of runtime output." on)
option(BUILD_WITH_VPS "Build using the VPS library." on)

# Apply definitions
if(BUILD_VERBOSE)
	add_definitions(-DVERBOSE)
endif()

set(BIN_DIR bin/)
set(LUA_DIR share/sparta/lua/)
set(INCLUDE_DIR include/)
set(LIB_DIR lib/)

###
# End options
###

###
# Perform build configuration of dependencies
###

# Locally-developed modules dist'ed with this app - always have this first.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(UseBackportedModules)
include(CppcheckTargets)
include(DoxygenTargets)
include(GetDirectoryList)
include(EnableExtraCompilerWarnings)
include(StampSourcesWithVersion)

include(CTest)
include(CreateDashboardScripts)

set(EXTRA_LIBS)

set(CMAKE_DEBUG_POSTFIX  "_d")

include_directories("${CMAKE_CURRENT_SOURCE_DIR}")

# Boost
find_package(Boost 1.34.0 REQUIRED) # Required for LuaBind
include_directories(${Boost_INCLUDE_DIRS})

# VR JuggLua
find_package(VRJuggLua REQUIRED)
list(APPEND EXTRA_LIBS ${VRJUGGLUA_LIBRARIES})
include_directories(${VRJUGGLUA_INCLUDE_DIRS})

# OpenSceneGraph
include(SearchProgramFilesForOpenSceneGraph)
find_package(OpenSceneGraph REQUIRED COMPONENTS osgDB osgUtil osgIntrospection)
list(APPEND EXTRA_LIBS ${OPENSCENEGRAPH_LIBRARIES})

include_directories(${OPENSCENEGRAPH_INCLUDE_DIRS})
get_directory_list(OPENSCENEGRAPH_RUNTIME_LIBRARY_DIRS ${OPENSCENEGRAPH_LIBRARIES})
list(APPEND RUNTIME_LIBRARY_DIRS ${OPENSCENEGRAPH_RUNTIME_LIBRARY_DIRS})

# VR Juggler
find_package(VRJuggler22 REQUIRED)

add_definitions(${VRJUGGLER22_DEFINITIONS})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${VRJUGGLER22_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${VRJUGGLER22_CXX_FLAGS}")
list(APPEND EXTRA_LIBS ${VRJUGGLER22_LIBRARIES})
include_directories(${VRJUGGLER22_INCLUDE_DIRS})

include(BundleOSGRuntime)
include(BundleVRJ22Runtime)

find_package(VPS)
if(BUILD_WITH_VPS)
	if(VPS_FOUND)
		include_directories(${VPS_INCLUDE_DIRS})
	else()
		message(FATAL_ERROR "BUILD_WITH_VPS enabled, but VPS not found!")
	endif()
endif()

###
# Build the project
###

# Build the embedded libraries
add_subdirectory(third-party)

# Build the application
add_subdirectory(src)

add_doxygen(Doxyfile)

if(BUILD_TESTING)
	include(BoostTestTargets)
	#add_subdirectory(tests)
endif()

create_dashboard_scripts("DashboardBuildInitialCache.cmake.in")

###
# End project build
###


###
# Set packaging options (for CPack)
###


# Choose desired package generators
if(APPLE)
	set(CPACK_GENERATOR DragNDrop)
	set(CPACK_SOURCE_GENERATOR ZIP)
elseif(WIN32)
	set(CPACK_SOURCE_GENERATOR ZIP)
else()
	set(CPACK_SOURCE_GENERATOR TARGZ)
endif()

# Include the packaging system now that we have it all set up
include(CPack)

###
# End Packaging
###
