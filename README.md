# “Hello, OVMF!” in NASM #

This repository demonstrates the assembly of a minimal [UEFI] Image on Linux using only [make] and [NASM]. The UEFI Image targets [OVMF] on the x86\_64 architecture.

## Prerequisites ##

The programs make, NASM and [QEMU] are needed to build and run the UEFI Image.

The files *OVMF_CODE.fd* and *OVMF_VARS.fd*, which may be symbolic links, are expected to exist in the directory at */usr/share/OVMF*.

## Usage ##

The following shell command will prepare the repository, assemble the UEFI Image and launch a VM to run the image:

```console
$ make setup && make run
```

The expected console output follows:

```
UEFI Interactive Shell v2.2
EDK II
UEFI v2.70 (EDK II, 0x00010000)
Mapping table
      FS0: Alias(s):HD0a1:;BLK1:
          PciRoot(0x0)/Pci(0x1,0x1)/Ata(0x0)/HD(1,MBR,0xBE1AFDFA,0x3F,0xFBFC1)
     BLK0: Alias(s):
          PciRoot(0x0)/Pci(0x1,0x1)/Ata(0x0)
     BLK2: Alias(s):
          PciRoot(0x0)/Pci(0x1,0x1)/Ata(0x0)
Press ESC in 1 seconds to skip startup.nsh or any other key to continue.
Shell> FS0:\hello.efi
Hello, OVMF!
Shell> 
```

To exit QEMU, press `Ctrl+A` and then `X`.

## [PE32+] header construction ##

The DOS Stub and the data directories in the optional header aren’t needed and are therefore omitted.

Some header fields, e.g., MajorSubsystemVersion, are populated for only documentation purposes.

The stack and heap reserve and commit sizes are chosen to match the respective default values for the MSVC Linker.

The image base of 0x100000 is chosen to match the first available address in the VM’s memory map that meets the application’s memory requirements. (This map can be obtained by running `memmap -b` in the UEFI Shell.)

The choice of image base renders relocation unnecessary. There is therefore no base relocation table and the file header is made to indicate that relocations have been stripped. The image can nonetheless be relocated because it comprises position-independent code. To see relocation in action:

  1. Change the image base to an unavailable address, e.g., 0x76ed000
  2. Unset the `IMAGE_FILE_RELOCS_STRIPPED` bit in the file header characteristics
  3. Re-assemble and rerun the image

## License ##

This project comprises free and open-source software and documentation [licensed under the MIT license][license].

[license]: ./LICENSE.txt
[make]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html
[NASM]: https://nasm.us/
[OVMF]: https://github.com/tianocore/tianocore.github.io/wiki/OVMF
[PE32+]: https://learn.microsoft.com/en-us/windows/win32/debug/pe-format
[QEMU]: https://www.qemu.org/
[UEFI]: https://uefi.org/
