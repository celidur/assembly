SRCS=$(wildcard *.c *.s)
FLAGS=-lm -m32 -gdwarf-2 -z noexecstack
TARGET=out

.PHONY: clean, run, debug

$(TARGET): $(SRCS)
	@echo -- Building $(SRCS) --
	@gcc -g -o $@ $^ $(FLAGS)

clean:
	@echo -- Cleaning $(TARGET) --
	@rm -f $(TARGET)

run: $(TARGET)
	@echo -- Running $(TARGET) --
	./$(TARGET)

debug: $(TARGET)
	@echo -- Debugging $(TARGET) --
	gdb ./$(TARGET)