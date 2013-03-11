include pdos.mk

# libraries for AMD and LDL, needed for direct method:
EINCS = -Idirect/external/LDL/Include -Idirect/external/AMD/Include -Idirect/external/SuiteSparse_config 
ELIBS = direct/external/AMD/Lib/libamd.a direct/external/LDL/Lib/libldl.a

HEADERS = pdos.h linAlg.h util.h cones.h cs.h
SOURCES = $(HEADERS:.h=.c)
OBJECTS = $(HEADERS:.h=.o)
TARGETS = demo_direct demo_indirect

default: amd ldl pdos_direct pdos_indirect demo_direct demo_indirect

packages: amd ldl

amd:
	(cd direct/external/AMD ; $(MAKE))

ldl:
	(cd direct/external/LDL ; $(MAKE))

direct/private.o: direct/private.c
	$(CC) $(CFLAGS) $(EINCS) -c -o $@ $^ 

indirect/private.o: indirect/private.c
	$(CC) $(CFLAGS) -c -o $@ $^ 

pdos_direct: $(OBJECTS) direct/private.o
	$(ARCHIVE) libpdosdir.a $^
	- $(RANLIB) libpdosdir.a

pdos_indirect: $(OBJECTS) indirect/private.o
	$(ARCHIVE) libpdosindir.a $^
	- $(RANLIB) libpdosindir.a

demo_direct: run_pdos.c 
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) libpdosdir.a $(ELIBS) 

demo_indirect: run_pdos.c 
	$(CC) $(CFLAGS) -o $@ $^ libpdosindir.a $(LDFLAGS) 

.PHONY: clean purge

clean:
	( cd direct/external/LDL      ; $(MAKE) clean )
	( cd direct/external/AMD      ; $(MAKE) clean )
	@rm -rf $(TARGETS) $(OBJECTS) direct/private.o indirect/private.o core Makefile.dependencies *.o *.a

purge: clean
	( cd direct/external/LDL    ; $(MAKE) purge )
	( cd direct/external/AMD    ; $(MAKE) purge )   
