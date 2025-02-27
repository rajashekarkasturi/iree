// Copyright 2021 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef IREE_CODEGEN_SANDBOX_PASSES_TD
#define IREE_CODEGEN_SANDBOX_PASSES_TD

include "mlir/Pass/PassBase.td"

def LinalgFuse : Pass<"linalg-fuse", "FuncOp"> {
  let summary = "Pass to tile and fuse linalg operations.";
  let constructor = "mlir::createLinalgFusePass()";
  let options = [
    Option<"anchorFuncOpName", "anchor-func", "std::string", /*default=*/"",
      "Which func op is the anchor to latch on.">,
    Option<"anchorOpName", "anchor-op", "std::string", /*default=*/"",
      "Which linalg op within the func is the anchor to latch on.">,

    // Tiling options.
    ListOption<"tileSizes", "tile-sizes", "int64_t", "Tile sizes",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    ListOption<"tileInterchange", "tile-interchange", "int64_t",
                "Tile loop interchange",
                "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    Option<"pad", "pad", "bool", /*default=*/"false",
      "Pad the anchor op operands.">,
    ListOption<"packPaddings", "pack-paddings", "int64_t",
               "Operand packing flags.",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    ListOption<"hoistPaddings", "hoist-paddings", "int64_t",
               "Hoist padding depths.",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    ListOption<"transposePaddings", "transpose-paddings", "std::string",
               "Transpose paddings.",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    // Vectorization options.
    Option<"vectorize", "vectorize", "bool", /*default=*/"false",
      "Rewrite the linalg op as a vector operation.">,
    Option<"vectorizePadding", "vectorize-padding", "bool", /*default=*/"false",
      "Rewrite all tensor.pad ops in the function to vector form.">,

    // IREE specific options
    Option<"tilingLevel", "tiling-level", "int64_t", /*default=*/"-1",
      "Use default tiling level used to retrieve the configuration from lowering.config">
  ];
  let dependentDialects = [
    "::mlir::arith::ArithmeticDialect", "::mlir::AffineDialect",
    "::mlir::linalg::LinalgDialect", "::mlir::scf::SCFDialect",
    "::mlir::cf::ControlFlowDialect", "::mlir::tensor::TensorDialect",
    "::mlir::vector::VectorDialect"
  ];
}

def LinalgSingleTilingExpert
    : Pass<"linalg-single-tiling-expert-driver", "FuncOp"> {
  let summary = "Pass to drive transformations on Linalg on tensors.";
  let constructor = "mlir::createLinalgSingleTilingExpertPass()";
  let options = [
    // Func / op targeting options.
    Option<"anchorFuncOpName", "anchor-func", "std::string", /*default=*/"",
      "Which func op is the anchor to latch on.">,
    Option<"anchorOpName", "anchor-op", "std::string", /*default=*/"",
      "Which linalg op within the func is the anchor to latch on.">,

    // Tiling options.
    ListOption<"tileSizes", "tile-sizes", "int64_t", "Tile sizes",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    ListOption<"tileInterchange", "tile-interchange", "int64_t",
                "Tile loop interchange",
                "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    ListOption<"peeledLoops", "peeled-loops", "int64_t", "Peeled loops",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    Option<"pad", "pad", "bool", /*default=*/"false",
      "Pad the anchor op operands.">,
    ListOption<"packPaddings", "pack-paddings", "int64_t",
               "Operand packing flags.",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    ListOption<"hoistPaddings", "hoist-paddings", "int64_t",
               "Hoist padding depths.",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    ListOption<"transposePaddings", "transpose-paddings", "std::string",
               "Transpose paddings.",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    Option<"scalarizeDynamicDims", "scalarize-dynamic-dims", "bool",
      /*default=*/"false", "Tile dynamic dimensions by 1.">,

    // Generalization options.
    Option<"generalize", "generalize", "bool", /*default=*/"false",
      "Convert named operations to their generic form.">,
    ListOption<"iteratorInterchange", "iterator-interchange", "int64_t",
               "Interator interchange.",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,

    // Decomposition options.
    // TODO: atm this is applied to all supported ops. If/when we need finer
    // control this should be exposed with an opName + filter and a proper
    // pattern.
    Option<"decomposeToLowerDimOp", "decompose-to-lower-dim", "bool",
      /*default=*/"false",
      "Convert named operations to lower-D named operations.">,

    // Vectorization options.
    Option<"vectorize", "vectorize", "bool", /*default=*/"false",
      "Rewrite the linalg op as a vector operation.">,
    Option<"vectorizePadding", "vectorize-padding", "bool", /*default=*/"false",
      "Rewrite all linalg.pad_tensor ops in the function to vector form.">,

    // IREE specific options
    Option<"tilingLevel", "tiling-level", "int64_t", /*default=*/"-1",
      "Use default tiling level used to retrieve the configuration from lowering.config">
  ];
  let dependentDialects = [
    "::mlir::arith::ArithmeticDialect", "::mlir::AffineDialect",
    "::mlir::linalg::LinalgDialect", "::mlir::scf::SCFDialect",
    "::mlir::cf::ControlFlowDialect", "::mlir::tensor::TensorDialect",
    "::mlir::vector::VectorDialect"
  ];
}

def LinalgVectorLowering : Pass<"linalg-vector-lowering", "FuncOp"> {
  let summary = "Run transformations that lower high-level vectors.";
  let constructor = "mlir::createLinalgVectorLoweringPass()";
  let options = [
    Option<"vectorLoweringStage", "lower-vector-stage", "int", /*default=*/"0",
      [{Which stage of vector lowering to run:\n"
          "\t0 [default] only lower vector.contract\n"
          "\t1 additionally lower vector.multi_reduction\n"
          "\t2 additionally enable vector.transfer split\n"
          "\t3 additionally lower vector.transfer\n"
          "\t4 additionally lower vector.transfer to scf\n"
          "\t5 additionally lower vector.shape_cast\n"
          "\t6 additionally lower vector.transpose\n}]>,
    Option<"splitVectorTransfersTo", "split-transfers", "std::string",
      /*default=*/"",
      [{Split vector transfers between slow (masked) and fast "
        "(unmasked) variants. Possible options are:\n"
          "\tnone [default]: keep unsplit vector.transfer and pay the price\n"
          "\tlinalg-copy: use linalg.fill + linalg.generic for the slow path\n"
          "\tvector-transfers: use extra small unmasked vector.transfers for"
          " the slow path\n}]>,
    Option<"lowerVectorTransposeTo", "lower-vector-transpose-to",
       "std::string", /*default=*/[{"eltwise"}],
      [{Lower vector.transpose to finer-grained vector ops, options are:\n"
          "\teltwise [default]\n"
          "\tflat_transpose (requires LLVM matrix intrinsics support)\n"
          "\tshuffle (lower 2-D transposes to shape_cast + shuffle)\n}]>,
    Option<"lowerVectorTransposeToAVX2", "lower-vector-transpose-to-avx2", "bool",
      /*default=*/"false",
      "Add specific transpose to avx2 lowering patterns.">,
    Option<"lowerVectorMultiReductionTo", "lower-vector-multi-reduction-to",
       "std::string", /*default=*/[{"innerparallel"}],
      [{Lower vector.multi_reduction to finer-grained vector ops, options are:\n"
          "\tinnerparallel [default]\n"
          "\tinnerreduction\n}]>,
    Option<"lowerVectorContractionTo", "lower-vector-contraction-to", "std::string",
      /*default=*/[{"outerproduct"}],
      [{Lower vector.contract to finer-grained vector ops, options are:\n"
          "\touterproduct [default]\n"
          "\tdot\n"
          "\tmatrixintrinsics\n}]>,
    Option<"unrollVectorTransfers", "unroll-vector-transfers", "bool",
      /*default=*/"true",
      "Run transformations that lower high-level vectors.">,
    Option<"maxTransferRank", "max-transfer-rank", "int64_t", /*default=*/"1",
      "Set the maximum vector load/store rank.">
  ];
  let dependentDialects = [
    "::mlir::arith::ArithmeticDialect", "::mlir::AffineDialect",
    "::mlir::linalg::LinalgDialect", "::mlir::memref::MemRefDialect",
    "::mlir::scf::SCFDialect", "::mlir::cf::ControlFlowDialect",
    "::mlir::vector::VectorDialect"
  ];
}

def UnrollOneVectorOp : Pass<"unroll-one-vector-op", "FuncOp"> {
  let summary = "Pass to unroll a vector op to a target size.";
  let constructor = "mlir::createUnrollOneVectorOpPass()";
  let options = [
    Option<"anchorFuncOpName", "anchor-func", "std::string", /*default=*/"",
      "Which func op is the anchor to latch on.">,
    Option<"anchorOpName", "anchor-op", "std::string", /*default=*/"",
      "Which unique op within the func is the anchor to latch on.">,

    // UnrollOneVectorOp options.
    ListOption<"sourceShape", "source-shape", "int64_t", "Source vector shape",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    ListOption<"targetShape", "target-shape", "int64_t", "Target vector shape",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
  ];
  let dependentDialects = [
    "::mlir::arith::ArithmeticDialect", "::mlir::AffineDialect",
    "::mlir::linalg::LinalgDialect", "::mlir::scf::SCFDialect",
    "::mlir::cf::ControlFlowDialect", "::mlir::tensor::TensorDialect",
    "::mlir::vector::VectorDialect"
  ];
}

def UnrollOneParentLoop : Pass<"unroll-one-parent-loop", "FuncOp"> {
  let summary = "Pass to unroll the k^th parent loop of an op by some amount.";
  let constructor = "mlir::createUnrollOneParentLoopPass()";
  let options = [
    Option<"anchorFuncOpName", "anchor-func", "std::string", /*default=*/"",
      "Which func op is the anchor to latch on.">,
    Option<"anchorOpName", "anchor-op", "std::string", /*default=*/"",
      "Which unique op within the func is the anchor to latch on.">,

    // UnrollOneParentLoop options.
    Option<"parentLoopNum", "parent-loop-num", "unsigned", /*default=*/"1",
      "Number of the parent loop to latch on.">,
    Option<"unrollFactor", "unroll-factor", "unsigned", /*default=*/"1",
      "Unroll factor.">,
  ];
  let dependentDialects = [
    "::mlir::arith::ArithmeticDialect", "::mlir::AffineDialect",
    "::mlir::linalg::LinalgDialect", "::mlir::scf::SCFDialect",
    "::mlir::cf::ControlFlowDialect", "::mlir::tensor::TensorDialect",
    "::mlir::vector::VectorDialect"
  ];
}

def OutlineOneParentLoop : Pass<"outline-one-parent-loop", "FuncOp"> {
  let summary = "Pass to outline the k^th parent loop of an op.";
  let constructor = "mlir::createOutlineOneParentLoopPass()";
  let options = [
    Option<"anchorFuncOpName", "anchor-func", "std::string", /*default=*/"",
      "Which func op is the anchor to latch on.">,
    Option<"anchorOpName", "anchor-op", "std::string", /*default=*/"",
      "Which unique op within the func is the anchor to latch on.">,

    // OutlineOneParentLoop options.
    Option<"parentLoopNum", "parent-loop-num", "unsigned", /*default=*/"1",
      "Number of the parent loop to latch on.">,
    Option<"resultFuncName", "result-func-name", "std::string", /*default=*/"",
      "Name of the func op produced by outlining.">,
  ];
  let dependentDialects = [
    "::mlir::arith::ArithmeticDialect", "::mlir::AffineDialect",
    "::mlir::linalg::LinalgDialect", "::mlir::scf::SCFDialect",
    "::mlir::cf::ControlFlowDialect", "::mlir::tensor::TensorDialect",
    "::mlir::vector::VectorDialect"
  ];
}

#endif // IREE_CODEGEN_SANDBOX_PASSES_TD
