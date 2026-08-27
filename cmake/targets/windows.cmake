# windows specific target definitions
set_target_properties(sunshine PROPERTIES LINK_SEARCH_START_STATIC 1)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll")
find_library(ZLIB ZLIB1)
list(APPEND SUNSHINE_EXTERNAL_LIBRARIES
        Windowsapp.lib
        Wtsapi32.lib)

# Web-only distribution: the Tauri desktop GUI (sunshine-control-panel) is not
# built or bundled. Management is via the web UI at https://localhost:47990.
