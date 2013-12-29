import sys
import os

from setuptools import setup, find_packages
from setuptools.extension import Extension

import Cython
from Cython.Distutils import build_ext
from Cython.Build import cythonize

cython_cexprtk = Extension("cexprtk",
  ["cexprtk.pyx"],
  include_dirs = ["3rdparty/exprtk"])

# Create list of webresources files within fitting

setup(name="cexprtk",
  description = "Mathematical expression parser: cython wrapper around the 'C++ Mathematical Expression Toolkit Library' ",
  author = "M.J.D. Rushton",
  author_email = "m.j.d.rushton@gmail.com",
  version = 0.1.0,
  setup_requires = ['cython>=0.16'],
  ext_modules = cythonize([ cython_cexprtk ]))

