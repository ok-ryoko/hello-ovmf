; SPDX-FileCopyrightText: Copyright 2024 OK Ryoko
; SPDX-License-Identifier: MIT

base equ 0x0000000000100000
alignment equ 4096

org base
bits 64
default rel

%include "src/sections.inc"

begin_section .header
begin_section .text
begin_section .data
begin_section .rdata

section .header

dos_header:

	dw "MZ"				; e_magic
	dw 0				; e_cblp
	dw 0				; e_cp
	dw 0				; e_crlc
	dw 0				; e_cparhdr
	dw 0				; e_minalloc
	dw 0				; e_maxalloc
	dw 0				; e_ss
	dw 0				; e_sp
	dw 0				; e_csum
	dw 0				; e_ip
	dw 0				; e_cs
	dw 0				; e_lfarlc
	dw 0				; e_ovno
	dq 0				; e_res
	dw 0				; e_oemid
	dw 0				; e_oeminfo
	times 10 dw 0			; e_res2
	dd nt_headers64 - dos_header	; e_lfanew

nt_headers64:

signature:

	dd "PE"				; Signature

file_header:

	dw 0x8664			; Machine (IMAGE_FILE_MACHINE_AMD64)
	dw section_count - 1		; NumberOfSections
	dd __?POSIX_TIME?__		; TimeDateStamp
	dd 0				; PointerToSymbolTable
	dd 0				; NumberOfSymbols
	dw optional_header64.len	; SizeOfOptionalHeader
	dw 0x0023			; Characteristics (IMAGE_FILE_RELOCS_STRIPPED | IMAGE_FILE_EXECUTABLE_IMAGE | IMAGE_FILE_LARGE_ADDRESS_AWARE)

optional_header64:

	dw 0x020b			; Magic (PE32+)
	db 0				; MajorLinkerVersion
	db 0				; MinorLinkerVersion
	dd section..text.len		; SizeOfCode
	dd section..data.len		; SizeOfInitializedData
	dd 0				; SizeOfUninitializedData
	dd section..text.rva		; AddressOfEntryPoint
	dd section..text.rva		; BaseOfCode
	dq base				; ImageBase
	dd alignment			; SectionAlignment
	dd alignment			; FileAlignment
	dw 0				; MajorOperatingSystemVersion
	dw 0				; MinorOperatingSystemVersion
	dw 1				; MajorImageVersion
	dw 0				; MinorImageVersion
	dw 2				; MajorSubsystemVersion
	dw 70				; MinorSubsystemVersion
	dd 0				; Win32VersionValue
	dd EOF				; SizeOfImage
	dd section..header.len		; SizeOfHeaders
	dd 0				; CheckSum
	dw 10				; Subsystem (IMAGE_SUBSYSTEM_EFI_APPLICATION)
	dw 0				; DllCharacteristics
	dq 4096 * 256			; SizeOfStackReserve
	dq 4096				; SizeOfStackCommit
	dq 4096 * 256			; SizeOfHeapReserve
	dq 4096				; SizeOfHeapCommit
	dd 0				; LoaderFlags
	dd 0				; NumberOfRvaAndSizes

.len: equ $ - optional_header64

IMAGE_SCN_CNT_CODE		equ 0x00000020
IMAGE_SCN_CNT_INITIALIZED_DATA	equ 0x00000040
IMAGE_SCN_MEM_EXECUTE		equ 0x20000000
IMAGE_SCN_MEM_READ		equ 0x40000000
IMAGE_SCN_MEM_WRITE		equ 0x80000000

section_headers:

section_header .text,  (		\
	IMAGE_SCN_CNT_CODE		\
	| IMAGE_SCN_MEM_EXECUTE		\
	| IMAGE_SCN_MEM_READ		\
)
section_header .data,  (		\
	IMAGE_SCN_CNT_INITIALIZED_DATA	\
	| IMAGE_SCN_MEM_READ		\
	| IMAGE_SCN_MEM_WRITE		\
)
section_header .rdata, (		\
	IMAGE_SCN_CNT_INITIALIZED_DATA	\
	| IMAGE_SCN_MEM_READ		\
)

sections:

%include "src/uefi.s"

%define print uefi_output_string

section .text

	sub	rsp, 8

	mov	qword[EFI_HANDLE], rcx
	mov	qword[EFI_SYSTEM_TABLE], rdx

print hello

	add	rsp, 8
	ret

section .rdata

hello: db __utf16__ `Hello, OVMF!\r\n\0`

end_section .header
end_section .text
end_section .data
end_section .rdata

EOF: equ $ - base
