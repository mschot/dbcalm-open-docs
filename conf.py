# Configuration file for the Sphinx documentation builder.

import os
import sys

# Project information
project = "DBCalm"
copyright = "2024, DBCalm"
author = "DBCalm Team"
release = "0.0.1"

# General configuration
extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.napoleon",
    "sphinx.ext.viewcode",
    "sphinxcontrib.redoc",
    "myst_parser",
]

# ReDoc configuration
redoc = [
    {
        "name": "DBCalm API",
        "page": "api-specification",
        "spec": "openapi.json",
        "embed": True,  # Embed spec in HTML for offline viewing
    },
]
redoc_uri = "https://cdn.redoc.ly/redoc/latest/bundles/redoc.standalone.js"

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store", ".venv", ".venv/**"]

# HTML output options
html_theme = "sphinx_rtd_theme"
html_static_path = []
html_theme_options = {
    "navigation_depth": 4,
    "collapse_navigation": False,
    "sticky_navigation": True,
    "includehidden": True,
    "titles_only": False,
}

# MyST parser configuration
myst_enable_extensions = [
    "colon_fence",
    "deflist",
]

# Output directory for HTML
html_build_dir = "_build/html"
