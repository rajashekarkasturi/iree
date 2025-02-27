# Copyright 2022 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Tests for end-to-end IREE support specific to the CUDA backend to be able to
# incrementally enable features.

iree_add_all_subdirs()

iree_check_single_backend_test_suite(
  NAME
    check_cuda
  SRCS
    "dot.mlir"
  TARGET_BACKEND
    "cuda"
  DRIVER
    "cuda"
  COMPILER_FLAGS
    "-iree-input-type=mhlo"
  LABELS
    "noasan"
    "nomsan"
    "notsan"
    "noubsan"
    "requires-gpu-nvidia"
)
