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
  ext_modules = ext_modules,
  cmdclass = cmdclass,
  test_suite = "tests",
  description = "Mathematical expression parser: cython wrapper around the 'C++ Mathematical Expression Toolkit Library' ",
  long_description = open('README.txt').read(),
  author = "M.J.D. Rushton",
  author_email = "m.j.d.rushton@gmail.com",
  version = "0.2.0",
  license = "CPL",
  url = "https://bitbucket.org/mjdr/cexprtk",
  download_url = "https://bitbucket.org/mjdr/cexprtk/get/0.2.0.tar.gz",
  keywords = ["math", "formula", "parser", "arithmetic", "evaluate"],
  classifiers = [
    "License :: OSI Approved :: Common Public License",
    "Programming Language :: C++",
    "Programming Language :: Python :: 2.7",
    "Programming Language :: Cython",
    "Topic :: Scientific/Engineering :: Mathematics"])
