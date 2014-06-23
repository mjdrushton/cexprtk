#Change Log

##0.2.0
###New Features

* Allows re-use of parsed mathematical expressions through new classes:
    - `Expression`
    - `Symbol_Table`
* Expose support for unknown symbol resolver through the `unknown_symbol_resolver_callback` argument to the `Expression` constructor.
* Improved documentation:
    - API reference.
    - Examples of the new classes.

##0.1.2 (not released to pypi)
### Bug-Fixes

* Modifications to allow `cexprtk` to build on windows.

##0.1.1 (2013-12-30 21:37)
### Bug-Fixes

* Module would not build if cython installed. 
* Now build from pre-cythonized `cexprtk.cpp` whether `cython` available or not.

##0.1.0 (2013-12-30 19:25)

* Initial Release