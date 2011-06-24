BIN=mlchk

DC=dmd
CFLAGS=-c
LDFLAGS=

OBJ=main.o parts/part.o parts/gear.o parts/igear.o parts/ldiode.o parts/rdiode.o

.PHONY: build
.PHONY: clean
.PHONY: run

build: $(BIN)

run: build
	./mlchk

$(BIN): $(OBJ)
	$(DC) $(LDFLAGS) $(OBJ) -of$@

%.o: %.d
	$(DC) $(CFLAGS) -of$@ $<

clean:
	rm $(OBJ) $(BIN)