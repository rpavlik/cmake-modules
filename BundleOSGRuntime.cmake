# - Include the OpenSceneGraph runtime files in an installation or built package.
#
#  OSGRUNTIME_BUNDLE - Set to "yes" to enable this behavior
#  OSGRUNTIME_zlib1dll - Must be set to the location of zlib1.dll on Windows
#  OSGRUNTIME_zlib1ddll - Can be set to the location of zlib1d.dll (debug) on Windows.
#                         If set, will be installed.
#
# Requires these CMake modules:
#  no additional modules required
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

if(OPENSCENEGRAPH_FOUND)
	if(WIN32)
		get_filename_component(_osglibdir "${OSG_LIBRARY}" PATH)
		get_filename_component(_osgroot "${_osglibdir}/.." ABSOLUTE)
		find_file(OSGBUNDLE_zlib1dll
			zlib1.dll
			PATHS
			"${_osgroot}/bin"
			"${_osgroot}/lib")
		find_file(OSGBUNDLE_zlib1ddll
			zlib1d.dll
			PATHS
			"${_osgroot}/bin"
			"${_osgroot}/lib")
		mark_as_advanced(OSGBUNDLE_zlib1dll OSGBUNDLE_zlib1ddll)
		set(_osgbundle_required OSGBUNDLE_zlib1dll)
		set(_osgbundle_platformOK on)
	else()
		# TODO - how to handle when not on Windows?
	endif()
endif()

if(_osgbundle_platformOK)
	set(_osgbundle_caninstall on)
	foreach(_var ${_osgbundle_required})
		if(NOT ${_var})
			# If we are missing a single required file, cut out now.
			set(_osgbundle_caninstall off)
			option(OSGRUNTIME_BUNDLE
				"Install a local copy of the OpenSceneGraph runtime files with the project."
				off)
		endif()
	endforeach()
	if(_osgbundle_caninstall)
		option(OSGRUNTIME_BUNDLE
			"Install a local copy of the OpenSceneGraph runtime files with the project."
			on)
	endif()
endif()

mark_as_advanced(OSGRUNTIME_BUNDLE)

if(OSGRUNTIME_BUNDLE AND OPENSCENEGRAPH_FOUND AND _osgbundle_caninstall)
	if(WIN32)
		install(FILES "${OSGBUNDLE_zlib1dll}"
				DESTINATION bin)

		if(OSGBUNDLE_zlib1ddll)
			install(FILES "${OSGBUNDLE_zlib1ddll}"
				DESTINATION bin)
		endif()

		install(DIRECTORY "${_osgroot}/bin/" "${_osgroot}/lib/"
				DESTINATION bin
				FILES_MATCHING

				# Runtime files
				PATTERN "*.dll")
	else()
		# TODO - how to handle when not on Windows?
	endif()
endif()
