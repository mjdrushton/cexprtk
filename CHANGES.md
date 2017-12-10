#Change Log

##0.3.1 (2017-11-28)
### Bug-Fixes

* Bug fixes to `setup.py` to allow building on Linux using gcc.
* Build scripts to assist making wheels on Linux, Windows and MacOSX

##0.3.0 (2017-11-27)
### New Features

* Support for Python 3
* Custom python functions can now be registered with `Symbol_Table` and used in expressions.

##0.2.1 (2017-08-03): 
### New Features

* Updated version of bundled `exprtk` to that current as of 3rd August 2017.
* Updated `cexprtk` wrapper code to be compatible with this version of `exprtk`.
* Enabled pickling of the `Expression` and `Symbol_Table` classes. Primarily this is to allow their use with the multiprocessing module.


##0.2.0
###New Features

* Allows re-use of parsed mathematical expressions through new classes:
    - `Expression`
    - `Symbol_Table`
* Expose support for unknown symbol resolver through the `unknown_symbol_resolver_callback` argument to the `Expression` constructor.
* Improved documentation:
    - API reference.
    - Examples of the new classes.
* Updated version of `exprtk` bundled in `3rdparty`

##0.1.2 (not released to pypi)
### Bug-Fixes

* Modifications to allow `cexprtk` to build on windows.

##0.1.1 (2013-12-30)
### Bug-Fixes

* Module would not build if cython installed. 
* Now build from pre-cythonized `cexprtk.cpp` whether `cython` available or not.

##0.1.0 (2013-12-30)

* Initial Release
