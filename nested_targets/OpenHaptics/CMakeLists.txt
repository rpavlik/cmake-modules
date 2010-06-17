
include_directories("${HDAPI_HDU_INCLUDE_DIR}"
	"${HDAPI_INCLUDE_DIR}"
	"${HLAPI_HLU_INCLUDE_DIR}"
	"${HLAPI_INCLUDE_DIR}")

if(HDAPI_HDU_LIBRARY STREQUAL "openhaptics_hdu_nested_target")
	add_library(openhaptics_hdu_nested_target
		STATIC
		EXCLUDE_FROM_ALL
		"${HDAPI_HDU_SOURCE_DIR}/src/hdu.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduAfx.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduAfx.h"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduDecompose.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduDecompose.h"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduError.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduHapticDevice.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduLine.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduLineSegment.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduMatrix.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduPlane.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduQuaternion.cpp"
		"${HDAPI_HDU_SOURCE_DIR}/src/hduRecord.cpp")
	target_link_libraries(openhaptics_hdu_nested_target ${HDAPI_LIBRARIES})
	set_property(TARGET
		openhaptics_hdu_nested_target
		PROPERTY
		PROJECT_LABEL
		"OpenHaptics HDU Library")

	set_property(TARGET
		openhaptics_hdu_nested_target
		PROPERTY
		EXCLUDE_FROM_ALL
		YES)

	if(MSVC)
		# Disable warnings - no sense in warning about Sensable's potential bugs.
		set_property(TARGET
			openhaptics_hdu_nested_target
			APPEND
			PROPERTY
			COMPILE_FLAGS
			/wd4189)
	endif()
endif()


if(HLAPI_HLU_LIBRARY STREQUAL "openhaptics_hlu_nested_target")
	add_library(openhaptics_hlu_nested_target
		STATIC
		EXCLUDE_FROM_ALL
		"${HLAPI_HLU_SOURCE_DIR}/src/hlu.cpp"
		"${HLAPI_HLU_SOURCE_DIR}/src/hluAfx.cpp"
		"${HLAPI_HLU_SOURCE_DIR}/src/hluAfx.h")
	target_link_libraries(openhaptics_hlu_nested_target ${HLAPI_LIBRARIES})

	set_property(TARGET
		openhaptics_hlu_nested_target
		PROPERTY
		PROJECT_LABEL
		"OpenHaptics HLU Library")

	set_property(TARGET
		openhaptics_hlu_nested_target
		PROPERTY
		EXCLUDE_FROM_ALL
		YES)

	if(MSVC)
		# Disable warnings - no sense in warning about Sensable's potential bugs.
		set_property(TARGET
			openhaptics_hlu_nested_target
			APPEND
			PROPERTY
			COMPILE_FLAGS
			/wd4189)
	endif()
endif()
