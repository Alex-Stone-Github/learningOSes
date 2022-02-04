all: bin/os.img

bin/os.img: build/boot.o build/entry.o
	ld -melf_i386 -T linker.ld $^ -o build/codecomp
	dd if=/dev/zero of=./build/tmpzero bs=1024 count=1
	cat build/codecomp build/tmpzero > $@

build/%.o: src/%.asm
	nasm -f elf $^ -o $@

clean:
	rm bin/* build/*

run:
	qemu-system-x86_64 bin/os.img