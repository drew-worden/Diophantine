# Colors and formatting
BOLD := \033[1m
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
MAGENTA := \033[35m
CYAN := \033[36m
RESET := \033[0m

# Variables
COMPILER = gcc
COMPILER_FLAGS = -std=c17 -pedantic -Wall -Wextra -Wpedantic -Wformat=2 -Wno-unused-parameter \
                -Wshadow -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
                -Wredundant-decls -Wnested-externs -Wmissing-include-dirs -g

INCLUDE_DIR = include
INCLUDES = -I$(INCLUDE_DIR)
SRC_DIR = src
BUILD_DIR = build
FORMATTER = clang-format
FORMAT_FLAGS = -i --verbose

# Files
SRCS := $(shell find $(SRC_DIR) -name '*.c')
OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))

# Executable
EXECUTABLE = $(BUILD_DIR)/dio

# Default target
.DEFAULT_GOAL := build

# COMMAND: Build and run
all: build run

# COMMAND: Just build
build: $(EXECUTABLE)

# COMMAND: Just run
run: $(EXECUTABLE)
	@echo "$(BOLD)$(BLUE)Running executable...$(RESET)"
	@$(EXECUTABLE)

# RULE: Build the executable
$(EXECUTABLE): $(OBJS)
	@echo "$(BOLD)$(BLUE)Building executable...$(RESET)"
	@mkdir -p $(BUILD_DIR)
	@$(COMPILER) $(COMPILER_FLAGS) -o $@ $^
	@echo "$(BOLD)$(GREEN)✓ Executable successfully built.$(RESET)"

# RULE: Build object files
define compile_rule
$(BUILD_DIR)/$(basename $(notdir $(1))).o: $(1)
	@mkdir -p $$(dir $$@)
	@echo "$(BOLD)$(CYAN)Compiling $$(notdir $(1))...$(RESET)"
	@$(COMPILER) $(COMPILER_FLAGS) $(INCLUDES) -c $$< -o $$@
endef
$(foreach src,$(SRCS),$(eval $(call compile_rule,$(src))))

# COMMAND: Format the codebase (only if clang-format is available)
format:
	@if command -v $(FORMATTER) >/dev/null 2>&1; then \
		echo "$(BOLD)$(MAGENTA)Formatting codebase...$(RESET)"; \
		find $(SRC_DIR) $(INCLUDE_DIR) -name '*.c' -o -name '*.h' | \
		while read file; do \
			echo "$(CYAN)⟳ Formatting $$file...$(RESET)"; \
			$(FORMATTER) $(FORMAT_FLAGS) "$$file" 2>&1 | grep -v "Formatting "; \
		done; \
		echo "$(BOLD)$(GREEN)✓ Codebase formatting completed.$(RESET)"; \
	else \
		echo "$(BOLD)$(RED)⨯ Warning: $(FORMATTER) not found. Skipping format.$(RESET)"; \
	fi

# COMMAND: Remove the build artifacts
clean:
	@echo "$(BOLD)$(YELLOW)Cleaning up build artifacts...$(RESET)"
	@rm -rf $(BUILD_DIR)
	@echo "$(BOLD)$(GREEN)✓ Cleanup complete.$(RESET)"

# COMMAND: Print help
help:
	@echo "$(BOLD)$(BLUE)Available targets:$(RESET)"
	@echo "  $(BOLD)all$(RESET)    - Build and run the executable"
	@echo "  $(BOLD)build$(RESET)  - Build the executable"
	@echo "  $(BOLD)run$(RESET)    - Run the executable"
	@echo "  $(BOLD)format$(RESET) - Format the source code (requires clang-format)"
	@echo "  $(BOLD)clean$(RESET)  - Remove build artifacts"
	@echo "  $(BOLD)help$(RESET)   - Show this help message"

# Phony targets
.PHONY: all build run clean format help
