cimport exprtk
from libcpp.set cimport set as cset
from libcpp cimport bool

from cexprtk_custom_functions cimport cfunction_ptr
#, cfunction_t, ifunction_ptr, CustomFunctionBase

cdef class _Symbol_Table_Variables:
  cdef object __weakref__

  cdef object _functions

  cdef exprtk.symbol_table_type* _csymtableptr
  cpdef list items(self)
  cdef list _get_variable_list(self)
  cdef list _get_variable_list(self)
  cpdef has_key(self, object key)

cdef class _Symbol_Table_Constants:
  cdef object __weakref__
  cdef exprtk.symbol_table_type* _csymtableptr
  cpdef list items(self)
  cdef list _get_variable_list(self)
  cpdef has_key(self, object key)

cdef class _Symbol_Table_Functions:
  cdef object __weakref__

  #cdef object _variables

  cdef exprtk.symbol_table_type* _csymtableptr
  cdef cset[cfunction_ptr] * _cfunction_set_ptr

  cdef object _reservedFunctions  
  cdef cfunction_ptr _getitem(self, bytes key)
  cdef void _remove_function_from_set(self, cfunction_ptr fptr)
  cdef void _add_function_to_set(self, cfunction_ptr fptr)
  cdef _wrapFunction(self, key, bytes strkey, object function, int numArgs_)
  cdef _resetFunctionExceptions(self)
  cdef object _checkForException(self)
  cdef _resetFunctionExceptions(self)
  cdef object _checkForException(self)
  cpdef list items(self)
  cpdef has_key(self, object key)

cdef class Symbol_Table:
  cdef exprtk.symbol_table_type* _csymtableptr
  cdef _Symbol_Table_Variables _variables
  cdef _Symbol_Table_Constants _constants
  cdef _Symbol_Table_Functions _functions

