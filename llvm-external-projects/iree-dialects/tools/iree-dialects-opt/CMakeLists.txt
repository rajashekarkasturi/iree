set(LIBS
  MLIRArithmetic
  MLIRDialect
  MLIRLinalg
  MLIRMemRef
  MLIROptLib
  MLIRSCF
  MLIRSCFTransforms
  MLIRStandard
  MLIRTensor
  MLIRTransforms
  IREEInputDialect
  IREELinalgExtDialect
  IREELinalgExtPasses
  IREEPyDMDialect
  IREEPyDMPasses
)

add_llvm_tool(iree-dialects-opt
  iree-dialects-opt.cpp

  DEPENDS
  ${LIBS}
)
target_link_libraries(iree-dialects-opt PRIVATE ${LIBS})
