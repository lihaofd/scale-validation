#!/bin/bash

set -ETeuo pipefail
source "$(dirname "$0")"/../util/args.sh "$@"

mkdir -p "${OUT_DIR}/timemachine"
cd "${OUT_DIR}/timemachine"

do_clone_hash timemachine https://github.com/proteneer/timemachine.git 01f14f8

# Upstream bug means `CMAKE_CXX_FLAGS` fails with this project,
# so disable Werror a weirder way:
sed -Ee 's/-Werror ?(all-warnings ?)?//g' -i"" timemachine/timemachine/cpp/CMakeLists.txt
