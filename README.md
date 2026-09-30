## onnxruntime_vendor

Vendor package for [ONNX Runtime](https://onnxruntime.ai/).

Downloads the official prebuilt ONNX Runtime Linux x86_64 binary at build time and exposes it as a CMake imported target (`onnxruntime::onnxruntime`) for use by other ROS 2 packages.

### Building

```bash
colcon build --packages-select onnxruntime_vendor
```

ONNX Runtime is fetched automatically from GitHub releases during the build — no manual download required.

### Using in another package

In your `CMakeLists.txt`:

```cmake
find_package(onnxruntime_vendor REQUIRED)

target_link_libraries(my_target PRIVATE onnxruntime::onnxruntime)
```

Linking the `onnxruntime::onnxruntime` target brings in the headers and
`libonnxruntime.so` automatically. Runtime discovery of the shared library is
primarily handled via a canonical absolute RPATH baked into consuming binaries
at link time (pointing at `opt/onnxruntime_vendor/lib`), so no manual
`LD_LIBRARY_PATH` configuration is required — this works whether the consumer
is run from a sourced colcon workspace or from a Debian-installed prefix. An
environment hook that also prepends `opt/onnxruntime_vendor/lib` to
`LD_LIBRARY_PATH` when the workspace is sourced is installed as a secondary
fallback (e.g. for `dlopen`'d providers such as `libonnxruntime_providers_shared.so`).

In your `package.xml`:

```xml
<depend>onnxruntime_vendor</depend>
```

The installed layout under `opt/onnxruntime_vendor/` mirrors the upstream ONNX Runtime release tarball:

```
opt/onnxruntime_vendor/
  include/   # ONNX Runtime headers
  lib/       # libonnxruntime.so and related libraries
```

### Licensing

This package is part of a larger project licensed under the Apache License 2.0 (see the top-level `LICENSE` file).

ONNX Runtime itself is developed by Microsoft Corporation and distributed under the MIT License. The prebuilt ONNX Runtime binaries and headers used by this vendor package are obtained from the official `microsoft/onnxruntime` GitHub releases.

For the full ONNX Runtime license text, see `LICENSE-ONNXRUNTIME` in this directory.