# Copyright 2021 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

iree_add_all_subdirs()

if(${IREE_ENABLE_EMITC})

iree_cc_test(
  NAME
    module_test
  SRCS
    "module_test.cc"
  DEPS
    iree::base::cc
    iree::base::logging
    iree::testing::gtest
    iree::testing::gtest_main
    iree::vm
    ::arithmetic_ops
    ::arithmetic_ops_f32
    ::arithmetic_ops_i64
    ::assignment_ops
    ::assignment_ops_f32
    ::assignment_ops_i64
    ::buffer_ops
    ::call_ops
    ::comparison_ops
    ::comparison_ops_f32
    ::comparison_ops_i64
    ::control_flow_ops
    ::conversion_ops
    ::conversion_ops_f32
    ::conversion_ops_i64
    ::global_ops
    ::global_ops_f32
    ::global_ops_i64
    ::list_ops
    ::list_variant_ops
    ::ref_ops
    ::shift_ops
    ::shift_ops_i64
)

iree_c_module(
  NAME
    arithmetic_ops
  SRC
    "../arithmetic_ops.mlir"
  H_FILE_OUTPUT
    "arithmetic_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    arithmetic_ops_f32
  SRC
    "../arithmetic_ops_f32.mlir"
  H_FILE_OUTPUT
    "arithmetic_ops_f32.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    arithmetic_ops_i64
  SRC
    "../arithmetic_ops_i64.mlir"
  H_FILE_OUTPUT
    "arithmetic_ops_i64.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    assignment_ops
  SRC
    "../assignment_ops.mlir"
  H_FILE_OUTPUT
    "assignment_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    assignment_ops_f32
  SRC
    "../assignment_ops_f32.mlir"
  H_FILE_OUTPUT
    "assignment_ops_f32.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    assignment_ops_i64
  SRC
    "../assignment_ops_i64.mlir"
  H_FILE_OUTPUT
    "assignment_ops_i64.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    buffer_ops
  SRC
    "../buffer_ops.mlir"
  H_FILE_OUTPUT
    "buffer_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    call_ops
  SRC
    "../call_ops.mlir"
  H_FILE_OUTPUT
    "call_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    comparison_ops
  SRC
    "../comparison_ops.mlir"
  H_FILE_OUTPUT
    "comparison_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    comparison_ops_f32
  SRC
    "../comparison_ops_f32.mlir"
  H_FILE_OUTPUT
    "comparison_ops_f32.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    comparison_ops_i64
  SRC
    "../comparison_ops_i64.mlir"
  H_FILE_OUTPUT
    "comparison_ops_i64.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    control_flow_ops
  SRC
    "../control_flow_ops.mlir"
  H_FILE_OUTPUT
    "control_flow_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    conversion_ops
  SRC
    "../conversion_ops.mlir"
  H_FILE_OUTPUT
    "conversion_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    conversion_ops_f32
  SRC
    "../conversion_ops_f32.mlir"
  H_FILE_OUTPUT
    "conversion_ops_f32.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    conversion_ops_i64
  SRC
    "../conversion_ops_i64.mlir"
  H_FILE_OUTPUT
    "conversion_ops_i64.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    global_ops
  SRC
    "../global_ops.mlir"
  H_FILE_OUTPUT
    "global_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    global_ops_f32
  SRC
    "../global_ops_f32.mlir"
  H_FILE_OUTPUT
    "global_ops_f32.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    global_ops_i64
  SRC
    "../global_ops_i64.mlir"
  H_FILE_OUTPUT
    "global_ops_i64.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    list_ops
  SRC
    "../list_ops.mlir"
  H_FILE_OUTPUT
    "list_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    list_variant_ops
  SRC
    "../list_variant_ops.mlir"
  H_FILE_OUTPUT
    "list_variant_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    ref_ops
  SRC
    "../ref_ops.mlir"
  H_FILE_OUTPUT
    "ref_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    shift_ops
  SRC
    "../shift_ops.mlir"
  H_FILE_OUTPUT
    "shift_ops.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

iree_c_module(
  NAME
    shift_ops_i64
  SRC
    "../shift_ops_i64.mlir"
  H_FILE_OUTPUT
    "shift_ops_i64.h"
  FLAGS
    "-iree-vm-ir-to-c-module"
)

endif()
