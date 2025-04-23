#!/bin/bash

set -e
SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "${SCRIPT_DIR}"/../util/args.sh "$@"

mkdir -p "${OUT_DIR}/caffe/build"
cd "${OUT_DIR}/caffe/build"

# Configure.
cmake \
    -DUSE_CUDNN=OFF \
    -DUSE_OPENCV=OFF \
    -DBLAS=Open \
    -DBUILD_docs=OFF \
    -DCUDA_ARCH_NAME=Manual \
    -DCUDA_ARCH_BIN="${GPU_ARCH}" \
    -DCUDA_ARCH_PTX="${GPU_ARCH}" \
    -DCUDA_TOOLKIT_ROOT_DIR="${CUDA_PATH}" \
    -DCMAKE_C_COMPILER="${CUDA_PATH}/bin/gcc" \
    -DCMAKE_CXX_COMPILER="${CUDA_PATH}/bin/g++" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$(pwd)/../install" \
    -Dpython_version=3 \
    ../caffe

# Make sure we actually found CUDA.
"${SCRIPT_DIR}"/../util/check-cmake-cuda-version.sh "${OUT_DIR}/caffe/build"

# Build
if [ "${VERBOSE}" == "1" ] ; then
    VERBOSE="VERBOSE=1"
else
    VERBOSE=
fi
make -j"${BUILD_JOBS}" install ${VERBOSE}
make -j"${BUILD_JOBS}" test.testbin ${VERBOSE}
