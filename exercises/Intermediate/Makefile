OCAMLC ?= ocamlc
BUILD_DIR := _build
TARGET := $(BUILD_DIR)/intermediate_tests
SOURCES := lib/solutions.ml test/test_intermediate.ml

.PHONY: test build clean

test: build
	./$(TARGET)

build:
	mkdir -p $(BUILD_DIR)
	$(OCAMLC) -I lib -o $(TARGET) $(SOURCES)

clean:
	rm -rf $(BUILD_DIR) lib/*.cmi lib/*.cmo test/*.cmi test/*.cmo
