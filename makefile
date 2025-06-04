SCRIPT_DIR := ./scripts
OUTPUT_DIR := ./output

SCRIPTS := $(shell find $(SCRIPT_DIR) -type f -name '*.py')
OUTPUTS := $(SCRIPTS:$(SCRIPT_DIR)/%.py=$(OUTPUT_DIR)/%.output)

project-3.pdf: project-3.typ engr-conf.typ $(OUTPUTS)
	typst compile $<

$(OUTPUT_DIR)/%.output: $(SCRIPT_DIR)/%.py
	@mkdir -p $(dir $@)
	@mkdir -p media
	python $< > $@

$(OUTPUT_DIR)/DTMFwrite.output: $(SCRIPT_DIR)/DTMFfrequencies.py
$(OUTPUT_DIR)/DTMFread.output: $(SCRIPT_DIR)/DTMFfrequencies.py

.PHONY: clean
clean: 
	rm -r $(OUTPUT_DIR)
