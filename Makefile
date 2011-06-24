BIN=mlchk

DC=dmd
CFLAGS=-c
LDFLAGS=

OBJ=main.o parts/part.o parts/gear.o parts/ldiode.o

.PHONY: build
.PHONY: clean

$(BIN): $(OBJ)
	$(DC) $(LDFLAGS) $(OBJ) -of$@

%.o: %.d
	$(DC) $(CFLAGS) -of$@ $<

clean:
	rm $(OBJ) $(BIN)