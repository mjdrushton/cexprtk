from libcpp cimport bool
cimport exprtk
from libcpp.string cimport string

cdef extern from "cexprtk_custom_functions.hpp":
  cdef cppclass CustomFunctionBase:
    bool wasExceptionRaised()
    void* exception()
    string& get_key()
    void* get_pycallable()
    void set_pycallable(void* pycallable_)
    void resetException()
    
ctypedef CustomFunctionBase cfunction_t
ctypedef cfunction_t * cfunction_ptr
ctypedef exprtk.ifunction[double] ifunction
ctypedef ifunction * ifunction_ptr

ctypedef exprtk.ivararg_function[double] ivararg_function
ctypedef ivararg_function * ivararg_function_ptr
