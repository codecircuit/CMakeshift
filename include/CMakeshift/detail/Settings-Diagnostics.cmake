
# CMakeshift
# detail/Settings-Diagnostics.cmake
# Author: Moritz Beutel



list(APPEND _CMAKESHIFT_KNOWN_CUMULATIVE_SETTINGS
    "diagnostics")

list(APPEND _CMAKESHIFT_KNOWN_SETTINGS
    "fatal-errors"
    "pedantic"
    "disable-annoying-warnings"
    "diagnostics-pedantic"
    "diagnostics-paranoid"
    "diagnostics-disable-annoying")


function(_CMAKESHIFT_SETTINGS_DIAGNOSTICS SETTING VAL TARGET_NAME SCOPE LB RB)

    if(SETTING STREQUAL "pedantic")
        message(DEPRECATION "cmakeshift_target_compile_settings(): the setting \"pedantic\" has been renamed to \"diagnostics-pedantic\"")
        SET(SETTING "diagnostics-pedantic")

    elseif(SETTING STREQUAL "disable-annoying-warnings")
        message(DEPRECATION "cmakeshift_target_compile_settings(): the setting \"disable-annoying-warnings\" has been renamed to \"diagnostics-disable-annoying\"")
        SET(SETTING "diagnostics-disable-annoying")
    endif()

    if(SETTING STREQUAL "diagnostics-pedantic")
        # highest sensible level for warnings and diagnostics
        if(MSVC)
            # remove "/Wx" from CMAKE_CXX_FLAGS if present, as VC++ doesn't tolerate more than one "/Wx" flag
            if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
                string(REGEX REPLACE "/W[0-4]" " " CMAKE_CXX_FLAGS_NEW "${CMAKE_CXX_FLAGS}")
                cmakeshift_update_cache_variable_(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS_NEW}")
            endif()
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}/W4${RB}")
        elseif(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}-Wall${RB}" "${LB}-Wextra${RB}" "${LB}-pedantic${RB}")
        endif()

    elseif(SETTING STREQUAL "diagnostics-paranoid")
        # enable extra paranoid warnings
        if(MSVC)
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}/w44062${RB}") # enumerator 'identifier' in a switch of enum 'enumeration' is not handled
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}/w44242${RB}") # 'identifier': conversion from 'type1' to 'type2', possible loss of data
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}/w44254${RB}") # 'operator': conversion from 'type1' to 'type2', possible loss of data
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}/w44265${RB}") # 'class': class has virtual functions, but destructor is not virtual
            #target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}/w44365${RB}") # 'action': conversion from 'type_1' to 'type_2', signed/unsigned mismatch (cannot enable this one because it flags `container[signed_index]`)
        endif()

    elseif(SETTING STREQUAL "fatal-errors")
        # every error is fatal; stop after reporting first error
        if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}-fmax-errors=1${RB}")
        elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}-ferror-limit=1${RB}")
        endif()

    elseif(SETTING STREQUAL "diagnostics-disable-annoying")
        # disable annoying warnings
        if(MSVC)
            # C4324 (structure was padded due to alignment specifier)
            target_compile_options(${TARGET_NAME} ${SCOPE} "${LB}/wd4324${RB}")
            # secure CRT warnings (e.g. "use sprintf_s rather than sprintf")
            target_compile_definitions(${TARGET_NAME} ${SCOPE} "${LB}_CRT_SECURE_NO_WARNINGS${RB}")
        endif()

    else()
        set(_SETTING_SET FALSE PARENT_SCOPE)
    endif()

endfunction()
