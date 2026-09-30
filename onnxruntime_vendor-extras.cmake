if(NOT TARGET onnxruntime::onnxruntime)
  # Canonicalize now: RPATH entries resolve physically (no lexical ".." collapsing), and
  # onnxruntime_vendor_DIR's build-tree location won't exist in installed Debian packages.
  get_filename_component(_onnxruntime_vendor_prefix
    "${onnxruntime_vendor_DIR}/../../../opt/onnxruntime_vendor" REALPATH)
  set(_onnxruntime_vendor_libdir "${_onnxruntime_vendor_prefix}/lib")
  set(_onnxruntime_vendor_incdir "${_onnxruntime_vendor_prefix}/include")

  add_library(onnxruntime::onnxruntime SHARED IMPORTED)
  set_target_properties(onnxruntime::onnxruntime PROPERTIES
    IMPORTED_LOCATION "${_onnxruntime_vendor_libdir}/libonnxruntime.so"
    INTERFACE_INCLUDE_DIRECTORIES "${_onnxruntime_vendor_incdir}"
    INTERFACE_LINK_OPTIONS "LINKER:-rpath,${_onnxruntime_vendor_libdir}"
  )
endif()

set(onnxruntime_vendor_LIBRARIES onnxruntime::onnxruntime)
set(onnxruntime_vendor_LIBRARY_DIRS "${_onnxruntime_vendor_libdir}")
unset(_onnxruntime_vendor_prefix)
unset(_onnxruntime_vendor_libdir)
unset(_onnxruntime_vendor_incdir)