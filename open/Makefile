# Makefile for Open Source documentation

SHELL := /bin/bash

SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = ../../marketing/public/docs/html/open
VENVDIR       = ../.venv

help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile clean

html:
	@echo "Building Open Source documentation..."
	@$(VENVDIR)/bin/$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@echo "Documentation built successfully!"
	@echo "Output: $(BUILDDIR)/"

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILDDIR)
	@echo "Clean complete!"

serve:
	@echo "Starting Open Source docs dev server..."
	@echo "Open: http://localhost:8000"
	@$(VENVDIR)/bin/sphinx-autobuild \
		--open-browser \
		--port 8000 \
		--ignore "*.pyc" \
		--ignore ".git/*" \
		"$(SOURCEDIR)" "$(BUILDDIR)"

%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
