# sand sifter make file
# modified by CE to use Intel XED disassembler instead of Capstone (many false positive "undocumented" instructions with Capstone)


# TODO: CONFIGURE ME! Change these for your system / preferences
# ==============================================================
kitLocation = xed/kits/yourkitnamehere	 # change this for your system after installing XED (follow instructions at https://github.com/intelxed/xed/ to install a kit)
microarch = XED_CHIP_ALL		 # see https://intelxed.github.io/ref-manual/xed-chip-enum_8h_source.html for all possible microarchitecture names or use XED_CHIP_ALL if unsure
useXed = false
useCapstone = true
#===============================================================


ifeq ($(useXed), true)
all: clean xed
else 
all : clean capstone
endif

xed:
	# Building injector with Intel XED disassembler (differs from original Sandsifter)
	gcc -D_GNU_SOURCE -DUSE_XED -DMICROARCH=$(microarch) -include$(kitLocation)/include/xed/xed-interface.h -c injector.c
	gcc -Wall -static -no-pie -o injector injector.o $(kitLocation)/lib/libxed.a -pthread

capstone:
	# Building injector with original Capstone disassembler
	gcc -D_GNU_SOURCE -DUSE_CAPSTONE -Wall -static -no-pie -o injector injector.c -l:libcapstone.a -pthread

clean:
	rm -f *.o injector
