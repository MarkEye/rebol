REBOL [
	System: "REBOL [R3] Language Interpreter and Run-time Environment"
	Title: "System build targets"
	Rights: {
		Copyright 2012 REBOL Technologies
		REBOL is a trademark of REBOL Technologies
	}
	License: {
		Licensed under the Apache License, Version 2.0
		See: http://www.apache.org/licenses/LICENSE-2.0
	}
	Author: "Carl Sassenrath"
	Purpose: {
		These are the target system definitions used to build REBOL
		with a variety of compilers and libraries. I prefer to keep it
		simple like this rather than using a complex configuration tool
		that could make it difficult to support REBOL on older platforms.
	}
]

systems: [
	[plat  os-name   os-base  build-flags]
	[0.1.03 "amiga"      posix  [HID NPS +SC CMT COP -SP]]
	[0.2.04 "osx"        posix  [+OS NCM]]			; no shared lib possible
	[0.2.05 "osxi"       posix  [ARC +O1 NPS PIC NCM HID STX]]
	[0.3.01 "win32"      win32  [+O2 UNI]]
	[0.4.02 "linux"      posix  [+O2 LDL ST1]]		; libc 2.3
	[0.4.03 "linux"      posix  [+O2 HID LDL ST1]]	; libc 2.5
	[0.4.04 "linux"      posix  [+O2 HID LDL ST1]]	; libc 2.11
	[0.4.10 "linux_ppc"  posix  [+O1 HID LDL ST1]]
	[0.4.20 "linux_arm"  posix  [+O2 HID LDL ST1]]
	[0.4.30 "linux_mips" posix  [+O2 HID LDL ST1]]  ; glibc does not need C++
	[0.7.02 "freebsd"    posix  [+O1 C++ ST1]]
	[0.9.04 "openbsd"    posix  [+O1 C++ ST1]]
]

compile-flags: [
	+OS: "-Os"                    ; size optimize
	+O1: "-O1"                    ; full optimize
	+O2: "-O2"                    ; full optimize
	UNI: "-DUNICODE"              ; win32 wants it
	HID: "-fvisibility=hidden"    ; all syms are hidden
	F64: "-D_FILE_OFFSET_BITS=64" ; allow larger files
	NPS: "-Wno-pointer-sign"      ; OSX fix
	NSP: "-fno-stack-protector"   ; avoid insert of functions names
	PIC: "-fPIC"                  ; position independent (used for libs)
	DYN: "-dynamic"               ; optimize for dll??
	NCM: "-fno-common"            ; lib cannot have common vars
	PAK: "-fpack-struct"          ; pack structures
	ARC: "-arch i386"             ; x86 32 bit architecture (OSX)
]

linker-flags: [
	MAP: "-Wl,-M"  ; output a map
	STA: "--strip-all"
	C++: "-lstdc++" ; link with stdc++
	LDL: "-ldl"     ; link with dynamic lib lib
	ARC: "-arch i386" ; x86 32 bit architecture (OSX)
]

other-flags: [
	+SC: ""		; has smart console
	-SP: ""		; non standard paths
	COP: ""		; use COPY as cp program
	ST1: "-s"	; strip flags...
	STX: "-x"
	ST2: "-S -x -X"
	CMT: "-R.comment"
]

config-system: func [
	"Return build configuration information"
	/fields "record variables"
	/define "the TO_TARGET define name"
	/os-dir "the %osname/ directory"
	/platform v [tuple!]
][
	if fields [return first systems]
	v: any [v to tuple! reduce [0 system/version/4 system/version/5]]
	foreach rec next systems [
		if rec/1 = v [
			if os-dir [return dirize to-file rec/3]
			if define [return to-word uppercase join "TO_" rec/2]
			return rec
		]
	]
	none
]
