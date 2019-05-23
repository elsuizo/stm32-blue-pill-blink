#-------------------------------------------------------------------------
#                        basic Makefile for libopencm3
#-------------------------------------------------------------------------
PREFIX?=arm-none-eabi-
CC=$(PREFIX)gcc
OBJCOPY=$(PREFIX)objcopy
OUTPUT_DIR=bin

all: all_recipe

SFLAGS= --static -nostartfiles -std=c11 -g3 -Os
SFLAGS+= -fno-common -ffunction-sections -fdata-sections
SFLAGS+= -I./libopencm3/include -L./libopencm3/lib
LFLAGS+=-Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group

M3_FLAGS= $(SFLAGS) -mcpu=cortex-m3 -mthumb -msoft-float
LFLAGS_STM32=$(LFLAGS) main.c -T memory.x

# STM32F1 starts up with HSI at 8Mhz
STM32F1_CFLAGS=$(M3_FLAGS) -DSTM32F1 $(LFLAGS_STM32) -lopencm3_stm32f1

BOARDS_ELF+=$(OUTPUT_DIR)/stm32/bluepill.elf
BOARDS_BIN+=$(OUTPUT_DIR)/stm32/bluepill.bin
BOARDS_HEX+=$(OUTPUT_DIR)/stm32/bluepill.hex

$(OUTPUT_DIR)/stm32/bluepill.elf: main.c libopencm3/lib/libopencm3_stm32f1.a
	@echo "  stm32f1 -> Creating $(OUTPUT_DIR)/stm32/bluepill.elf"
	$(CC) $(STM32F1_CFLAGS) -o $(OUTPUT_DIR)/stm32/bluepill.elf

all_recipe: output_recipe $(BOARDS_ELF) $(BOARDS_BIN) $(BOARDS_HEX)

libopencm3/Makefile:
	@echo "Initializing libopencm3 submodule"
	git submodule update --init

libopencm3/lib/libopencm3_%.a: libopencm3/Makefile
	$(MAKE) -C libopencm3

%.bin: %.elf
	$(OBJCOPY) -Obinary $(*).elf $(*).bin

%.hex: %.elf
	$(OBJCOPY) -Oihex $(*).elf $(*).hex

flash:
	openocd -f interface/stlink-v2.cfg -f target/stm32f1x.cfg -c "program bin/stm32/bluepill.elf verify reset exit"

output_recipe:
	mkdir -p $(OUTPUT_DIR)/stm32

clean:
	$(RM) $(BOARDS_ELF) $(BOARDS_BIN) $(BOARDS_HEX)

.PHONY: all_recipe output_recipe clean all
$(V).SILENT:
