import sys
import os

from setuptools import setup
from setuptools.extension import Extension

try:
  from Cython.Distutils import build_ext
  from Cython.Build import cythonize
except ImportError:
  cython_cexprtk = Extension("cexprtk",
                             ["cython/cexprtk.cpp"],
                             language = "c++",
                             include_dirs = ["3rdparty/exprtk", "cython"])
  ext_modules = [ cython_cexprtk ]
  cmdclass = {}
else:
    cython_cexprtk = Extension("cexprtk",
      ["cython/cexprtk.pyx"],
      include_dirs = ["3rdparty/exprtk", "cython"])
    ext_modules = cythonize([cython_cexprtk])
    cmdclass = { 'build_ext': build_ext }

setup(name="cexprtk",
  description = "Mathematical expression parser: cython wrapper around the 'C++ Mathematical Expression Toolkit Library' ",
  author = "M.J.D. Rushton",
  author_email = "m.j.d.rushton@gmail.com",
  version = "0.1.0",
  ext_modules = ext_modules)
