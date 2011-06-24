BIN=mlchk

DC=dmd
CFLAGS=-c
LDFLAGS=

OBJ=main.o parts/part.o parts/gear.o parts/igear.o parts/ldiode.o parts/rdiode.o

.PHONY: build
.PHONY: clean

build: $(BIN)

$(BIN): $(OBJ)
	$(DC) $(LDFLAGS) $(OBJ) -of$@

%.o: %.d
	$(DC) $(CFLAGS) -of$@ $<

clean:
	rm $(OBJ) $(BIN)