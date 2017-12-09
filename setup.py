import os

from setuptools import setup
from setuptools.extension import Extension

CURR_DIR = os.path.abspath(os.path.dirname(__file__))
PACKAGE_DIR = os.path.join(CURR_DIR, 'cython', 'cexprtk')

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
    gcc=['-std=c++11', '-O3'],
    clang=['-std=c++11', '-O3'],
    mingw32=['-O3', '-ffast-math', '-march=native']
)

COMPILER_DEFINES = dict(
    # MSVC *does not* define WIN32.  If defines "_WIN32" for
    # both x86 and x64, and additionally defines "_WIN64" for
    # x64.  The exprtk library uses "WIN32" as a proxy for
    # Windows detection, which is wrong.
    #
    # Note that mingw32 defines both WIN32 and _WIN32.
    msvc=[('WIN32', None)])

INCLUDE_DIRS = [
  os.path.join("3rdparty", "exprtk"), 
  "cpp",
]

try:
  from Cython.Distutils import build_ext
  from Cython.Build import cythonize
  USE_CYTHON = True
except ImportError:
  from setuptools.command.build_ext import build_ext
  USE_CYTHON = False


def cexprtkExtension():
  cythonfiles = ['cython/cexprtk/_cexprtk.pyx']
  cppfiles = [ 'cpp/cexprtk_unknown_symbol_resolver.cpp']
  cppfiles.extend(cythonfiles)
  extension = Extension('cexprtk._cexprtk',
                        cppfiles,
                        include_dirs=INCLUDE_DIRS)
  return extension

def custom_function_callbacksExtension():
  cythonfiles = ['cython/cexprtk/_custom_function_callbacks.pyx']
  cppfiles = []
  cppfiles.extend(cythonfiles)
  extension = Extension('cexprtk._custom_function_callbacks',
                        cppfiles,
                        include_dirs=INCLUDE_DIRS)
  return extension

def symbol_tableExtension():
  cythonfiles = ['cython/cexprtk/_symbol_table.pyx']
  cppfiles = []
  cppfiles.extend(cythonfiles)
  extension = Extension('cexprtk._symbol_table',
                        cppfiles,
                        include_dirs=INCLUDE_DIRS)
  return extension

def extensions():
  exts = [cexprtkExtension(), custom_function_callbacksExtension(), symbol_tableExtension()]

  if USE_CYTHON:
    return cythonize(exts,include_path = ['cython', 'cython/cexprtk'])
  else:
    # If cython isn't present then use .cpp files instead
    import os
    for extension in exts:
      srcs = []
      for s in extension.sources:
        root,ext = os.path.splitext(s)
        if ext == '.pyx':
          s = root+'.cpp'
        srcs.append(s)
      extension.sources = srcs
  return exts


class BuildExtCustom(build_ext):
  ''' A customised class, for handling special compiler
  defines and options required for building on Windows. '''
  def build_extensions(self):
    # import pdb; pdb.set_trace()
    compiler_type = self.compiler.compiler_type
    if compiler_type == 'msvc':
      pass
    elif self.compiler.compiler[0].endswith('gnu-gcc'):
      compiler_type = 'gcc'
    elif self.compiler.compiler[0].endswith('clang'):
      compiler_type = 'clang'

    if compiler_type in COMPILER_OPTIONS:
      for ext in self.extensions:
        ext.extra_compile_args = COMPILER_OPTIONS[compiler_type]
    if compiler_type in COMPILER_DEFINES:
      for ext in self.extensions:
        ext.define_macros = COMPILER_DEFINES[compiler_type]
    build_ext.build_extensions(self)

CMDCLASS = {'build_ext': BuildExtCustom}

setup(name="cexprtk",
      packages = ['cexprtk'],
      package_dir = {'' : 'cython' },
      ext_modules= extensions(),
      cmdclass=CMDCLASS,
      test_suite="tests",
      description="Mathematical expression parser: cython wrapper around the 'C++ Mathematical Expression Toolkit Library' ",
      long_description=open('README.txt').read(),
      author="M.J.D. Rushton",
      author_email="m.j.d.rushton@gmail.com",
      version="0.3.1",
      license="CPL",
      url="https://bitbucket.org/mjdr/cexprtk",
      download_url="https://bitbucket.org/mjdr/cexprtk/get/0.3.0.tar.gz",
      keywords=["math", "formula", "parser", "arithmetic", "evaluate"],
      classifiers=[
          "License :: OSI Approved :: Common Public License",
          "Programming Language :: C++",
          "Programming Language :: Python :: 2.7",
          "Programming Language :: Python :: 3.5",
          "Programming Language :: Python :: 3.6",
          "Programming Language :: Cython",
          "Topic :: Scientific/Engineering :: Mathematics"])
