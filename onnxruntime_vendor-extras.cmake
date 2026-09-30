if(NOT TARGET onnxruntime::onnxruntime)
  # Resolve to a canonical absolute path at configure time rather than baking
  # "${onnxruntime_vendor_DIR}/../../../opt/onnxruntime_vendor/lib" verbatim into the
  # consumer's RPATH: the dynamic loader resolves RPATH entries physically (left-to-right,
  # without collapsing "..") rather than lexically, and share/onnxruntime_vendor/cmake/
  # (the dir onnxruntime_vendor_DIR points into) is a build-time artifact that gets
  # stripped from runtime Debian packages, which silently breaks the whole entry.
  get_filename_component(_onnxruntime_vendor_libdir
    "${onnxruntime_vendor_DIR}/../../../opt/onnxruntime_vendor/lib" REALPATH)
  get_filename_component(_onnxruntime_vendor_incdir
    "${onnxruntime_vendor_DIR}/../../../opt/onnxruntime_vendor/include" REALPATH)

  add_library(onnxruntime::onnxruntime SHARED IMPORTED)
  set_target_properties(onnxruntime::onnxruntime PROPERTIES
    IMPORTED_LOCATION "${_onnxruntime_vendor_libdir}/libonnxruntime.so"
    INTERFACE_INCLUDE_DIRECTORIES "${_onnxruntime_vendor_incdir}"
    INTERFACE_LINK_OPTIONS "LINKER:-rpath,${_onnxruntime_vendor_libdir}"
  )
endif()

set(onnxruntime_vendor_LIBRARIES onnxruntime::onnxruntime)
set(onnxruntime_vendor_LIBRARY_DIRS "${_onnxruntime_vendor_libdir}")