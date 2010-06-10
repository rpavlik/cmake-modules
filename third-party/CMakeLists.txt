# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu>
# http://academic.cleardefinition.com/
# Iowa State University HCI Graduate Program/VRAC

if(BUILD_EMBEDDED_LUA)
	add_subdirectory(lua-5.1.4/src)
	set(LUA_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/lua-5.1.4/src")
	set(LUA_INCLUDE_DIRS ${LUA_INCLUDE_DIRS} PARENT_SCOPE)
	set(LUA_LIBRARIES lua)
	set(LUA_LIBRARIES ${LUA_LIBRARIES} PARENT_SCOPE)

	add_subdirectory(luabind)
	set(LUABIND_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/luabind" ${LUA_INCLUDE_DIRS})
	set(LUABIND_INCLUDE_DIRS ${LUABIND_INCLUDE_DIRS} PARENT_SCOPE)

	add_subdirectory(osgLua)
	set(OSGLUA_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/osgLua/include" "${CMAKE_CURRENT_SOURCE_DIR}/osgLua/src" ${LUA_INCLUDE_DIRS})
	set(OSGLUA_INCLUDE_DIRS ${OSGLUA_INCLUDE_DIRS} PARENT_SCOPE)
endif()

if(BUILD_FLTK_GUI)
	add_subdirectory(Fl_Native_File_Chooser-0.86)
	set(FNFC_LIBRARY ${FNFC_LIBRARY} PARENT_SCOPE)
	set(FNFC_INCLUDE_DIRS ${FNFC_INCLUDE_DIRS} PARENT_SCOPE)
endif()
