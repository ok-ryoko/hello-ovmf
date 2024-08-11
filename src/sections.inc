; SPDX-FileCopyrightText: Copyright 2024 OK Ryoko
; SPDX-License-Identifier: MIT

; This file provides macros for organizing the sections of a PE32+ file and
; populating the file's header accordingly.

%ifndef SECTIONS_MAC
%define SECTIONS_MAC

; Begin a section that follows the previous section
;
; Define or increment a preprocessor constant holding the section count
;
%macro begin_section 1
%ifdef previous_section
section %1 follows=previous_section
%assign section_count (section_count + 1)
%else
section %1
%assign section_count 1
%endif
%define previous_section %1
%endmacro

; Insert a PE32+ section header
;
%macro section_header 1-2 0
	dq %str(%1)			; Name
	dd section.%1.len		; VirtualSize
	dd section.%1.rva		; VirtualAddress
	dd section.%1.len		; SizeOfRawData
	dd section.%1.rva		; PointerToRawData
	dd 0				; PointerToRelocations
	dd 0				; PointerToLinenumbers
	dw 0				; NumberOfRelocations
	dw 0				; NumberOfLinenumbers
	dd %2				; Characteristics
%endmacro

; End a section
;
; Define constants holding the size and relative virtual address of the section
;
; Ensure that the next section is aligned
;
%macro end_section 1
section %1
align alignment
section.%1.end:
section.%1.len: equ $ - $$
section.%1.rva: equ $$ - base
%endmacro

%endif
