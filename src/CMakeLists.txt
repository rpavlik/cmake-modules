# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu>
# http://academic.cleardefinition.com/
# Iowa State University HCI Graduate Program/VRAC

if(BUILD_WITH_VPS)
	#add_subdirectory(vps)
endif()

set(SOURCES
	SpartaMain.cpp)
	
add_executable(sparta ${SOURCES})
target_link_libraries(sparta ${VRJUGGLUA_LIBRARIES})

