cmake_minimum_required(VERSION 3.15)
project(runner LANGUAGES CXX)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4002")

add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)
apply_standard_settings(${BINARY_NAME})
set_target_properties(
  ${BINARY_NAME} PROPERTIES
  VS_PROJECT_IMPORT ${CMAKE_CURRENT_SOURCE_DIR}/external/Microsoft.Windows.CppWinRT/build/native/Microsoft.Windows.CppWinRT.props
)
target_link_libraries(
  ${BINARY_NAME} PRIVATE
  flutter
  flutter_wrapper_app
  ${CMAKE_CURRENT_SOURCE_DIR}/external/Microsoft.Windows.CppWinRT/build/native/Microsoft.Windows.CppWinRT.targets
)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")
add_dependencies(${BINARY_NAME} flutter_assemble)
