# hello-open-code — drive opencode read-only against whichever provider key you export.
#
# Quick start (inside the devcontainer):
#   export ANTHROPIC_API_KEY=...   # Claude   (or GEMINI_API_KEY / XAI_API_KEY)
#   make hello
#
# The `hello` target runs opencode non-interactively with the read-only `plan`
# agent and the prompt "identify yourself and say hello". It auto-selects a model
# based on whichever provider key is exported (first match wins: Claude, then
# Gemini, then Grok).
#
# Overrides:
#   make hello MODEL=anthropic/claude-sonnet-4-5
#   make hello PROMPT="who are you?"

SHELL := /bin/bash

# Read-only prompt.
PROMPT ?= identify yourself and say hello

# Default model per provider. Override with `make hello MODEL=provider/model`.
ANTHROPIC_MODEL ?= anthropic/claude-sonnet-4-5
GEMINI_MODEL    ?= google/gemini-2.5-pro
XAI_MODEL       ?= xai/grok-4

# If MODEL wasn't supplied, derive it from the exported provider key.
# (Environment variables are visible to make as variables; ifdef is false when empty.)
ifndef MODEL
ifdef ANTHROPIC_API_KEY
MODEL := $(ANTHROPIC_MODEL)
else ifdef GEMINI_API_KEY
MODEL := $(GEMINI_MODEL)
else ifdef XAI_API_KEY
MODEL := $(XAI_MODEL)
endif
endif

.PHONY: hello help
.DEFAULT_GOAL := help

hello:
	@command -v opencode >/dev/null 2>&1 || { echo "opencode not found. Rebuild the devcontainer (it installs it via postCreateCommand)."; exit 1; }
ifndef MODEL
	@echo "No provider key found. Export exactly one of:"; \
	echo "  export ANTHROPIC_API_KEY=...   # Claude"; \
	echo "  export GEMINI_API_KEY=...      # Gemini"; \
	echo "  export XAI_API_KEY=...         # Grok"; \
	exit 1
endif
	@echo "→ opencode run (read-only plan agent) · model: $(MODEL)"
	@opencode run --agent plan --model "$(MODEL)" "$(PROMPT)"

help:
	@echo "Targets:"
	@echo "  make hello   Run opencode read-only: 'identify yourself and say hello'"
	@echo ""
	@echo "Export a provider key first: ANTHROPIC_API_KEY, GEMINI_API_KEY, or XAI_API_KEY"
	@echo "Override model/prompt: make hello MODEL=provider/model PROMPT=\"...\""
