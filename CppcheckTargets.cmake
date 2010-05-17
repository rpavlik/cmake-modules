# - Run cppcheck on c++ source files as a custom target and a test
#
#  include(CppcheckTargets)
#  add_cppcheck(<target-name> [UNUSED_FUNCTIONS] [STYLE] [POSSIBLE_ERROR])
#
# Requires these CMake modules:
#  Findcppcheck
#
# Requires CMake 2.6 or newer (uses the 'function' command)
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

if(__add_cppcheck)
	return()
endif()
set(__add_cppcheck YES)

if(NOT CPPCHECK_FOUND)
	find_package(cppcheck QUIET)
endif()

if(CPPCHECK_FOUND)
	if(NOT TARGET all_cppcheck)
		add_custom_target(all_cppcheck)
		set_target_properties(all_cppcheck PROPERTIES EXCLUDE_FROM_ALL TRUE)
	endif()
endif()

function(add_cppcheck _targetname)
	if(CPPCHECK_FOUND)
		set(_cppcheck_args)

		list(FIND ARGN UNUSED_FUNCTIONS _unused_func)
		if("${_unused_func}" GREATER "-1")
			list(APPEND _cppcheck_args ${CPPCHECK_UNUSEDFUNC_ARG})
		endif()

		list(FIND ARGN STYLE _style)
		if("${_style}" GREATER "-1")
			list(APPEND _cppcheck_args ${CPPCHECK_STYLE_ARG})
		endif()

		list(FIND ARGN POSSIBLE_ERROR _poss_err)
		if("${_poss_err}" GREATER "-1")
			list(APPEND _cppcheck_args ${CPPCHECK_POSSIBLEERROR_ARG})
		endif()

		#get_directory_property(_cppcheck_include_dirs INCLUDE_DIRECTORIES)
		#set(_includeflags)
		#foreach(_dir ${_cppcheck_include_dirs})
		#	list(APPEND _cppcheck_args "${CPPCHECK_INCLUDEPATH_ARG}${_dir}")
		#endforeach()

		get_target_property(_cppcheck_sources "${_targetname}" SOURCES)
		set(_files)
		foreach(_source ${_cppcheck_sources})
			get_source_file_property(_cppcheck_lang "${_source}" LANGUAGE)
			get_source_file_property(_cppcheck_loc "${_source}" LOCATION)
			if("${_cppcheck_lang}" MATCHES "CXX")
				list(APPEND _files "${_cppcheck_loc}")
			endif()
		endforeach()

		if("1.${CMAKE_VERSION}" VERSION_LESS "1.2.8.0")
			# Older than CMake 2.8.0
			add_test(${_targetname}_cppcheck_test
				"${CPPCHECK_EXECUTABLE}"
				${CPPCHECK_TEMPLATE_ARG}
				${_cppcheck_args}
				${_files})
		else()
			# CMake 2.8.0 and newer
			add_test(NAME
				${_targetname}_cppcheck_test
				COMMAND
				"${CPPCHECK_EXECUTABLE}"
				${CPPCHECK_TEMPLATE_ARG}
				${_cppcheck_args}
				${_files})
		endif()

		set_tests_properties(${_targetname}_cppcheck_test
			PROPERTIES
			FAIL_REGULAR_EXPRESSION
			"[(]error[)]")

		add_custom_command(TARGET
			all_cppcheck
			PRE_BUILD
			COMMAND
			${CPPCHECK_EXECUTABLE}
			${CPPCHECK_QUIET_ARG}
			${CPPCHECK_TEMPLATE_ARG}
			${_cppcheck_args}
			${_files}
			WORKING_DIRECTORY
			"${CMAKE_CURRENT_SOURCE_DIR}"
			COMMENT
			"${_targetname}_cppcheck: Running cppcheck on target ${_targetname}..."
			VERBATIM)
	endif()
endfunction()
