from cexprtk_custom_functions cimport CustomFunctionBase
from libcpp.string cimport string

cdef CustomFunctionBase* wrapFunction(int numargs_, string& key_, object pycallable_)