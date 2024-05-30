# Compiler and assembler
CC = gcc
AS = gcc

# Compiler flags
CFLAGS = -Wall -g

# Source files
SRCS = main.c b64.c hamming.s

# Object files directory
OBJDIR = output

# Object files
OBJS = $(OBJDIR)/main.o $(OBJDIR)/b64.o $(OBJDIR)/hamming.o

# Executable name
OUTPUT = program

# Default target
all: $(OBJDIR) $(OUTPUT)

# Create the object files directory if it doesn't exist
$(OBJDIR):
	mkdir -p $(OBJDIR)

# Rule to create the output executable
$(OUTPUT): $(OBJS)
	$(CC) $(CFLAGS) -o $(OUTPUT) $(OBJS)

# Rule to compile C source files into object files
$(OBJDIR)/%.o: %.c libstr.h | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to assemble the .s file into an object file
$(OBJDIR)/%.o: %.s | $(OBJDIR)
	$(AS) $(CFLAGS) -c $< -o $@

# Rule to run the executable
run: $(OUTPUT)
	./$(OUTPUT)

debug: $(OUTPUT)
	gdb $(OUTPUT)
# Clean up generated files
clean:
	rm -rf $(OBJDIR) $(OUTPUT)
