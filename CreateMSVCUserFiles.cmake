# - Create a .vcproj.*.user file to set working directory, env. vars, etc.
#
#  include(CreateMSVCUserFiles) - to make these available
#  guess_dll_dirs(<outputvarname> [<extralibrary> ...])
#  create_msvc_user_files(<targetpath> <targetname> <cmdargsvarname> <dlldirsvarname>)
#
# Requires these CMake modules:
#  ListFilter
#  ProgramFilesGlob
#  CleanDirectoryList
#
# Requires CMake 2.6 or newer (uses the 'function' command)
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

if(__create_msvc_user_files)
	return()
endif()
set(__create_msvc_user_files YES)

include(CleanDirectoryList)

# We must run the following at "include" time, not at function call time,
# to find the path to this module rather than the path to a calling list file
get_filename_component(_msvcuserfilemoddir
	${CMAKE_CURRENT_LIST_FILE}
	PATH)

function(create_msvc_user_files
	_targetpath
	_targetname
	_vcmdargs
	_vdlldirs)
	file(TO_NATIVE_PATH "${CMAKE_SOURCE_DIR}" _srcroot)

	if(WIN32)
		# Find user and system name
		set(SYSTEM_NAME $ENV{USERDOMAIN})
		set(USER_NAME $ENV{USERNAME})

		if(MSVC100)
			set(USERFILE_VC_VERSION 10.00)
		elseif(MSVC90)
			set(USERFILE_VC_VERSION 9.00)
		elseif(MSVC80)
			set(USERFILE_VC_VERSION 8.00)
		elseif(MSVC71)
			set(USERFILE_VC_VERSION 7.10)
		endif()

		set(USERFILE_PLATFORM Win${BITS})
		set(_pathdelim ";")
	else()
		set(_pathdelim ":")
		set(USERFILE_PLATFORM ${CMAKE_SYSTEM_NAME}${BITS})
	endif()

	# Turn into a list of native paths
	set(USERFILE_PATHS)
	set(USERFILE_BARE_PATHS)
	foreach(_dlldir ${${_vdlldirs}})
		file(TO_NATIVE_PATH "${_dlldir}" _path)
		set(USERFILE_PATHS "${USERFILE_PATHS}${_path}${_pathdelim}")
		set(USERFILE_BARE_PATHS "${USERFILE_BARE_PATHS}${_path}${_pathdelim}")
	endforeach()

	set(USERFILE_WORKING_DIRECTORY "${_srcroot}")
	set(USERFILE_COMMAND_ARGUMENTS "${${_vcmdargs}}")

	site_name(USERFILE_REMOTE_MACHINE)
	mark_as_advanced(USERFILE_REMOTE_MACHINE)
	set(USERFILE_ENVIRONMENT "PATH=${USERFILE_PATHS}")
	if(WIN32)
		file(READ
			"${_msvcuserfilemoddir}/CreateMSVCUserFiles.env.cmd.in"
			_cmdenv)
	else()
		file(READ
			"${_msvcuserfilemoddir}/CreateMSVCUserFiles.env.sh.in"
			_cmdenv)
	endif()

	set(USERFILE_ENV_COMMANDS)
	foreach(_arg ${ARGN})
		string(CONFIGURE
			"@USERFILE_ENVIRONMENT@&#x0A;@_arg@"
			USERFILE_ENVIRONMENT
			@ONLY)
		string(CONFIGURE
			"@USERFILE_ENV_COMMANDS@${_cmdenv}"
			USERFILE_ENV_COMMANDS
			@ONLY)
	endforeach()

	if(MSVC)
		file(READ
			"${_msvcuserfilemoddir}/CreateMSVCUserFiles.perconfig.vcproj.user.in"
			_perconfig)
		set(USERFILE_CONFIGSECTIONS)
		foreach(USERFILE_CONFIGNAME ${CMAKE_CONFIGURATION_TYPES})
			get_target_property(USERFILE_${USERFILE_CONFIGNAME}_COMMAND
				${_targetname}
				LOCATION_${USERFILE_CONFIGNAME})
			file(TO_NATIVE_PATH
				"${USERFILE_${USERFILE_CONFIGNAME}_COMMAND}"
				USERFILE_${USERFILE_CONFIGNAME}_COMMAND)
			string(CONFIGURE "${_perconfig}" _temp @ONLY ESCAPE_QUOTES)
			string(CONFIGURE
				"${USERFILE_CONFIGSECTIONS}${_temp}"
				USERFILE_CONFIGSECTIONS
				ESCAPE_QUOTES)
		endforeach()


		configure_file("${_msvcuserfilemoddir}/CreateMSVCUserFiles.vcproj.user.in"
			${CMAKE_BINARY_DIR}/ALL_BUILD.vcproj.${SYSTEM_NAME}.${USER_NAME}.user
			@ONLY)
	endif()

	if(WIN32)
	foreach(_config ${CMAKE_CONFIGURATION_TYPES})
		set(USERFILE_COMMAND "${USERFILE_${_config}_COMMAND}")
			configure_file("${_msvcuserfilemoddir}/CreateMSVCUserFiles.cmd.in"
				"${CMAKE_CURRENT_BINARY_DIR}/launch-${_targetname}-${_config}.cmd"
				@ONLY)
	endforeach()
	elseif("${CMAKE_GENERATOR}" MATCHES "Makefiles")
		get_target_property(USERFILE_COMMAND
				${_targetname}
				LOCATION)
			file(TO_NATIVE_PATH
				"${USERFILE_COMMAND}"
				USERFILE_COMMAND)
		configure_file("${_msvcuserfilemoddir}/CreateMSVCUserFiles.sh.in"
				"${CMAKE_CURRENT_BINARY_DIR}/launch-${_targetname}.sh"
				@ONLY)
	endif()

endfunction()

function(guess_dll_dirs _var)
	# Start off with the link directories of the calling listfile's directory
	get_directory_property(_libdirs LINK_DIRECTORIES)

	# Add additional libraries passed to the function
	foreach(_lib ${ARGN})
		get_filename_component(_libdir "${_lib}" PATH)
		list(APPEND _libdirs "${_libdir}")
	endforeach()

	# Now, build a list of potential dll directories
	set(_dlldirs)
	foreach(_libdir ${_libdirs})
		# Add the libdir itself
		list(APPEND _dlldirs "${_libdir}")

		# Look also in libdir/../bin since the dll might not be with the lib
		get_filename_component(_libdir "${_libdir}/../bin" ABSOLUTE)
		list(APPEND _dlldirs "${_libdir}")
	endforeach()

	# Only keep the valid, unique directories
	clean_directory_list(_dlldirs)

	# Return _dlldirs
	set(${_var} "${_dlldirs}" PARENT_SCOPE)
endfunction()
