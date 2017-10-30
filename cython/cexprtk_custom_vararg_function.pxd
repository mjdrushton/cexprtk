# distutils: language = c++

from libcpp.string cimport string
from libcpp.vector cimport vector
from cexprtk_custom_functions cimport CustomFunctionBase

cdef extern from "cexprtk_custom_vararg_function.hpp":

  cdef cppclass Custom_Vararg_Function(CustomFunctionBase):
      Custom_Vararg_Function(
        string &key_,
        void * pycallable_,
        (double (*)(void *, void **, vector[double] & args_))
        )