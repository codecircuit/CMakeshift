#.rst:
# FindHSL
# --------
#
# Find the HSL Mathematical Software Library.
# See http://www.hsl.rl.ac.uk/index.html
#
# This will define the following variables::
#
#   HSL_FOUND      - True if the HSL was found
#
# and the following imported targets::
#
#   HSL::mc64       - http://www.hsl.rl.ac.uk/catalogue/mc64.html
#

include(FindPackageHandleStandardArgs)

if (NOT HSL_FIND_COMPONENTS)
    set(HSL_FIND_COMPONENTS mc64)
    foreach (_hsl_component IN LISTS HSL_FIND_COMPONENTS)
        set(HSL_FIND_REQUIRED_${_hsl_component} 1)
    endforeach()
endif()

find_library(GFORTRAN_LIB NAMES gfortran)

foreach(_hsl_component IN LISTS HSL_FIND_COMPONENTS)
    find_library(_hsl_lib_${_hsl_component} NAMES "hsl_${_hsl_component}")
    find_path(_hsl_include_${_hsl_component} NAMES "hsl_${_hsl_component}s.h")
    set(_hsl_lib ${_hsl_lib_${_hsl_component}})
    set(_hsl_include_dir ${_hsl_include_${_hsl_component}})
    if(_hsl_lib_${_hsl_component} AND _hsl_include_${_hsl_component})
        set(HSL_${_hsl_component}_FOUND 1)
        if(NOT TARGET HSL::${_hsl_component})
            add_library(HSL::${_hsl_component} UNKNOWN IMPORTED)
            list(APPEND HSL_IMPORTED_TARGETS HSL::${_hsl_component})
            set_target_properties(HSL::${_hsl_component} PROPERTIES
                                  IMPORTED_LOCATION     "${_hsl_lib}"
                                  INTERFACE_INCLUDE_DIRECTORIES "${_hsl_include_dir}")
            target_link_libraries(HSL::${_hsl_component} INTERFACE ${GFORTRAN_LIB} m)
        endif()
    endif()
    unset(_hsl_lib)
    unset(_hsl_include_dir)
    unset(_hsl_lib_${_hsl_component} CACHE)
    unset(_hsl_include_${_hsl_component} CACHE)
endforeach()

find_package_handle_standard_args(HSL
                                  REQUIRED_VARS HSL_IMPORTED_TARGETS
                                  HANDLE_COMPONENTS)
