# Minimal makefile for Sphinx documentation
# Unified documentation Makefile

SHELL := /bin/bash

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = ../marketing/public/docs/html
VENVDIR       = .venv

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile clean serve install

# Install documentation dependencies
install:
	$(VENVDIR)/bin/pip install -e ".[docs]"

# Build HTML documentation (all docs including ReDoc)
html:
	@echo "Building all documentation..."
	@$(VENVDIR)/bin/$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@echo "Documentation built successfully!"
	@echo "Output: $(BUILDDIR)/"

# Clean all build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILDDIR)
	@echo "Clean complete!"

# Serve documentation with auto-reload (development)
serve:
	@echo "Starting documentation dev server with auto-reload..."
	@echo "Server will watch for changes and rebuild automatically"
	@echo "Open: http://localhost:8001"
	@echo ""
	@echo "Note: Server starts at root (index.html) with full navigation tree"
	@$(VENVDIR)/bin/sphinx-autobuild \
		--open-browser \
		--port 8001 \
		--ignore "*.pyc" \
		--ignore ".git/*" \
		--ignore "*.swp" \
		--ignore "*.swo" \
		--re-ignore ".*\.doctrees.*" \
		--watch "$(SOURCEDIR)" \
		"$(SOURCEDIR)" "$(BUILDDIR)"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
