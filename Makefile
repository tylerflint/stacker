PROJECT = stacker

## elixir

ELIXIR_URL 		?= https://github.com/elixir-lang/elixir.git
ELIXIR_BRANCH ?= stable
MIX_ENV 			?= prod

ELIXIR_BUILD_DIR 			:= _elixir
ELIXIR_ABS_BUILD_DIR 	:= $(shell pwd)/$(ELIXIR_BUILD_DIR)
ELIXIR 								:= $(ELIXIR_BUILD_DIR)/bin/elixir
MIX 									:= $(ELIXIR_BUILD_DIR)/bin/mix

mix = MIX_ENV=$(MIX_ENV) $(MIX)

## relx

RELX_URL ?= https://github.com/erlware/relx/releases/download/v0.5.2/relx

RELX 						:= $(shell pwd)/relx
RELX_BUILD_DIR 	:= $(shell pwd)/.relx-build

relx_args_3 = -V 3
relx_args_2 = -V 2
relx_args_1 = -V 1
relx_args   = $(relx_args_$(V))

relx_verbose_0 = @echo ":: RELX" $(@F);
relx_verbose   = $(relx_verbose_$(V))

relx = $(relx_verbose) V=$(V) TEST=$(TEST) $(RELX) $(relx_args)

.PHONY: deps update-deps deps-compile compile build generate rel clean distclean

all: build

deps: get-deps deps-compile

get-deps: $(ELIXIR)
	$(mix) deps.get

update-deps: $(ELIXIR)
	$(mix) deps.update --all

deps-compile: $(ELIXIR)
	$(mix) deps.compile

compile: $(ELIXIR)
	$(mix) compile

build: $(ELIXIR) deps
	$(mix) compile

generate: $(RELX)
	$(relx) --config rel/relx.config --relname $(PROJECT) --relvsn "$(shell git describe --always --tags | sed -e s/^v//)" --output-dir rel/$(PROJECT)

rel: all generate

clean: $(ELIXIR)
	$(mix) clean

distclean: clean
	$(mix) deps.clean --all

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
.PHONY: elixir update-elixir

elixir: $(ELIXIR)

$(ELIXIR):
	git clone $(ELIXIR_URL) $(ELIXIR_BUILD_DIR)
	cd $(ELIXIR_ABS_BUILD_DIR) && git checkout $(ELIXIR_BRANCH)
	$(MAKE) -C $(ELIXIR_ABS_BUILD_DIR)

##
## relx
##
.PHONY: relx

relx: $(RELX)

$(RELX):
	wget -O $(RELX) $(RELX_URL) || rm $(RELX)
	chmod +x $(RELX)
