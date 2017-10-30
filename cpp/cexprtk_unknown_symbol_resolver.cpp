#include "cexprtk_unknown_symbol_resolver.hpp"

bool PythonCallableUnknownSymbolResolver::process (const std::string & s, 
		Resolver::usr_symbol_type & st, 
		ExpressionValueType & default_value, 
		std::string & error_message)
{
  if (wasExceptionRaised())
  {
    error_message = "exception_raised";
    return false;
  }

  PythonCallableUnknownSymbolResolverReturnTuple pyvals;
  pyvals.pyexception = NULL;
  _cythonfunc(s, pyvals, _pycallable);

  // Unpack values from pyvals into references passed to this method.
  st = pyvals.usrSymbolType;
  default_value = pyvals.value;
  error_message = pyvals.errorString;

  if (pyvals.pyexception)
  {
    _pyexception = pyvals.pyexception;
    return false;
  }

  return pyvals.handledFlag;
}

bool PythonCallableUnknownSymbolResolver::wasExceptionRaised() const
{
  return _pyexception != NULL;
}

void * PythonCallableUnknownSymbolResolver::exception() 
{
  return _pyexception;
}

PythonCallableUnknownSymbolResolver::~PythonCallableUnknownSymbolResolver(){
  // Make sure reference held to _pyexception is decremented.
  PyObject* pyobjptr = static_cast<PyObject*>(_pyexception);
  Py_XDECREF(pyobjptr);
}
