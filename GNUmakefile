VOC = /opt/voc/bin/voc
BUILD=build
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir_path := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))


all:
		mkdir -p $(BUILD)
		cd $(BUILD) && $(VOC) -s \
		$(mkfile_dir_path)/src/strTypes.Mod \
		$(mkfile_dir_path)/src/strUtils.Mod

tests: all
		$(VOC) $(mkfile_dir_path)/tst/TestStrUtils.Mod -m
		$(BUILD)/TestStrutils

clean:
		if [ -d "$(BUILD)" ]; then rm -rf $(BUILD); fi
