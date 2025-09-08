SHELL := /bin/bash

VENV    = ./.venv
PATHCACHE   = ./cache
PATHPYCACHE = ./__pycache__
PYTHON_VER = 3.10
PY_VER_FILE = ./.python-version

PYTHON = python$(PYTHON_VER)
PIP = $(PYTHON) -m pip

ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # not in a bash-like shell
	DISABLE_HELP = "y"
	CLEANUP = del /F /Q
	RMRF = rd /S /Q
	MKDIR = mkdir
	RMDIR = rd /S /Q
	SOURCE = " " # Leave it empty
	VENVSUBDIR = Scripts
  else # in a bash-like shell, like msys
	CLEANUP = rm -f
	RMRF = $(CLEANUP) -r
	MKDIR = mkdir -p
	RMDIR = rmdir
	SOURCE = source
	VENVSUBDIR = Scripts
  endif
	TARGET_EXTENSION = exe
else
	CLEANUP = rm -f
	RMRF = $(CLEANUP) -r
	MKDIR = mkdir -p
	TARGET_EXTENSION = out
	SOURCE = .
	VENVSUBDIR = bin
endif

# VENV_ACTIVATE = $(SOURCE) $(VENV)/$(VENVSUBDIR)/activate
XLX_ENV_ACTIVATE = $(SOURCE) /opt/Xilinx/envset.sh

# If more things need to be sourced, add them here
PREP_ENV = $(XLX_ENV_ACTIVATE)

# Paths portability in Makefiles among OSes:
# https://skramm.blogspot.com/2013/04/writing-portable-makefiles.html

## Show this help
.PHONY: help
help: _help


## -- General targets --

# https://github.com/enjoy-digital/litex_wr_nic#

$(PY_VER_FILE):
	pyenv local $(PYTHON_VER)

## Build and load Spec A7 image
.PHONY: SpecA7
SpecA7: $(PY_VER_FILE)
	$(PREP_ENV); $(PYTHON) ./spec_a7_wr_nic.py --build --load

## Build Spec A7 image
.PHONY: SpecA7build
SpecA7build: $(PY_VER_FILE)
	$(PREP_ENV); $(PYTHON) ./spec_a7_wr_nic.py --build

## Load Spec A7 image
.PHONY: SpecA7load
SpecA7load: $(PY_VER_FILE)
	$(PREP_ENV); $(PYTHON) ./spec_a7_wr_nic.py --load


## Flash Spec A7 image
.PHONY: SpecA7flash
SpecA7flash: $(PY_VER_FILE)
	$(PREP_ENV); $(PYTHON) ./spec_a7_wr_nic.py --flash

.PHONY: SpecA7help
SpecA7help: $(PY_VER_FILE)
	./spec_a7_wr_nic.py --help

# https://gist.github.com/prwhite/8168133#gistcomment-2749866
.PHONY: _help
_help:
ifndef DISABLE_HELP
	@printf "Usage:\n";
	@printf "make <target_1> <target_2> <target_3> ...\n";
	@printf "\n";
	@printf "Target:               Description:\n";
	@printf "=======               ============\n";
	

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":") - 1); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                     "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                     "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)
endif # ifdef DISABLE_HELP
# TODO Add else with fallback for windows

.DEFAULT_GOAL := help
