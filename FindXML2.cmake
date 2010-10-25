# - try to find the libxml2 library
#
# FindXML2.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  XML2_LIBRARY
#  XML2_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  XML2_FOUND
#  XML2_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  XML2_LIBRARIES
#  XML2_INCLUDE_DIRS
#  XML2_LINKER_FLAGS
#
# Use this module this way:
#  find_package(XML2)
#  include_directories(XML2_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${XML2_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${XML2_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#
# Author:
#   Kevin M. Godby <kevin@godby.org>

# If pkg-config is available, we'll use its information as a hint to cmake
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_xml2_hint libxml-2.0)
endif()

# Find the xml2 library
find_library(XML2_LIBRARY
	NAMES
	xml2
	xml-2.0
	HINTS
	${_xml2_hint_LIBRARY_DIRS}
	${_xml2_hint_LIBRARY_DIR}
	${XML_ROOT}
	PATHS
	${XML2_ROOT}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

# Find the xml2 include path
find_path(XML2_INCLUDE_DIR
	NAMES
	libxml/xmlreader.h
	HINTS
	${_xml2_hint_INCLUDE_DIRS}
	${_xml2_hint_INCLUDE_DIR}
	${XML_ROOT}
	PATHS
	${XML2_ROOT}
	PATH_SUFFIXES
	include
	include/libxml2
	include/libxml
)

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(XML2
	DEFAULT_MSG
	XML2_LIBRARY
	XML2_INCLUDE_DIR
	XML2_FOUND)

if(XML2_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(XML2_LIBRARIES ${XML2_LIBRARY})
	set(XML2_INCLUDE_DIRS ${XML2_INCLUDE_DIR})
	set(XML2_LINKER_FLAGS "")
endif()

if(XML2_FOUND OR XML2_MARK_AS_ADVANCED)
	foreach(_cachevar
		XML2_LIBRARY
		XML2_INCLUDE_DIR)
		mark_as_advanced(${_cachevar})
	endforeach()
endif()

# End of FindXML2.cmake

