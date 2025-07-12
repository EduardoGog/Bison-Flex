TARGET = calc

FLEX_SRC = calc.l
BISON_SRC = calc.y
MAIN_SRC = main.c

BISON_C = calc.tab.c
BISON_H = calc.tab.h
FLEX_C = lex.yy.c

CC = gcc
CFLAGS = -Wall -lm

all: $(TARGET)

$(TARGET): $(BISON_C) $(FLEX_C) $(MAIN_SRC)
	$(CC) $(BISON_C) $(FLEX_C) $(MAIN_SRC) -o $(TARGET) $(CFLAGS)

$(BISON_C) $(BISON_H): $(BISON_SRC)
	bison -d -o $(BISON_C) $(BISON_SRC)

$(FLEX_C): $(FLEX_SRC) $(BISON_H)
	flex $(FLEX_SRC)

clean:
	rm -f $(TARGET) $(BISON_C) $(BISON_H) $(FLEX_C)
