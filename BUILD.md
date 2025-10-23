# DBCalm Documentation Build Guide

## Documentation Structure

```
/docs/
├── index.rst                    # Main documentation landing page
├── conf.py                      # Unified Sphinx configuration (includes ReDoc)
├── Makefile                     # Unified build commands
├── open/                        # Open Source documentation
│   ├── index.rst               # Open source landing page
│   ├── api/                    # Backend API docs
│   │   ├── openapi.json        # OpenAPI specification
│   │   └── *.rst               # API documentation files
│   └── frontend/               # Frontend docs (coming soon)
│       └── index.rst
└── agent/                      # Agent docs (coming soon)
    └── index.rst
```

## Build Commands

### Build All Documentation

Build the entire documentation tree including OpenAPI/ReDoc from the root:

```bash
cd /home/martijn/projects/dbcalm/docs
make html
```

Output: `/home/martijn/projects/dbcalm/marketing/public/docs/html/`

### Serve with Auto-Reload

Serve all documentation with live reload during development:

```bash
cd /home/martijn/projects/dbcalm/docs
make serve
```

Opens browser at: http://localhost:8001

The server starts at the root landing page (`index.html`) with full navigation to all documentation sections.

### Clean Build Artifacts

Remove all built documentation:

```bash
cd /home/martijn/projects/dbcalm/docs
make clean
```

## Output Locations

### Development & Production

All documentation builds to a single unified location:

**Output**: `/marketing/public/docs/html/`

### URLs (on marketing site)

- **Root landing**: `/docs/html/index.html`
- **Open source landing**: `/docs/html/open/index.html`
- **API docs**: `/docs/html/open/api/index.html`
- **API specification (ReDoc)**: `/docs/html/open/api/api-specification.html`
- **Frontend docs**: `/docs/html/open/frontend/index.html` (coming soon)
- **Agent docs**: `/docs/html/agent/index.html` (coming soon)

## Adding New Documentation

### For API Changes

1. Update RST files in `/docs/open/api/`
2. Update `openapi.json` if needed
3. Build from root: `cd /docs && make html`

### For New Components (Frontend, Agent, etc.)

1. Create directory structure: `/docs/{product}/{component}/`
2. Add `index.rst` and documentation files
3. Update parent `index.rst` to reference new component in toctree
4. Build from root: `cd /docs && make html`

All documentation automatically outputs to `/marketing/public/docs/html/` with the same directory structure.

## Troubleshooting

### ReDoc not showing in API documentation

1. Ensure `sphinxcontrib-redoc` is installed: `.venv/bin/pip list | grep redoc`
2. Check `openapi.json` exists in `/docs/open/api/`
3. Check ReDoc configuration in `/docs/conf.py`
4. Rebuild: `cd /docs && make clean && make html`

### Links not working

1. Check relative paths in RST files
2. Ensure toctree includes all referenced files
3. Rebuild to regenerate links: `cd /docs && make html`

### Serve not working

1. Ensure `sphinx-autobuild` is installed: `.venv/bin/pip install sphinx-autobuild`
2. Check port 8000 is not in use
3. Run from `/docs` directory: `cd /docs && make serve`

## Dependencies

Install all documentation dependencies:

```bash
cd /home/martijn/projects/dbcalm/docs
.venv/bin/pip install -e ".[docs]"
```

Required packages:
- sphinx
- sphinx-rtd-theme
- sphinxcontrib-redoc
- sphinx-autobuild
- myst-parser
