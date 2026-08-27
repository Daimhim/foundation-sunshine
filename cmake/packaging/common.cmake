# common packaging

# common cpack options
set(CPACK_PACKAGE_NAME ${CMAKE_PROJECT_NAME})
set(CPACK_PACKAGE_VENDOR "qiin2333")
string(REGEX REPLACE "^v" "" CPACK_PACKAGE_VERSION ${PROJECT_VERSION})  # remove the v prefix if it exists
set(CPACK_PACKAGE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cpack_artifacts)
set(CPACK_PACKAGE_CONTACT "https://alkaidlab.com")
set(CPACK_PACKAGE_DESCRIPTION ${CMAKE_PROJECT_DESCRIPTION})
set(CPACK_PACKAGE_HOMEPAGE_URL ${CMAKE_PROJECT_HOMEPAGE_URL})
set(CPACK_RESOURCE_FILE_LICENSE ${PROJECT_SOURCE_DIR}/LICENSE)
set(CPACK_PACKAGE_ICON ${PROJECT_SOURCE_DIR}/sunshine.png)
set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}")
set(CPACK_STRIP_FILES YES)

# install common assets
install(DIRECTORY "${SUNSHINE_SOURCE_ASSETS_DIR}/common/assets/"
        DESTINATION "${SUNSHINE_ASSETS_DIR}"
        PATTERN "web" EXCLUDE)

# install ABR prompt template
install(FILES "${PROJECT_SOURCE_DIR}/src/assets/abr_prompt.md"
        DESTINATION "${SUNSHINE_ASSETS_DIR}")
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/assets")
configure_file("${PROJECT_SOURCE_DIR}/src/assets/abr_prompt.md"
               "${CMAKE_CURRENT_BINARY_DIR}/assets/abr_prompt.md"
               COPYONLY)
# copy assets to build directory, for running without install
file(GLOB_RECURSE ALL_ASSETS
        RELATIVE "${SUNSHINE_SOURCE_ASSETS_DIR}/common/assets/" "${SUNSHINE_SOURCE_ASSETS_DIR}/common/assets/*")
list(FILTER ALL_ASSETS EXCLUDE REGEX "^web/.*$")  # Filter out the web directory
foreach(asset ${ALL_ASSETS})  # Copy assets to build directory, excluding the web directory
    file(COPY "${SUNSHINE_SOURCE_ASSETS_DIR}/common/assets/${asset}"
            DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/assets")
endforeach()

# install built vite assets
install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/assets/web"
        DESTINATION "${SUNSHINE_ASSETS_DIR}")

# Web-only distribution: the desktop GUI (sunshine-control-panel / sunshine-gui.exe)
# is intentionally NOT bundled. Management is via the web UI at https://localhost:47990.

# platform specific packaging
if(WIN32)
    include(${CMAKE_MODULE_PATH}/packaging/windows.cmake)
elseif(UNIX)
    include(${CMAKE_MODULE_PATH}/packaging/unix.cmake)

    if(APPLE)
        include(${CMAKE_MODULE_PATH}/packaging/macos.cmake)
    else()
        include(${CMAKE_MODULE_PATH}/packaging/linux.cmake)
    endif()
endif()

include(CPack)
