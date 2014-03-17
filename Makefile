PROJECT = stacker

OUTPUT_DIR ?= rel/$(PROJECT)

## elixir

ELIXIR_URL ?= https://github.com/elixir-lang/elixir.git
ELIXIR_BRANCH ?= stable
MIX_ENV ?= prod

ELIXIR_BUILD_DIR := _elixir
ELIXIR_ABS_BUILD_DIR := $(shell pwd)/$(ELIXIR_BUILD_DIR)
ELIXIR := $(ELIXIR_BUILD_DIR)/VERSION
MIX := $(ELIXIR_BUILD_DIR)/bin/mix

mix = PATH=$(shell pwd):$(ELIXIR_ABS_BUILD_DIR)/bin:$(PATH) MIX_ENV=$(MIX_ENV) $(MIX)

## rebar

REBAR_URL ?= https://github.com/rebar/rebar.git
REBAR_TAG ?= 2.2.0

REBAR := $(shell pwd)/rebar
REBAR_BUILD_DIR := .rebar-build
REBAR_ABS_BUILD_DIR := $(shell pwd)/$(REBAR_BUILD_DIR)

.PHONY: deps update-deps deps-compile compile build generate rel clean clean-all

all: build

deps: get-deps deps-compile

get-deps: $(ELIXIR)
	@$(mix) deps.get

update-deps: $(ELIXIR)
	@$(mix) deps.update --all

deps-compile: $(ELIXIR) $(REBAR)
	@$(mix) deps.compile

clean-deps:
	rm -rf deps

compile: $(ELIXIR)
	@$(mix) compile

build: $(ELIXIR) deps
	@$(mix) compile

clean-build:
	rm -rf $(shell pwd)/_build

rel: $(RELX) all
	@$(mix) relex.assemble

clean-rel:
	rm -rf $(shell pwd)/$(PROJECT)

clean: clean-rel clean-build

clean-all: clean clean-deps clean-elixir clean-rebar

##
## Developer targets
##
##  stage - Make a production rel for use in development
.PHONY: stage-generate stage

stage-generate: relx_args+=--dev-mode
stage-generate: generate

stage: all stage-generate

##
## elixir
##
.PHONY: elixir

elixir: $(ELIXIR)

$(ELIXIR):
	git clone $(ELIXIR_URL) $(ELIXIR_BUILD_DIR)
	cd $(ELIXIR_ABS_BUILD_DIR) && git checkout $(ELIXIR_BRANCH)
	$(MAKE) -C $(ELIXIR_ABS_BUILD_DIR)

clean-elixir:
	rm -rf $(ELIXIR_ABS_BUILD_DIR)

##
## rebar
##
.PHONY: rebar

rebar: $(REBAR)

$(REBAR):
	git clone $(REBAR_URL) $(REBAR_BUILD_DIR)
	cd $(REBAR_ABS_BUILD_DIR) && git checkout $(REBAR_TAG)
	$(MAKE) -C $(REBAR_ABS_BUILD_DIR)
	mv $(REBAR_ABS_BUILD_DIR)/rebar $(shell pwd)/rebar
	rm -rf $(REBAR_ABS_BUILD_DIR)

clean-rebar:
	rm -f $(REBAR)
	rm -rf $(REBAR_ABS_BUILD_DIR)
