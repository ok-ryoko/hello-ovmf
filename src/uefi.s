; SPDX-FileCopyrightText: Copyright 2024 OK Ryoko
; SPDX-License-Identifier: MIT

EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL			equ 64
EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString	equ 8

section .data

EFI_HANDLE: dq 0
EFI_SYSTEM_TABLE: dq 0

; Print a null-terminated UTF-16 string using the UEFI Simple Text Output Protocol
;
; Clobbers rcx and rdx
;
; Use only in the .text section
;
%macro uefi_output_string 1
	mov	rcx, qword[EFI_SYSTEM_TABLE]
	mov	rcx, qword[rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL]
	lea	rdx, qword[%1]
	sub	rsp, 32
	call	qword[rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString]
	add	rsp, 32
%endmacro
