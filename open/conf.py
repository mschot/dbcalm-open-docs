# Configuration file for Open Source documentation

import os
import sys

# Project information
project = "DBCalm Open Source"
copyright = "2024, DBCalm"
author = "DBCalm Team"
release = "0.0.1"

# General configuration
extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.napoleon",
    "sphinx.ext.viewcode",
    "myst_parser",
]

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store", "../.venv", "../.venv/**"]

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
