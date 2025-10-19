# Minimal makefile for Sphinx documentation

SHELL := /bin/bash

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile openapi serve

# Install documentation dependencies
install:
	.venv/bin/pip install -e ".[docs]"

# Build HTML documentation
html:
	@echo "Building HTML documentation..."
	@.venv/bin/$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@echo "Documentation built successfully!"
	@echo "Output: $(BUILDDIR)/html/"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILDDIR)
	@rm -rf _build
	@echo "Clean complete!"

# Serve documentation with auto-reload (development)
serve: openapi
	@echo "Starting documentation dev server with auto-reload..."
	@echo "Server will watch for changes and rebuild automatically"
	@echo "Open: http://localhost:8000"
	@.venv/bin/sphinx-autobuild \
		--open-browser \
		--port 8000 \
		--ignore "*.pyc" \
		--ignore ".git/*" \
		--ignore "*.swp" \
		--ignore "*.swo" \
		"$(SOURCEDIR)" "$(BUILDDIR)/html"

# Generate OpenAPI schema from backend
openapi:
	@echo "Generating OpenAPI schema..."
	@cd ../backend && source .venv/bin/activate && python -c "import json; from dbcalm.cli.server import app; print(json.dumps(app.openapi(), indent=2))" > ../docs/openapi.json
	@echo "OpenAPI schema generated: openapi.json"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
