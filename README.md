# DBCalm Documentation

This directory contains the source files for the DBCalm documentation, built with Sphinx and hosted on ReadTheDocs.

## Building the Documentation

### Prerequisites

Install the required dependencies from the docs directory:

```bash
cd docs
pip install -e ".[docs]"
```

Or use the Makefile:

```bash
cd docs
make install
```

### Build HTML Output

To build the documentation:

```bash
make html
```

The documentation will be built to `_build/html/`

### Serve Locally

To build and serve the documentation locally:

```bash
make serve
```

This will build the docs and start a local web server at http://localhost:8000

### Clean Build Artifacts

To clean all build artifacts:

```bash
make clean
```

## Documentation Structure

- `index.rst` - Main entry point and table of contents
- `installation.rst` - Debian installation instructions
- `api-reference.rst` - FastAPI API documentation
- `developer-guide.rst` - Development setup and contribution guide
- `openapi.json` - Generated OpenAPI specification from FastAPI backend
- `conf.py` - Sphinx configuration
- `../pyproject.toml` - Python dependencies for building docs (see `[project.optional-dependencies]`)

## Updating API Documentation

The API documentation is generated from the FastAPI backend. To regenerate the OpenAPI spec:

```bash
cd ../backend
source .venv/bin/activate
python -c "
from dbcalm.cli.server import app
import json
openapi_schema = app.openapi()
print(json.dumps(openapi_schema, indent=2))
" > ../docs/openapi.json
```

Then rebuild the documentation:

```bash
cd ../docs
make clean
make html
```

## Publishing to ReadTheDocs

1. Connect your repository to ReadTheDocs
2. Configure ReadTheDocs to use this `docs` directory
3. Set Python version to 3.11+
4. ReadTheDocs will automatically build on each commit

### ReadTheDocs Configuration

The `.readthedocs.yaml` file in the repository root is already configured:

```yaml
version: 2

build:
  os: ubuntu-22.04
  tools:
    python: "3.11"

sphinx:
  configuration: docs/conf.py
  fail_on_warning: false

python:
  install:
    - method: pip
      path: .
      extra_requirements:
        - docs

formats:
  - pdf
  - epub
```

This installs the package with documentation dependencies from `pyproject.toml`.

## Contributing

When adding new documentation:

1. Create or update `.rst` files
2. Add new pages to `index.rst` toctree
3. Build locally to verify: `make html`
4. Commit and push changes

For API changes, regenerate `openapi.json` from the backend.
