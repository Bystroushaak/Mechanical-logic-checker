BIN=mlchk

DC=dmd
CFLAGS=-c
LDFLAGS=

OBJ= \
	main.o \
	parts/part.o \
	parts/gear.o \
	parts/igear.o \
	parts/ldiode.o \
	parts/rdiode.o

.PHONY: build
.PHONY: clean
.PHONY: run

build: $(BIN)

run: build
	./mlchk

$(BIN): main.o
	$(DC) $(LDFLAGS) $(OBJ) -of$@

main.o: parts/gear.o parts/igear.o parts/ldiode.o parts/rdiode.o
	$(DC) $(CFLAGS) -ofmain.o main.d

parts/gear.o: parts/part.o
	$(DC) $(CFLAGS) -ofparts/gear.o parts/gear.d

parts/igear.o: parts/part.o parts/gear.o
	$(DC) $(CFLAGS) -ofparts/igear.o parts/igear.d

parts/ldiode.o: parts/part.o parts/gear.o
	$(DC) $(CFLAGS) -ofparts/ldiode.o parts/ldiode.d

parts/rdiode.o: parts/part.o parts/gear.o
	$(DC) $(CFLAGS) -ofparts/rdiode.o parts/rdiode.d

parts/part.o:
	$(DC) $(CFLAGS) -ofparts/part.o parts/part.d

clean:
	rm $(OBJ) $(BIN)