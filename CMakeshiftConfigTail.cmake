
cmake_minimum_required(VERSION 3.14)

# Adjust module path so that CMakeshift scripts are found by libraries using this package.
list(APPEND CMAKE_MODULE_PATH "@PACKAGE_CMakeshift_DATADIR@")

# Add the CMakeshift find module path to the module path.
list(APPEND CMAKE_MODULE_PATH "@PACKAGE_CMakeshift_DATADIR@/CMakeshift/modules")