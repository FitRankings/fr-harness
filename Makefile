export HARNESS_PATH ?= $(shell 'pwd')
export HARNESS_EXTENSIONS_PATH ?= $(HARNESS_PATH)/../harness-extensions
export HARNESS_ARCH ?= $(shell uname -m | sed 's/x86_64/amd64/g')
export OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
export SELF ?= $(MAKE)
export PATH := $(HARNESS_PATH)/vendor:$(PATH)
export DOCKER_BUILD_FLAGS ?=

# Debug should not be defaulted to a value because some cli consider any value as `true` (e.g. helm)
export DEBUG ?=

ifeq ($(CURDIR),$(realpath $(HARNESS_PATH)))
# Only execute this section if we're actually in the `harness` project itself
# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md auto-label
export DEFAULT_HELP_TARGET = help/all

auto-label: MODULES=$(filter %/, $(sort $(wildcard modules/*/)))
auto-label:
	for module in $(MODULES); do \
		echo "$${module%/}: $${module}**"; \
	done > .github/$@.yml
endif

# Import Makefiles into current context
include $(HARNESS_PATH)/Makefile.*
include $(HARNESS_PATH)/modules/*/Makefile*
# Don't fail if there are no build harness extensions
# Wildcard conditions is to fixes `make[1]: *** No rule to make target` error
ifneq ($(wildcard $(HARNESS_EXTENSIONS_PATH)/modules/*/Makefile*),)
-include $(HARNESS_EXTENSIONS_PATH)/modules/*/Makefile*
endif

# For backwards compatibility with all of our other projects that use harness
init::
	exit 0

ifndef TRANSLATE_COLON_NOTATION
%:
	@$(SELF) -s $(subst :,/,$@) TRANSLATE_COLON_NOTATION=false
endif