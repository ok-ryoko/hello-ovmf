.POSIX:
.SUFFIXES:

run: drive/hello.efi
	qemu-system-x86_64 \
		-cpu qemu64 \
		-drive if=pflash,format=raw,unit=0,file=OVMF_CODE.fd,readonly=on \
		-drive if=pflash,format=raw,unit=1,file=OVMF_VARS.fd \
		-drive format=raw,file=fat:rw:drive/ \
		-net none \
		-nographic \
		-serial mon:stdio

drive/hello.efi: src/*
	nasm -f bin -o drive/hello.efi src/hello.s

setup:
	cp -f /usr/share/OVMF/OVMF_{CODE,VARS}.fd .
	mkdir -p drive
	printf '%s\n' 'FS0:\hello.efi' > drive/startup.nsh
	chmod u+x drive/startup.nsh

clean:
	rm -f drive/hello.efi
