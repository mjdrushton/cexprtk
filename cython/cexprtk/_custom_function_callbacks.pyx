# distutils: language = c++
from cpython.ref cimport Py_INCREF
cimport cexprtk_custom_functions_implementation
from cexprtk_custom_functions cimport CustomFunctionBase
from cexprtk_custom_vararg_function cimport Custom_Vararg_Function
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef double callback_vararg(
    void * pyobj_, void ** exception_, const vector[double]& args_):
  cdef object pycallable
  cdef double retval = 0.0

  try:
    pycallable = <object>pyobj_
    retval = pycallable(*args_)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
cdef double callback_0(
    void * pyobj_, void ** exception_):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable()
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_1(
    void * pyobj_, void ** exception_, double arg_1):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_2(
    void * pyobj_, void ** exception_, double arg_1, double arg_2):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_3(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_4(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_5(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_6(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_7(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_8(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_9(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_10(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_11(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_12(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_13(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12, double arg_13):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12, arg_13)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_14(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12, double arg_13, double arg_14):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12, arg_13, arg_14)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_15(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12, double arg_13, double arg_14, double arg_15):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12, arg_13, arg_14, arg_15)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_16(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12, double arg_13, double arg_14, double arg_15, double arg_16):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12, arg_13, arg_14, arg_15, arg_16)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_17(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12, double arg_13, double arg_14, double arg_15, double arg_16, double arg_17):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12, arg_13, arg_14, arg_15, arg_16, arg_17)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_18(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12, double arg_13, double arg_14, double arg_15, double arg_16, double arg_17, double arg_18):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12, arg_13, arg_14, arg_15, arg_16, arg_17, arg_18)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_19(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12, double arg_13, double arg_14, double arg_15, double arg_16, double arg_17, double arg_18, double arg_19):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12, arg_13, arg_14, arg_15, arg_16, arg_17, arg_18, arg_19)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  
cdef double callback_20(
    void * pyobj_, void ** exception_, double arg_1, double arg_2, double arg_3, double arg_4, double arg_5, double arg_6, double arg_7, double arg_8, double arg_9, double arg_10, double arg_11, double arg_12, double arg_13, double arg_14, double arg_15, double arg_16, double arg_17, double arg_18, double arg_19, double arg_20):
  cdef object pycallable
  cdef double retval = 0.0
  
  try:
    pycallable = <object>pyobj_
    retval = pycallable(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11, arg_12, arg_13, arg_14, arg_15, arg_16, arg_17, arg_18, arg_19, arg_20)
    return retval
  except:
    import sys
    e = sys.exc_info()
    Py_INCREF(e)
    exception_[0] = <void*> e
    return 0.0
  

cdef CustomFunctionBase* wrapFunction(int numargs_, string& key_, object pycallable_):
  cdef void* pyptr = <void *> pycallable_
  cdef CustomFunctionBase* retval = NULL
  if numargs_ == -1:
    retval = new Custom_Vararg_Function(key_, pyptr, callback_vararg)
  elif numargs_ == 0:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_0(key_, pyptr, callback_0) 
  elif numargs_ == 1:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_1(key_, pyptr, callback_1) 
  elif numargs_ == 2:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_2(key_, pyptr, callback_2) 
  elif numargs_ == 3:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_3(key_, pyptr, callback_3) 
  elif numargs_ == 4:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_4(key_, pyptr, callback_4) 
  elif numargs_ == 5:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_5(key_, pyptr, callback_5) 
  elif numargs_ == 6:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_6(key_, pyptr, callback_6) 
  elif numargs_ == 7:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_7(key_, pyptr, callback_7) 
  elif numargs_ == 8:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_8(key_, pyptr, callback_8) 
  elif numargs_ == 9:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_9(key_, pyptr, callback_9) 
  elif numargs_ == 10:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_10(key_, pyptr, callback_10) 
  elif numargs_ == 11:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_11(key_, pyptr, callback_11) 
  elif numargs_ == 12:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_12(key_, pyptr, callback_12) 
  elif numargs_ == 13:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_13(key_, pyptr, callback_13) 
  elif numargs_ == 14:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_14(key_, pyptr, callback_14) 
  elif numargs_ == 15:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_15(key_, pyptr, callback_15) 
  elif numargs_ == 16:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_16(key_, pyptr, callback_16) 
  elif numargs_ == 17:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_17(key_, pyptr, callback_17) 
  elif numargs_ == 18:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_18(key_, pyptr, callback_18) 
  elif numargs_ == 19:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_19(key_, pyptr, callback_19) 
  elif numargs_ == 20:
    retval = new cexprtk_custom_functions_implementation.CustomFunction_20(key_, pyptr, callback_20) 

  return retval
