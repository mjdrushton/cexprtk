# distutils: language = c++
from libcpp.string cimport string
from cexprtk_custom_functions cimport CustomFunctionBase
cdef extern from "cexprtk_custom_functions_implementation.hpp":


  cdef cppclass CustomFunction_0(CustomFunctionBase):
    CustomFunction_0(string& key_, void * pycallable_, (double (*)(void *, void ** )) cythonfunc_)


  cdef cppclass CustomFunction_1(CustomFunctionBase):
    CustomFunction_1(string& key_, void * pycallable_, (double (*)(void *, void ** , double)) cythonfunc_)


  cdef cppclass CustomFunction_2(CustomFunctionBase):
    CustomFunction_2(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double)) cythonfunc_)


  cdef cppclass CustomFunction_3(CustomFunctionBase):
    CustomFunction_3(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_4(CustomFunctionBase):
    CustomFunction_4(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_5(CustomFunctionBase):
    CustomFunction_5(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_6(CustomFunctionBase):
    CustomFunction_6(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_7(CustomFunctionBase):
    CustomFunction_7(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_8(CustomFunctionBase):
    CustomFunction_8(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_9(CustomFunctionBase):
    CustomFunction_9(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_10(CustomFunctionBase):
    CustomFunction_10(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_11(CustomFunctionBase):
    CustomFunction_11(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_12(CustomFunctionBase):
    CustomFunction_12(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_13(CustomFunctionBase):
    CustomFunction_13(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_14(CustomFunctionBase):
    CustomFunction_14(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_15(CustomFunctionBase):
    CustomFunction_15(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_16(CustomFunctionBase):
    CustomFunction_16(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_17(CustomFunctionBase):
    CustomFunction_17(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_18(CustomFunctionBase):
    CustomFunction_18(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_19(CustomFunctionBase):
    CustomFunction_19(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)


  cdef cppclass CustomFunction_20(CustomFunctionBase):
    CustomFunction_20(string& key_, void * pycallable_, (double (*)(void *, void ** , double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double,double)) cythonfunc_)
