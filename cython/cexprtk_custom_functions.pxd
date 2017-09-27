from libcpp cimport bool
cimport exprtk
from libcpp.string cimport string

ctypedef double (*PythonUnaryCythonFunctionPtr)(void * , void ** , double) 

cdef extern from "cexprtk_custom_functions.hpp":
  cdef cppclass UnaryFunction:
    UnaryFunction(string& key_,
                  void * pycallable_,
                  PythonUnaryCythonFunctionPtr cythonfunc_)
    bool wasExceptionRaised()
    void* exception()
    string& get_key()
    void* get_pycallable()
    void set_pycallable(void* pycallable_)
    void resetException()

ctypedef UnaryFunction cfunction_t
ctypedef cfunction_t * cfunction_ptr
ctypedef exprtk.ifunction[double] ifunction
ctypedef ifunction * ifunction_ptr