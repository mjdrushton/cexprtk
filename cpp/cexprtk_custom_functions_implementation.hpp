#ifndef GENERATE_CUSTOM_FUNCTIONS_IMPLEMENTATION
#define GENERATE_CUSTOM_FUNCTIONS_IMPLEMENTATION
#include "cexprtk_custom_functions.hpp"


class CustomFunction_0 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_0();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** );

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_0( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(0), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()()
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception );
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_0(){ }

};  


class CustomFunction_1 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_1();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_1( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(1), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_1(){ }

};  


class CustomFunction_2 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_2();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_2( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(2), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_2(){ }

};  


class CustomFunction_3 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_3();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_3( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(3), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_3(){ }

};  


class CustomFunction_4 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_4();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_4( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(4), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_4(){ }

};  


class CustomFunction_5 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_5();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_5( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(5), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_5(){ }

};  


class CustomFunction_6 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_6();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_6( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(6), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_6(){ }

};  


class CustomFunction_7 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_7();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_7( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(7), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_7(){ }

};  


class CustomFunction_8 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_8();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_8( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(8), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_8(){ }

};  


class CustomFunction_9 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_9();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_9( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(9), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_9(){ }

};  


class CustomFunction_10 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_10();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_10( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(10), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_10(){ }

};  


class CustomFunction_11 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_11();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_11( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(11), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_11(){ }

};  


class CustomFunction_12 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_12();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_12( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(12), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_12(){ }

};  


class CustomFunction_13 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_13();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_13( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(13), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12,const ExpressionValueType& a13)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_13(){ }

};  


class CustomFunction_14 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_14();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_14( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(14), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12,const ExpressionValueType& a13,const ExpressionValueType& a14)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_14(){ }

};  


class CustomFunction_15 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_15();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_15( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(15), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12,const ExpressionValueType& a13,const ExpressionValueType& a14,const ExpressionValueType& a15)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_15(){ }

};  


class CustomFunction_16 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_16();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_16( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(16), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12,const ExpressionValueType& a13,const ExpressionValueType& a14,const ExpressionValueType& a15,const ExpressionValueType& a16)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_16(){ }

};  


class CustomFunction_17 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_17();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_17( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(17), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12,const ExpressionValueType& a13,const ExpressionValueType& a14,const ExpressionValueType& a15,const ExpressionValueType& a16,const ExpressionValueType& a17)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_17(){ }

};  


class CustomFunction_18 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_18();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_18( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(18), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12,const ExpressionValueType& a13,const ExpressionValueType& a14,const ExpressionValueType& a15,const ExpressionValueType& a16,const ExpressionValueType& a17,const ExpressionValueType& a18)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_18(){ }

};  


class CustomFunction_19 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_19();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_19( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(19), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12,const ExpressionValueType& a13,const ExpressionValueType& a14,const ExpressionValueType& a15,const ExpressionValueType& a16,const ExpressionValueType& a17,const ExpressionValueType& a18,const ExpressionValueType& a19)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_19(){ }

};  


class CustomFunction_20 : public virtual exprtk::ifunction<ExpressionValueType>, public virtual CustomFunctionBase
{

private:
    CustomFunction_20();
public:
    typedef ExpressionValueType (*FunctionType)(void *, void ** , ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType,ExpressionValueType);

protected:
    FunctionType _cythonfunc;

public:

    CustomFunction_20( 
                 const std::string &key_,
                 void *pycallable_,
                 FunctionType cythonfunc_) : exprtk::ifunction<ExpressionValueType>(20), 
                                             CustomFunctionBase (key_, pycallable_),
                                             _cythonfunc(cythonfunc_)
  {
    set_pycallable(pycallable_);
  }

  virtual ExpressionValueType operator()(const ExpressionValueType& a1,const ExpressionValueType& a2,const ExpressionValueType& a3,const ExpressionValueType& a4,const ExpressionValueType& a5,const ExpressionValueType& a6,const ExpressionValueType& a7,const ExpressionValueType& a8,const ExpressionValueType& a9,const ExpressionValueType& a10,const ExpressionValueType& a11,const ExpressionValueType& a12,const ExpressionValueType& a13,const ExpressionValueType& a14,const ExpressionValueType& a15,const ExpressionValueType& a16,const ExpressionValueType& a17,const ExpressionValueType& a18,const ExpressionValueType& a19,const ExpressionValueType& a20)
{
  ExpressionValueType retval = 0.0;
  if (IfExceptionRaisedReturnNaN(retval))
  {
    return retval;
  }
  retval = _cythonfunc(_pycallable, &_pyexception , a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20);
  IfExceptionRaisedReturnNaN(retval);
  return retval;
}


  virtual ~CustomFunction_20(){ }

};  
#endif
