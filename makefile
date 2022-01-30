all: bin/os.img

bin/os.img: build/boot.o build/entry.o
	ld -melf_i386 -T linker.ld $^ -o $@

build/%.o: src/%.asm
	nasm -f elf $^ -o $@

clean:
	rm bin/* build/*

run:
	qemu-system-x86_64 bin/os.img