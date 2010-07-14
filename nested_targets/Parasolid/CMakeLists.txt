
include_directories("${HDAPI_HDU_INCLUDE_DIR}"
	"${HDAPI_INCLUDE_DIR}"
	"${HLAPI_HLU_INCLUDE_DIR}"
	"${HLAPI_INCLUDE_DIR}")

if(PARASOLID_fg_LIBRARY STREQUAL "parasolid_fg_nested_target")
	get_filename_component(_fgdir "${PARASOLID_FG_C}" PATH)
	include_directories("${_fgdir}")
	add_library(parasolid_fg_nested_target
		STATIC
		EXCLUDE_FROM_ALL
		"${PARASOLID_FG_C}")

	set_property(TARGET
		parasolid_fg_nested_target
		PROPERTY
		COMPILE_DEFINITIONS
		_CRT_SECURE_NO_DEPRECATE)
	if(MSVC)
		set_property(TARGET
			parasolid_fg_nested_target
			PROPERTY
			COMPILE_FLAGS
			"/Gs /GF /GS- /fp:fast")
	endif()

	set_property(TARGET
		parasolid_fg_nested_target
		PROPERTY
		PROJECT_LABEL
		"Parasolid Foreign Geometry Example Library")
	set_property(TARGET
		parasolid_fg_nested_target
		PROPERTY
		EXCLUDE_FROM_ALL
		YES)

	if(MSVC)
		# Disable warnings - no sense in warning about a third party's potential bugs.
		# set_property(TARGET
			# parasolid_fg_nested_target
			# PROPERTY
			# COMPILE_FLAGS
			# "/wd4189 /wd4701")
	endif()
endif()


if(PARASOLID_frustrum_LIBRARY STREQUAL "parasolid_frustrum_nested_target")
	get_filename_component(_frustrumdir "${PARASOLID_FRUSTRUM_C}" PATH)
	include_directories("${_frustrumdir}")
	add_library(parasolid_frustrum_nested_target
		STATIC
		EXCLUDE_FROM_ALL
		"${PARASOLID_FRUSTRUM_C}")

	set_property(TARGET
		parasolid_frustrum_nested_target
		PROPERTY
		COMPILE_DEFINITIONS
		_CRT_SECURE_NO_DEPRECATE)
	if(MSVC)
		set_property(TARGET
			parasolid_frustrum_nested_target
			PROPERTY
			COMPILE_FLAGS
			"/Gs /GF /GS- /fp:fast")
	endif()

	set_property(TARGET
		parasolid_frustrum_nested_target
		PROPERTY
		PROJECT_LABEL
		"Parasolid Frustrum Example Library")
	set_property(TARGET
		parasolid_frustrum_nested_target
		PROPERTY
		EXCLUDE_FROM_ALL
		YES)

	if(MSVC)
		# Disable warnings - no sense in warning about a third party's potential bugs.
		# set_property(TARGET
			# parasolid_frustrum_nested_target
			# PROPERTY
			# COMPILE_FLAGS
			# "/wd4189 /wd4701")
	endif()
endif()
