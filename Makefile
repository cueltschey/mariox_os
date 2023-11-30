ASM=nasm

SRC_DIR=src
BUILD_DIR=build

.PHONY: all main_mariox bootloader clean always

#
# Floppy image
#
main_mariox: $(BUILD_DIR)/main_mariox.img

$(BUILD_DIR)/main_mariox.img: bootloader kernel 
	dd if=/dev/zero of=$(BUILD_DIR)/main_mariox.img bs=512 count=2880
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_mariox.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_mariox.img conv=notrunc
	mcopy -i $(BUILD_DIR)/main_mariox.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

#
# Bootloader
#
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin






#
# Kernel
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

#
# Utilties
#
always:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*
