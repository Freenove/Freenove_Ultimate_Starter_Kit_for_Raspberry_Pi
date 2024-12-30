# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here.
from datetime import datetime
import os
import pathlib
import sys

sys.path.insert(0, pathlib.Path(__file__).parents[2].resolve().as_posix())

os.system("rm -r freenove_Kit")
os.system("git clone --depth 1 https://github.com/Freenove/Freenove_Ultimate_Starter_Kit_for_Raspberry_Pi freenove_Kit")


def prepend_to_file(file_path, content):
    with open(file_path, "r+") as file:
        original = file.read()
        file.seek(0)  # 将文件光标移动到开头
        file.write(content)
        file.write(original)

def apend_to_file(file_path, content):
    with open(file_path, "a") as file:
        file.write(content)

# extlinks = {
#     "fnk0020_github_url": (
#         "https://github.com/Freenove/Freenove_Ultimate_Starter_Kit_for_Raspberry_Pi%s",
#         "fnk0020_github_url%s",
#     )
# }

print("hello")
# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "fnk0066-docs"
copyright = "2016 - " + str(datetime.now().year) + ", support@freenove.com"
author = "freenove"
release = "v1.0"
version = "v1.0"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

# extensions = []
extensions = [
    "sphinx_rtd_theme",
    # "sphinx.ext.extlinks",
    # "sphinx.ext.intersphinx",
]

templates_path = ["_templates"]
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

# html_theme = 'alabaster'
html_theme = "sphinx_rtd_theme"
# html_theme = 'pydata_sphinx_theme'


html_static_path = ["_static"]

html_logo = "_static/component-imgs/freenove-logo.png"
html_theme_options = {
    "collapse_navigation": False,
    "logo_only": True,
    "navigation_depth": -1,
    "version_selector": True,
    "includehidden": True,
    # "flyout_display": "attached",
    # 'style_nav_header_background': '#005500',
}


rst_prolog = """
.. include:: <s5defs.txt>
.. include:: ../../../_static/style/custom-style.txt
 """

variables_to_export = [
    "project",
    "copyright",
    "version",
]
frozen_locals = dict(locals())
prolog = "\n".join(
    map(lambda x: f".. |{x}| replace:: {frozen_locals[x]}",
        variables_to_export)
)
# rst_prolog = rst_prolog + prolog
print(rst_prolog)
del frozen_locals


html_css_files = [
    "css/color-roles.css",
]

intersphinx_mapping = {
    "rpi-starter-kit": ("https://freenove-docs2.readthedocs.io/projects/fnk0066/en/latest/", None),
}
intersphinx_disabled_reftypes = ["*"]


def setup(app):
    pass
    app.add_css_file("css/custom.css")

