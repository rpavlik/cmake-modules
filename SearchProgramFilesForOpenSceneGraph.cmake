# - Use some smarts to try to find OpenSceneGraph in the Program Files dirs
#
# Also uses the OSGHOME environment variable as OSG_DIR, if it's found.
#
# Usage:
#  include(SearchProgramFilesForOpenSceneGraph OPTIONAL)
#
# Requires these CMake modules:
#  ListFilter
#  ProgramFilesGlob
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

include(ListFilter)
include(ProgramFilesGlob)
include(CleanDirectoryList)

# Try to find an OSG installation
set(_osgpaths)
if(WIN32)
	program_files_glob(_osgpaths "/OpenSceneGraph*")
	if(_osgpaths)
		if(MSVC80)
			list_filter_out(_osgpaths "[vV][cC]9" ${_osgpaths})
		elseif(MSVC90)
			list_filter_out(_osgpaths "[vV][cC]8" ${_osgpaths})
		endif()
		list(SORT _osgpaths)
		list(REVERSE _osgpaths)
	endif()
else()
	prefix_list_glob(_osgpaths "/OpenSceneGraph*" /usr /usr/local /opt)
	if(_osgpaths)
		clean_directory_list(_osgpaths)
		if(_osgpaths)
			list(SORT _osgpaths)
			list(REVERSE _osgpaths)
		endif()
	endif()
endif()


if(_osgpaths)
	# Want them in reverse order so newer versions come up first
	list(SORT _osgpaths)
	list(REVERSE _osgpaths)

	# fallback last-ditch effort - use the environment variable
	list(APPEND _osgpaths "$ENV{OSGHOME}")
	clean_directory_list(_osgpaths)

	list(APPEND CMAKE_PREFIX_PATH ${_osgpaths})
endif()

# Not completely related
set(OpenSceneGraph_MARK_AS_ADVANCED TRUE)
