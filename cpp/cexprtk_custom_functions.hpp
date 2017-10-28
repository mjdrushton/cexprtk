#ifndef CEXPRTK_CUSTOM_FUNCTIONS_HPP
#define CEXPRTK_CUSTOM_FUNCTIONS_HPP

#include "cexprtk_common.hpp"
#include "Python.h"
#include <limits>
#include <string>

// typedef ExpressionValueType (*PythonUnaryCythonFunctionPtr)(void *, void **, ExpressionValueType);

class CustomFunctionBase
{

private:
  CustomFunctionBase();

protected:
  std::string _key;
  void *_pycallable;
  void *_pyexception;

  virtual bool IfExceptionRaisedReturnNaN(ExpressionValueType& returnValue) const
  {
    if (_pyexception)
    {
      returnValue = std::numeric_limits<ExpressionValueType>::quiet_NaN();
      return true;
    }
    return false;
  }

public:

  CustomFunctionBase(const std::string &key_,
                     void *pycallable_) : _key(key_),
                                          _pycallable(NULL),
                                          _pyexception(NULL)
  {
    set_pycallable(pycallable_);
  }

  virtual void set_pycallable(void *pycallable_)
  {
    PyObject *pycallableptr = static_cast<PyObject *>(_pycallable);
    Py_XDECREF(pycallableptr);

    _pycallable = pycallable_;
    pycallableptr = static_cast<PyObject *>(_pycallable);
    Py_XINCREF(pycallableptr);
  }

  virtual void *get_pycallable() const
  {
    return _pycallable;
  }

  virtual bool wasExceptionRaised() const
  {
    return _pyexception != NULL;
  }

  virtual void *exception()
  {
    return _pyexception;
  }

  virtual const std::string &get_key() const
  {
    return _key;
  }

  /** Must be called if a previous invocation of the python object raised an exception */
  virtual void resetException()
  {
    PyObject *pyobjptr = static_cast<PyObject *>(_pyexception);
    Py_XDECREF(pyobjptr);
    _pyexception = NULL;
  }

  virtual ~CustomFunctionBase()
  {
    PyObject *pyobjptr = static_cast<PyObject *>(_pyexception);
    Py_XDECREF(pyobjptr);

    PyObject *pycallableptr = static_cast<PyObject *>(_pycallable);
    Py_XDECREF(pycallableptr);
  }
};


#endif