# Concatenate multiple config files into one
# Support for optional host specific config
CONFIG_OUT = config
CONFIG_DIR = config.d
CONFIG_EXT = i3config
CONFIG_OPTIONAL = optional
CONFIG_BINDS = binds

# Variables
FILES = $(wildcard $(CONFIG_DIR)/*.$(CONFIG_EXT) $(CONFIG_DIR)/$(CONFIG_BINDS)/*.$(CONFIG_EXT))
HOST = $(wildcard $(CONFIG_DIR)/$(CONFIG_OPTIONAL)/$(shell hostname).$(CONFIG_EXT))
MODELINE = "\# vim: set ft=i3config:"

# Rule for main config file
$(CONFIG_OUT) :  $(FILES) $(HOST)
	cat $^ > $(CONFIG_OUT)
	@echo -e "\n$(MODELINE)" >> $(CONFIG_OUT)

.PHONY: clean
clean:
	$(RM) $(CONFIG_OUT)

