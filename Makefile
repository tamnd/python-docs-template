# Makefile for a PEP 545 language translation.
#
# Set LANGUAGE to the IETF BCP 47 tag for this fork (lowercased, no
# redundant region subtag): vi, ja, ko, de, pt-br, zh-hans, ...
#
# Common targets:
#
#   make           Build HTML with the pinned CPython commit
#   make todo      List remaining work (requires potodo)
#   make verifs    Check wrapping
#   make wrap      Re-wrap all .po files with powrap
#   make clean     Remove build artifacts

# EDIT THESE FOR YOUR FORK ----------------------------------------------
LANGUAGE := LANG_TAG_HERE
BRANCH := 3.14
CPYTHON_CURRENT_COMMIT := 67100b3e926c2c7cdd9d0825add677b19664f377
# -----------------------------------------------------------------------

UPSTREAM := https://github.com/python/cpython

PYTHON := $(shell which python3)
MODE := html
JOBS := auto
ADDITIONAL_ARGS := --keep-going --color
SPHINXERRORHANDLING = -W

EXCLUDED := \
	whatsnew/2.?.po \
	whatsnew/3.[0-9].po \
	whatsnew/3.1[0-3].po

ifeq '$(findstring ;,$(PATH))' ';'
    detected_OS := Windows
else
    detected_OS := $(shell uname 2>/dev/null || echo Unknown)
endif

ifeq ($(detected_OS),Darwin)
    CP_CMD := gcp
else
    CP_CMD := cp
endif

.PHONY: all
all: ensure_prerequisites
	@if [ "$(LANGUAGE)" = "LANG_TAG_HERE" ]; then \
	    echo "Set LANGUAGE in the Makefile before building."; exit 1; \
	fi
	git -C venv/cpython checkout $(CPYTHON_CURRENT_COMMIT) \
	    || (git -C venv/cpython fetch && git -C venv/cpython checkout $(CPYTHON_CURRENT_COMMIT))
	mkdir -p locales/$(LANGUAGE)/LC_MESSAGES/
	$(CP_CMD) -u --parents *.po */*.po locales/$(LANGUAGE)/LC_MESSAGES/
	$(MAKE) -C venv/cpython/Doc/ \
	    JOBS='$(JOBS)' \
	    SPHINXOPTS='-D locale_dirs=$(abspath locales) \
	                -D language=$(LANGUAGE) \
	                -D gettext_compact=0 \
	                $(ADDITIONAL_ARGS)' \
	    SPHINXERRORHANDLING=$(SPHINXERRORHANDLING) \
	    $(MODE)
	@echo "Build done. Open: file://$(abspath venv/cpython/)/Doc/build/html/index.html"

venv/cpython/.git/HEAD:
	git clone $(UPSTREAM) venv/cpython

.PHONY: ensure_prerequisites
ensure_prerequisites: venv/cpython/.git/HEAD
	@if ! command -v sphinx-build >/dev/null 2>&1; then \
	    echo "Install dev requirements first: python -m pip install -r requirements-dev.txt"; \
	    exit 1; \
	fi

.PHONY: todo
todo: ensure_prerequisites
	potodo --exclude venv .venv $(EXCLUDED)

.PHONY: wrap
wrap:
	powrap *.po **/*.po

.PHONY: verifs
verifs:
	powrap --check --quiet *.po **/*.po

.PHONY: clean
clean:
	rm -rf venv/cpython/Doc/build
	rm -rf locales
