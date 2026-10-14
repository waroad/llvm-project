; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx | FileCheck %s

; Without AVX512F, FCANONICALIZE on v8f16/v16f16 used to stay Legal and fail
; isel. It is expanded instead: every element is multiplied by 1.0 in f32.

define <8 x half> @canonicalize_v8f16(<8 x half> %x) nounwind {
; CHECK-LABEL: canonicalize_v8f16:
; CHECK-COUNT-8: mulss
; CHECK-NOT:     mulss
; CHECK:         retq
  %r = call <8 x half> @llvm.canonicalize.v8f16(<8 x half> %x)
  ret <8 x half> %r
}

define <16 x half> @canonicalize_v16f16(<16 x half> %x) nounwind {
; CHECK-LABEL: canonicalize_v16f16:
; CHECK-COUNT-16: mulss
; CHECK-NOT:      mulss
; CHECK:          retq
  %r = call <16 x half> @llvm.canonicalize.v16f16(<16 x half> %x)
  ret <16 x half> %r
}
