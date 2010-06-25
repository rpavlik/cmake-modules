# - try to find Haption VirtuoseAPI library and include files
#
#  VIRTUOSEAPI_INCLUDE_DIRS, where to find headers
#  VIRTUOSEAPI_LIBRARIES, the libraries to link against
#  VIRTUOSEAPI_FOUND, If false, do not try to use this library
#  VIRTUOSEAPI_RUNTIME_LIBRARY_DIRS, path to DLL/SO for runtime use.

set(VIRTUOSEAPI_ROOT_DIR
	"${VIRTUOSEAPI_ROOT_DIR}"
	CACHE
	PATH
	"Path to search for VirtuoseAPI")

set(_dirs)
if(WIN32)
	include(ProgramFilesGlob)
	program_files_fallback_glob(_dirs "/VirtuoseAPI_v*/")
endif()

find_path(VIRTUOSEAPI_INCLUDE_DIR
	VirtuoseAPI.h
	PATHS
	${_dirs}
	HINTS
	"${VIRTUOSEAPI_ROOT_DIR}")

if(WIN32)
	find_library(VIRTUOSEAPI_LIBRARY
		NAMES
		virtuoseDLL
		PATHS
		${_dirs}
		HINTS
		"${VIRTUOSEAPI_ROOT_DIR}"
		PATH_SUFFIXES
		win32)
	find_file(VIRTUOSEAPI_RUNTIME_LIBRARY
		NAMES
		virtuoseAPI.dll
		PATHS
		${_dirs}
		HINTS
		"${VIRTUOSEAPI_ROOT_DIR}"
		PATH_SUFFIXES
		win32)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
	find_library(VIRTUOSEAPI_LIBRARY
		NAMES
		virtuose
		PATHS
		${_dirs}
		HINTS
		"${VIRTUOSEAPI_ROOT_DIR}"
		PATH_SUFFIXES
		linux-2.6)
	find_file(VIRTUOSEAPI_RUNTIME_LIBRARY
		NAMES
		virtuoseAPI.so
		PATHS
		${_dirs}
		HINTS
		"${VIRTUOSEAPI_ROOT_DIR}"
		PATH_SUFFIXES
		linux-2.6)
endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VirtuoseAPI
	DEFAULT_MSG
	VIRTUOSEAPI_LIBRARY
	VIRTUOSEAPI_RUNTIME_LIBRARY
	VIRTUOSEAPI_INCLUDE_DIR)

if(VIRTUOSEAPI_FOUND)
	set(VIRTUOSEAPI_LIBRARIES "${VIRTUOSEAPI_LIBRARY}")
	set(VIRTUOSEAPI_INCLUDE_DIRS "${VIRTUOSEAPI_INCLUDE_DIR}")
	get_filename_component(VIRTUOSEAPI_RUNTIME_LIBRARY_DIRS "${VIRTUOSEAPI_RUNTIME_LIBRARY}" PATH)

	mark_as_advanced(VIRTUOSEAPI_ROOT_DIR)
endif()

mark_as_advanced(VIRTUOSEAPI_LIBRARY
	VIRTUOSEAPI_RUNTIME_LIBRARY
	VIRTUOSEAPI_INCLUDE_DIR)
