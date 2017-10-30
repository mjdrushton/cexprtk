#ifndef CEXPRTK_CUSTOM_VARARG_FUNCTION_HPP
#define CEXPRTK_CUSTOM_VARARG_FUNCTION_HPP

#include "cexprtk_custom_functions.hpp"

class Custom_Vararg_Function : public virtual exprtk::ivararg_function<ExpressionValueType>, public virtual CustomFunctionBase
{

public:
  typedef ExpressionValueType (*FunctionType)(void *, void **, const std::vector<ExpressionValueType> &);

private:
  Custom_Vararg_Function();

protected:
  FunctionType _cythonfunc;

public:
  Custom_Vararg_Function(
      const std::string &key_,
      void *pycallable_,
      FunctionType cythonfunc_) : exprtk::ivararg_function<ExpressionValueType>(),
                                  CustomFunctionBase(key_, pycallable_),
                                  _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  inline virtual ExpressionValueType operator()(const std::vector<ExpressionValueType> & args_)
  {
    ExpressionValueType retval = 0.0;
    if (IfExceptionRaisedReturnNaN(retval))
    {
      return retval;
    }
    retval = _cythonfunc(_pycallable, &_pyexception , args_);
    IfExceptionRaisedReturnNaN(retval);
    return retval;
  }

  virtual ~Custom_Vararg_Function() {}
};

#endif //CEXPRTK_CUSTOM_VARARG_FUNCTION_HPP
