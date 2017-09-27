#ifndef CEXPRTK_CUSTOM_FUNCTIONS_HPP
#define CEXPRTK_CUSTOM_FUNCTIONS_HPP

#include "cexprtk_common.hpp"
#include "Python.h"
#include <limits>
#include <string>

typedef ExpressionValueType (*PythonUnaryCythonFunctionPtr)(void *, void **, ExpressionValueType);

class UnaryFunction : public exprtk::ifunction<ExpressionValueType>
{
  private:
    void * _pycallable;
    PythonUnaryCythonFunctionPtr _cythonfunc;

    std::string _key;

    void * _pyexception;

  public:

  UnaryFunction(const std::string& key_, void * pycallable_, PythonUnaryCythonFunctionPtr cythonfunc_) : exprtk::ifunction<ExpressionValueType>(1),
    _key(key_),
    _pycallable(NULL), 
    _cythonfunc(cythonfunc_),
    _pyexception(NULL)
  {
    set_pycallable(pycallable_);
  }

  ExpressionValueType operator()(const ExpressionValueType& arg1_)
  {
    if (_pyexception)
    {
      return std::numeric_limits<ExpressionValueType>::quiet_NaN();
    }

    ExpressionValueType funcval = _cythonfunc(_pycallable, &_pyexception, arg1_);

    if (_pyexception)
    {
      return std::numeric_limits<ExpressionValueType>::quiet_NaN();
    }
    else
    {
      return funcval;
    }
  }

  const std::string& get_key() const
  {
    return _key;
  }

  void* get_pycallable()
  {
    return _pycallable;
  }

  void set_pycallable(void* pycallable_)
  {
    PyObject* pycallableptr = static_cast<PyObject*>(_pycallable);
    Py_XDECREF(pycallableptr);

    _pycallable = pycallable_;
    pycallableptr = static_cast<PyObject*>(_pycallable);
    Py_XINCREF(pycallableptr);
  }

  bool wasExceptionRaised() const
  {
    return _pyexception != NULL;
  }

  void * exception() 
  {
    return _pyexception;
  }

  /** Must be called if a previous invocation of the python object raised an exception */
  void resetException()
  {
    PyObject* pyobjptr = static_cast<PyObject*>(_pyexception);
    Py_XDECREF(pyobjptr);
    _pyexception = NULL;
  }

  virtual ~UnaryFunction(){
    PyObject* pyobjptr = static_cast<PyObject*>(_pyexception);
    Py_XDECREF(pyobjptr);

    PyObject* pycallableptr = static_cast<PyObject*>(_pycallable);
    Py_XDECREF(pycallableptr);    
  }
};
#endif