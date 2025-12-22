import os
import sys

from setuptools import setup
from setuptools.extension import Extension

CURR_DIR = os.path.abspath(os.path.dirname(__file__))

# Explicit Cython language level
CYTHON_LANGUAGE_LEVEL = "3"

COMPILER_OPTIONS = dict(
    msvc=["/Ox", "/bigobj"],
    gcc=["-std=c++11", "-O3"],
    clang=["-std=c++11", "-O3"],
    mingw32=["-O3", "-ffast-math", "-march=native"],
)

COMPILER_DEFINES = dict(
    msvc=[("WIN32", None)],
)

INCLUDE_DIRS = [
    os.path.join("3rdparty", "exprtk"),
    "cpp",
]

try:
    from Cython.Build import cythonize
    from Cython.Distutils import build_ext  # noqa: F401
    USE_CYTHON = True
except ImportError:
    from setuptools.command.build_ext import build_ext  # type: ignore
    USE_CYTHON = False


def cexprtkExtension(ext):
    sources = [
        "cpp/cexprtk_unknown_symbol_resolver.cpp",
        f"cython/cexprtk/_cexprtk{ext}",
    ]
    return Extension(
        "cexprtk._cexprtk",
        sources,
        include_dirs=INCLUDE_DIRS,
    )


def custom_function_callbacksExtension(ext):
    return Extension(
        "cexprtk._custom_function_callbacks",
        [f"cython/cexprtk/_custom_function_callbacks{ext}"],
        include_dirs=INCLUDE_DIRS,
    )


def symbol_tableExtension(ext):
    return Extension(
        "cexprtk._symbol_table",
        [f"cython/cexprtk/_symbol_table{ext}"],
        include_dirs=INCLUDE_DIRS,
    )


def _require_generated_cpp():
    expected = [
        "cython/cexprtk/_cexprtk.cpp",
        "cython/cexprtk/_custom_function_callbacks.cpp",
        "cython/cexprtk/_symbol_table.cpp",
    ]
    missing = [p for p in expected if not os.path.exists(p)]
    if missing:
        raise RuntimeError(
            "Cython is not installed and generated C++ sources are missing:\n"
            + "\n".join(missing)
            + "\nInstall Cython to build from .pyx, or use an sdist that includes the generated .cpp files."
        )


def extensions():
    ext = ".pyx" if USE_CYTHON else ".cpp"

    if not USE_CYTHON:
        _require_generated_cpp()

    exts = [
        cexprtkExtension(ext),
        custom_function_callbacksExtension(ext),
        symbol_tableExtension(ext),
    ]

    if USE_CYTHON:
        return cythonize(
            exts,
            include_path=["cython", "cython/cexprtk"],
            compiler_directives={"language_level": CYTHON_LANGUAGE_LEVEL},
        )

    return exts


class BuildExtCustom(build_ext):
    """Custom build_ext to handle compiler options/defines."""

    def build_extensions(self):
        compiler_type = self.compiler.compiler_type

        if compiler_type != "msvc":
            c0 = (self.compiler.compiler or [""])[0]
            if c0.endswith("gcc"):
                compiler_type = "gcc"
            elif c0.endswith("clang"):
                compiler_type = "clang"

        if compiler_type in COMPILER_OPTIONS:
            for ext in self.extensions:
                ext.extra_compile_args = COMPILER_OPTIONS[compiler_type]

        if compiler_type in COMPILER_DEFINES:
            for ext in self.extensions:
                ext.define_macros = COMPILER_DEFINES[compiler_type]

        super().build_extensions()


setup(
    packages=["cexprtk"],
    package_dir={"": "cython"},
    ext_modules=extensions(),
    cmdclass={"build_ext": BuildExtCustom},
)