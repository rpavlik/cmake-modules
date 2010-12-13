# - A script to turn a VR Juggler app target into a Mac OS X bundle
#
#  add_vrjuggler_bundle_sources(SOURCES_VAR_NAME) - run before add_executable
#  finish_vrjuggler_bundle(TARGET_NAME LIB_DIRS) - run after add_executable
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright Iowa State University 2009-2010.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

function(add_vrjuggler_bundle_sources _target_sources)
	if(APPLE)
		if(NOT MACOSX_PACKAGE_DIR)
			set(MACOSX_PACKAGE_DIR ${CMAKE_SOURCE_DIR}/cmake/package/macosx)
		endif()

		set(_vj_base_dir .)
		set(_vj_data_dir ${vj_base_dir}/share/vrjuggler-2.2)

		# Append Mac-specific sources to source list
		set(_vj_bundle_src
			${MACOSX_PACKAGE_DIR}/Resources/vrjuggler.icns
			${MACOSX_PACKAGE_DIR}/Resources/vrjuggler.plist
			${MACOSX_PACKAGE_DIR}/Resources/en.lproj/MainMenu.nib/classes.nib
			${MACOSX_PACKAGE_DIR}/Resources/en.lproj/MainMenu.nib/info.nib
			${MACOSX_PACKAGE_DIR}/Resources/en.lproj/MainMenu.nib/keyedobjects.nib)

		# Add and set destination of VR Juggler required files

		# configFiles *.jconf
		file(GLOB
			_vj_config_files
			${VRJ22_LIBRARY_DIR}/../share/vrjuggler-2.2/data/configFiles/*.jconf)
		list(APPEND _vj_bundle_src ${_vj_config_files})

		# definitions *.jdef
		file(GLOB
			_vj_defs_files
			${VRJ22_LIBRARY_DIR}/../share/vrjuggler-2.2/data/definitions/*.jdef)
		list(APPEND _vj_bundle_src ${_vj_defs_files})

		# models *.flt
		file(GLOB
			_vj_model_files
			${VRJ22_LIBRARY_DIR}/../share/vrjuggler-2.2/data/models/*.flt)
		list(APPEND _vj_bundle_src ${_vj_model_files})

		# sounds *.wav
		file(GLOB
			_vj_sound_files
			${VRJ22_LIBRARY_DIR}/../share/vrjuggler-2.2/data/sounds/*.wav)
		list(APPEND _vj_bundle_src ${_vj_sound_files})

		# calibration.table - needed?
		list(APPEND
			_vj_bundle_src
			${VRJ22_LIBRARY_DIR}/../share/vrjuggler-2.2/data/calibration.table)

		message(STATUS "vjbundlesrc: ${_vj_bundle_src}")
		set(${_target_sources}
			${${_target_sources}}
			${_vj_bundle_src}
			PARENT_SCOPE)

		# Set destination of nib files
		set_source_files_properties(${MACOSX_PACKAGE_DIR}/Resources/en.lproj/MainMenu.nib/classes.nib
			${MACOSX_PACKAGE_DIR}/Resources/en.lproj/MainMenu.nib/info.nib
			${MACOSX_PACKAGE_DIR}/Resources/en.lproj/MainMenu.nib/keyedobjects.nib
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			Resources/en.lproj/MainMenu.nib/)

		# Set destination of Resources
		set_source_files_properties(${MACOSX_PACKAGE_DIR}/Resources/vrjuggler.icns
			${MACOSX_PACKAGE_DIR}/Resources/vrjuggler.plist
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			Resources/)

		set_source_files_properties(${_vj_config_files}
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			${_vj_data_dir}/data/configFiles/)
		set_source_files_properties(${_vj_defs_files}
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			${_vj_data_dir}/data/definitions/)
		set_source_files_properties(${_vj_model_files}
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			${_vj_data_dir}/data/models/)
		set_source_files_properties(${_vj_sound_files}
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			${_vj_data_dir}/data/sounds/)
		set_source_files_properties(${VRJ22_LIBRARY_DIR}/../share/vrjuggler-2.2/data/calibration.table
			PROPERTIES
			MACOSX_PACKAGE_LOCATION
			${_vj_data_dir}/data/)

	endif()
endfunction()

function(finish_vrjuggler_bundle _target _libdirs)
	if(APPLE)
		if(NOT MACOSX_PACKAGE_DIR)
			set(MACOSX_PACKAGE_DIR ${CMAKE_SOURCE_DIR}/cmake/package/macosx)
		endif()
		set_target_properties(${_target}
			PROPERTIES
			MACOSX_BUNDLE
			true
			MACOSX_BUNDLE_INFO_PLIST
			${MACOSX_PACKAGE_DIR}/VRJuggler22BundleInfo.plist.in
			MACOSX_BUNDLE_ICON_FILE
			vrjuggler.icns
			MACOSX_BUNDLE_INFO_STRING
			"${PROJECT_NAME} (VR Juggler Application) version ${CPACK_PACKAGE_VERSION}, created by ${CPACK_PACKAGE_VENDOR}"
			MACOSX_BUNDLE_GUI_IDENTIFIER
			org.vrjuggler.${PROJECT_NAME}
			MACOSX_BUNDLE_SHORT_VERSION_STRING
			${CPACK_PACKAGE_VERSION}
			MACOSX_BUNDLE_BUNDLE_VERSION
			${CPACK_PACKAGE_VERSION})

		set(BUNDLE_LIBS
			libboost_filesystem-1_34_1.dylib
			libboost_signals-1_34_1.dylib)
		set(BUNDLE_LIB_DIRS ${_libdirs})

		configure_file(${MACOSX_PACKAGE_DIR}/fixupbundle.cmake.in
			${CMAKE_CURRENT_BINARY_DIR}/${_target}-fixupbundle.cmake
			@ONLY)
		add_custom_command(TARGET
			${_target}
			POST_BUILD
			COMMAND
			${CMAKE_COMMAND}
			-P
			${CMAKE_CURRENT_BINARY_DIR}/${_target}-fixupbundle.cmake
			VERBATIM)

	endif()
endfunction()
