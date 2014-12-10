import sys
import os

from setuptools import setup
from setuptools.extension import Extension


COMPILER_OPTIONS = dict(
  # bigobj is needed because the PE/COFF binary format
  # has a limitation of 2^15 sections, and large
  # C++ template libaries (in this case "exprtk")
  # result in object files that exceed the limit.
  # "/bigobj" extends the limit to 2^32.
  #
  # There is no solution for mingw32 currently, but
  # mingw32 may work in the future so we keep the
  # option here for the future.
  msvc=['/Ox', '/bigobj'],
  mingw32=['-O3', '-ffast-math', '-march=native']
  )


COMPILER_DEFINES = dict(
  # MSVC *does not* define WIN32.  If defines "_WIN32" for
  # both x86 and x64, and additionally defines "_WIN64" for
  # x64.  The exprtk library uses "WIN32" as a proxy for
  # Windows detection, which is wrong.
  #
  # Note that mingw32 defines both WIN32 and _WIN32.
  msvc=[('WIN32', None)]
  )


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
  class BuildExtCustom(build_ext):
    ''' A customised class, for handling special compiler
    defines and options required for building on Windows. '''
    def build_extensions(self):
      compiler_type = self.compiler.compiler_type
      if compiler_type in COMPILER_OPTIONS:
        for ext in self.extensions:
          ext.extra_compile_args = COMPILER_OPTIONS[compiler_type]
      if compiler_type in COMPILER_DEFINES:
        for ext in self.extensions:
          ext.define_macros = COMPILER_DEFINES[compiler_type]
      build_ext.build_extensions(self)
  cython_cexprtk = Extension("cexprtk",
    ["cython/cexprtk.pyx"],
    include_dirs = ["3rdparty/exprtk", "cython"])
  ext_modules = cythonize([cython_cexprtk])
  cmdclass = { 'build_ext': BuildExtCustom }


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
