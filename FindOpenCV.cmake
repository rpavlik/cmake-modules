# - Try to find OpenCV library installation
# See http://sourceforge.net/projects/opencvlibrary/
#
# The following variable is optionally searched for defaults
#  OPENCV_ROOT_DIR:            Base directory of OpenCv tree to use.
#
# The following are set after configuration is done:
#  OPENCV_FOUND
#  OPENCV_INCLUDE_DIRS
#  OPENCV_LIBRARIES
#
# 2004/05 Jan Woetzel, Friso, Daniel Grest
# 2006/01 complete rewrite by Jan Woetzel
# 2006/09 2nd rewrite introducing ROOT_DIR and PATH_SUFFIXES
#   to handle multiple installed versions gracefully by Jan Woetzel
# 2010/02 Ryan Pavlik (Iowa State University) - partial rewrite to standardize
#
# tested with:
# -OpenCV 0.97 (beta5a):  MSVS 7.1, gcc 3.3, gcc 4.1
# -OpenCV 0.99 (1.0rc1):  MSVS 7.1
#
# www.mip.informatik.uni-kiel.de/~jw
# academic.cleardefinition.com
# --------------------------------

set(OPENCV_ROOT_DIR
	"${OPENCV_ROOT_DIR}"
	CACHE
	PATH
	"Path to search for OpenCV")

include(ProgramFilesGlob)


# required cv components with header and library if COMPONENTS unspecified
if(NOT OpenCV_FIND_COMPONENTS)
	# default
	set(OpenCV_FIND_COMPONENTS CV CXCORE CVAUX HIGHGUI)
	if(WIN32)
		list(APPEND OpenCV_FIND_COMPONENTS CVCAM)	# WIN32 only actually
	endif()
else()
	string(TOUPPER "${OpenCV_FIND_COMPONENTS}" OpenCV_FIND_COMPONENTS)
endif()


# typical root dirs of installations, exactly one of them is used
program_files_glob(_dirs "/OpenCV*/")

#
# select exactly ONE OPENCV base directory/tree
# to avoid mixing different version headers and libs
#
find_path(OPENCV_BASE_DIR
	NAMES
	cv/include/cv.h
	include/opencv/cv.h
	include/cv/cv.h
	include/cv.h
	HINTS
		"${OPENCV_ROOT_DIR}"
	"$ENV{OPENCV_ROOT_DIR}"
	"$ENV{OpenCV_ROOT_DIR}"
	"$ENV{OPENCV_DIR}"	# only for backward compatibility deprecated by ROOT_DIR
	"$ENV{OPENCV_HOME}"	# only for backward compatibility
	"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Intel(R) Open Source Computer Vision Library_is1;Inno Setup: App Path]"
	${_dirs})



# header include dir suffixes appended to OPENCV_BASE_DIR
set(OPENCV_INCDIR_SUFFIXES
	include
	include/cv
	include/opencv
	cv/include
	cxcore/include
	cvaux/include
	otherlibs/cvcam/include
	otherlibs/highgui
	otherlibs/highgui/include
	otherlibs/_graphics/include)

# library linkdir suffixes appended to OPENCV_BASE_DIR
set(OPENCV_LIBDIR_SUFFIXES lib lib64 OpenCV/lib otherlibs/_graphics/lib)


#
# find incdir for each lib
#
find_path(OPENCV_CV_INCLUDE_DIR
	NAMES
	cv.h
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_INCDIR_SUFFIXES})
find_path(OPENCV_CXCORE_INCLUDE_DIR
	NAMES
	cxcore.h
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_INCDIR_SUFFIXES})
find_path(OPENCV_CVAUX_INCLUDE_DIR
	NAMES
	cvaux.h
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_INCDIR_SUFFIXES})
find_path(OPENCV_HIGHGUI_INCLUDE_DIR
	NAMES
	highgui.h
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_INCDIR_SUFFIXES})
find_path(OPENCV_CVCAM_INCLUDE_DIR
	NAMES
	cvcam.h
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_INCDIR_SUFFIXES})

#
# find sbsolute path to all libraries
# some are optionally, some may not exist on Linux
#
find_library(OPENCV_CV_LIBRARY
	NAMES
	cv
	opencv
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})
find_library(OPENCV_CVAUX_LIBRARY
	NAMES
	cvaux
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})
find_library(OPENCV_CVCAM_LIBRARY
	NAMES
	cvcam
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})
find_library(OPENCV_CVHAARTRAINING_LIBRARY
	NAMES
	cvhaartraining
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})
find_library(OPENCV_CXCORE_LIBRARY
	NAMES
	cxcore
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})
find_library(OPENCV_CXTS_LIBRARY
	NAMES
	cxts
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})
find_library(OPENCV_HIGHGUI_LIBRARY
	NAMES
	highgui
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})
find_library(OPENCV_ML_LIBRARY
	NAMES
	ml
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})
find_library(OPENCV_TRS_LIBRARY
	NAMES
	trs
	HINTS
	${OPENCV_BASE_DIR}
	PATH_SUFFIXES
	${OPENCV_LIBDIR_SUFFIXES})



#
# Logic selecting required libs and headers
#

set(_req_check)
set(_req_libs)
set(_req_includes)
foreach(NAME ${OpenCV_FIND_COMPONENTS})

	# only good if header and library both found
	list(APPEND _req_check OPENCV_${NAME}_LIBRARY OPENCV_${NAME}_INCLUDE_DIR)
	list(APPEND _req_libs "${OPENCV_${NAME}_LIBRARY}")
	list(APPEND _req_includes "${OPENCV_${NAME}_INCLUDE_DIR}")

endforeach()

# get the link directory for rpath to be used with LINK_DIRECTORIES:
if(OPENCV_CV_LIBRARY)

endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(OpenCV
	DEFAULT_MSG
	${_req_check})

if(OPENCV_FOUND)
	get_filename_component(OPENCV_LIBRARY_DIRS ${OPENCV_CV_LIBRARY} PATH)
	set(OPENCV_INCLUDE_DIRS ${_req_includes})
	set(OPENCV_LIBRARIES ${_req_libs})
	mark_as_advanced(OPENCV_ROOT_DIR)
endif()

mark_as_advanced(OPENCV_INCLUDE_DIRS
	OPENCV_CV_INCLUDE_DIR
	OPENCV_CXCORE_INCLUDE_DIR
	OPENCV_CVAUX_INCLUDE_DIR
	OPENCV_CVCAM_INCLUDE_DIR
	OPENCV_HIGHGUI_INCLUDE_DIR
	OPENCV_LIBRARIES
	OPENCV_CV_LIBRARY
	OPENCV_CXCORE_LIBRARY
	OPENCV_CVAUX_LIBRARY
	OPENCV_CVCAM_LIBRARY
	OPENCV_CVHAARTRAINING_LIBRARY
	OPENCV_CXTS_LIBRARY
	OPENCV_HIGHGUI_LIBRARY
	OPENCV_ML_LIBRARY
	OPENCV_TRS_LIBRARY)
