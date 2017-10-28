# distutils: language = c++

cimport cython
cimport exprtk
cimport cexprtk_unknown_symbol_resolver

cimport cexprtk_util

from cexprtk_custom_functions cimport cfunction_ptr, cfunction_t, ifunction_ptr, ivararg_function_ptr, CustomFunctionBase

from cexprtk._custom_function_callbacks cimport wrapFunction

from cpython.ref cimport Py_INCREF
from cpython.weakref  cimport PyWeakref_NewProxy

from libcpp.set cimport set as cset
from libcpp.cast cimport dynamic_cast
from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp cimport bool

from cython.operator cimport dereference as deref, preincrement as inc

from ._functionargs import functionargs

from ._exceptions import BadVariableException, NameShadowException, VariableNameShadowException, ReservedFunctionShadowException

cdef class Symbol_Table:
  """Class for providing variable and constant values to Expression instances."""

  def __reduce__(self):
    constants = dict(self.constants)
    variables = dict(self.variables)
    functions = dict(self.functions)
    return (Symbol_Table, (variables, constants, False, functions))

  def __cinit__(self):
    self._csymtableptr = new exprtk.symbol_table_type()

    # Set up the functions dictionary
    self._functions = _Symbol_Table_Functions()
    self._functions._csymtableptr = self._csymtableptr

    # Set up the variables dictionary
    self._variables = _Symbol_Table_Variables()
    # ... set the internal pointer held by _variables
    self._variables._csymtableptr = self._csymtableptr
    self._variables._functions = PyWeakref_NewProxy(self._functions, None)
    #self._functions._variables = PyWeakref_NewProxy(self._variables, None)

    # Set up the constants dictionary
    self._constants = _Symbol_Table_Constants()
    # ... set the internal pointer held by _constants
    self._constants._csymtableptr = self._csymtableptr
    

  def __dealloc__(self):
    del self._csymtableptr
    self._variables._csymtableptr = NULL
    self._constants._csymtableptr = NULL
    self._functions._csymtableptr = NULL

  def __init__(self, variables, constants = {}, add_constants = False, functions = {},):
    """Instantiate Symbol_Table defining variables and constants for Expression class.

    :param variables: Mapping between variable name and initial variable value.
    :type variables: dict

    :param constants: Constant name to value dictionary.
    :type constants: dict
    
    :param add_constants: If True, add the standard constants ``pi``, ``inf``, ``epsilon``
      to the 'constants' dictionary before populating the ``Symbol_Table``
    :type add_constants: bool

    :param functions: Dictionary containing custom functions to be made available to expressions. 
      Dictionary keys specify function names and values should be functions.
    :type functions: dict

    """

    shadowed = set(variables.keys()) & set(constants.keys())
    if shadowed:
      msg = [s for s in sorted(shadowed)]
      msg = "The following names are in both variables and constants: %s" % ",".join(msg)
      raise VariableNameShadowException(msg)

    shadowed = (set(variables.keys()) | set(constants.keys())) & set(functions.keys())
    if shadowed:
      msg = [s for s in sorted(shadowed)]
      msg = "The following function names are also in variables or constants: %s" % ",".join(msg)
      raise VariableNameShadowException(msg)

    self._populateVariables(variables)
    self._populateConstants(constants, add_constants)
    self._populateFunctions(functions)

  def _populateVariables(self,object variables):
    cdef bytes cstr
    for s, v in variables.iteritems():
      cstr = s.encode("ascii")
      if not self._csymtableptr[0].create_variable(cstr,v):
        raise BadVariableException("Error creating variable named: %s with value: %s" % (s,v))

  def _populateConstants(self, object constants, bool add_constants):
    cdef bytes cstr
    if add_constants:
      self._csymtableptr[0].add_constants()

    for s,v in constants.iteritems():
      cstr = s.encode("ascii")
      if not self._csymtableptr[0].add_constant(cstr,v):
        raise BadVariableException("Error creating constant named: %s with value: %s" % (s,v))

  def _populateFunctions(self, object functions):
    for k,v in functions.items():
      self.functions[k] = v

  property functions:
    def __get__(self):
      return PyWeakref_NewProxy(self._functions, None)

  property variables:
    def __get__(self):
      return PyWeakref_NewProxy(self._variables, None)

  property constants:
    def __get__(self):
      return PyWeakref_NewProxy(self._constants, None)


cdef class _Symbol_Table_Variables:
  """Class providing the .variables property for Symbol_Table.

  Provides a dictionary like interface, methods pass-through to
  C++ symbol_table object owned by parent Symbol_Table."""

  def __getitem__(self, object key):
    cdef bytes cstr_key = key.encode("ascii")
    cdef exprtk.symbol_table_type* st = self._csymtableptr
    cdef exprtk.variable_ptr vptr = st[0].get_variable(cstr_key)
    if vptr != NULL and not st[0].is_constant_node(cstr_key):
      return vptr[0].value()
    else:
      raise KeyError("Unknown variable: "+key)

  def __setitem__(self, object key, double value):
    cdef int rv
    cdef string strkey
    if not self._csymtableptr:
      raise ReferenceError("Parent Symbol_Table no longer exists")
    strkey = key.encode("ascii")

    if self._functions.has_key(key):
      raise VariableNameShadowException("Cannot set variable as a function already exists with the same name: "+key)

    cdef exprtk.variable_ptr vptr = self._csymtableptr[0].get_variable(strkey)
    if vptr != NULL and self._csymtableptr[0].is_constant_node(strkey):
      raise KeyError("Cannot set variable constant already exists with the same name: "+key)

    if vptr == NULL:
      rv = self._csymtableptr[0].create_variable(strkey, value)
    else:
      rv = cexprtk_util.variableAssign(self._csymtableptr[0], strkey, value)

    if not rv:
      raise KeyError("Unknown variable: "+key)

  def __iter__(self):
    return self.iterkeys()

  def __len__(self):
    return len(self.items())

  cpdef list items(self):
    cdef object strk
    cdef list retlist = []

    for (k,v) in self._get_variable_list():
      if not self._csymtableptr.is_constant_node(k):
        strk = k.decode("ascii")
        retlist.append((strk, v))
    return retlist

  def iteritems(self):
    return iter(self.items())

  def iterkeys(self):
    return iter(self.keys())

  def itervalues(self):
    return iter(self.values())

  def keys(self):
    return [ k for (k,v) in self.items()]

  def values(self):
    return [ v for (k,v) in self.items() ]

  cdef list _get_variable_list(self):
    cdef exprtk.LabelFloatPairVector itemvector = exprtk.LabelFloatPairVector()
    self._csymtableptr.get_variable_list(itemvector)
    return itemvector

  cpdef has_key(self, object key):
    try:
      key = str(key)
    except ValueError:
      return False
    
    cdef bytes cstr_key = key.encode("ascii")
    return self._csymtableptr[0].is_variable(cstr_key) and not self._csymtableptr[0].is_constant_node(cstr_key)

  def __contains__(self, object key):
    return self.has_key(key)


cdef class _Symbol_Table_Constants:
  """Class providing the .constants property for Symbol_Table.

  Provides a dictionary like interface, methods pass-through to
  C++ symbol_table object owned by parent Symbol_Table."""

  def  __getitem__(self, object key):
    cdef bytes c_key = key.encode("ascii")
    cdef exprtk.symbol_table_type* st = self._csymtableptr
    cdef exprtk.variable_ptr vptr = st[0].get_variable(c_key)
    if vptr != NULL and st[0].is_constant_node(c_key):
      return vptr[0].value()
    else:
      raise KeyError("Unknown variable: "+key)

  def __iter__(self):
    return self.iterkeys()

  def __len__(self):
    return len(self.items())

  cpdef list items(self):
    cdef object strk
    cdef list retlist = []

    for (k,v) in self._get_variable_list():
      if self._csymtableptr.is_constant_node(k):
        strk = k.decode("ascii")
        retlist.append((strk, v))
    return retlist

  def iteritems(self):
    return iter(self.items())

  def iterkeys(self):
    return iter(self.keys())

  def itervalues(self):
    return iter(self.values())

  def keys(self):
    return [ k for (k,v) in self.items() ]

  def values(self):
    return [ v for (k,v) in self.items() ]

  cdef list _get_variable_list(self):
    cdef exprtk.LabelFloatPairVector itemvector = exprtk.LabelFloatPairVector()
    self._csymtableptr.get_variable_list(itemvector)
    return itemvector

  cpdef has_key(self, object key):
    try:
      key = str(key)
    except ValueError:
      return False
    cdef bytes c_key = key.encode("ascii")
    return self._csymtableptr[0].is_variable(c_key) and self._csymtableptr[0].is_constant_node(c_key)

  def __contains__(self, key):
    return self.has_key(key)



cdef class _Symbol_Table_Functions:
  """Class providing the .functions property for Symbol_Table.

  Provides a dictionary like interface, methods pass-through to
  C++ symbol_table object owned by parent Symbol_Table."""
  
  def __cinit__(self):
    self._cfunction_set_ptr = new cset[cfunction_ptr]()

  def __init__(self):
    self._reservedFunctions = set([
      'abs', 'avg', 'ceil', 'clamp', 'equal', 'erf', 'erfc', 'exp',
      'expm1', 'floor', 'frac',  'log', 'log10', 'log1p',  'log2',
      'logn',  'max',  'min',  'mul',  'ncdf',  'nequal',  'root',
      'round', 'roundn', 'sgn', 'sqrt', 'sum', 'swap', 'trunc',
      'acos', 'acosh', 'asin', 'asinh', 'atan', 'atanh',  'atan2',
      'cos',  'cosh', 'cot',  'csc', 'sec',  'sin', 'sinc',  'sinh',
      'tan', 'tanh', 'hypot', 'rad2deg', 'deg2grad',  'deg2rad',
      'grad2deg' ])

  cdef cfunction_ptr _getitem(self, bytes key):
    cdef cfunction_ptr fptr
    cdef cset[cfunction_ptr].iterator it = self._cfunction_set_ptr[0].begin()
    while it != self._cfunction_set_ptr[0].end():
      fptr = deref(it)
      if fptr[0].get_key() == key:
        return fptr
      inc(it)
    return NULL

  cdef void _remove_function_from_set(self, cfunction_ptr fptr):
    self._cfunction_set_ptr[0].erase(fptr)
    del fptr

  cdef void _add_function_to_set(self, cfunction_ptr fptr):
    self._cfunction_set_ptr[0].insert(fptr)

  def _checkFunction(self, key, object function):
    args = functionargs(function)
    #if args == -1:
    #  raise TypeError("Functions with varargs are not supported. Whilst setting function for '"+key+"'")
    if args > 20:
      raise TypeError("Only functions with 20 or fewer arguments are supported at present. Whilst setting function for '"+key+"'")
    return args
    
  cdef _wrapFunction(self, key, bytes strkey, object function, int numArgs_):
    cdef ifunction_ptr fptr
    cdef ivararg_function_ptr vaptr
    cdef cfunction_ptr cfptr

    cdef void* pyptr
    pyptr = <void *>function
    cfptr = wrapFunction(numArgs_, strkey, function)
    self._add_function_to_set(cfptr)

    if numArgs_ != -1:
      fptr = dynamic_cast[ifunction_ptr](cfptr)
      # Add the function to the symboltable
      cexprtk_util.add_function(self._csymtableptr[0], strkey, fptr[0])
    else:
      # Add var arg function
      vaptr = dynamic_cast[ivararg_function_ptr](cfptr)
      cexprtk_util.add_varargfunction(self._csymtableptr[0], strkey, vaptr[0])

  cdef _resetFunctionExceptions(self):
    cdef cset[cfunction_ptr].iterator it = self._cfunction_set_ptr[0].begin()
    cdef cfunction_ptr func_ptr
    while it != self._cfunction_set_ptr[0].end():
      func_ptr = deref(it)
      func_ptr[0].resetException()
      inc(it)

  cdef object _checkForException(self):
    cdef cset[cfunction_ptr].iterator it = self._cfunction_set_ptr[0].begin()
    cdef cfunction_ptr func_ptr
    cdef object exception = None
    cdef void * exception_ptr
    while it != self._cfunction_set_ptr[0].end():
      func_ptr = deref(it)
      exception_ptr = func_ptr[0].exception()
      if exception_ptr:
        exception = <object> exception_ptr
        return exception
      inc(it)
    return None

  def __dealloc__(self):
    cdef cset[cfunction_ptr].iterator it = self._cfunction_set_ptr[0].begin()
    cdef cfunction_ptr func_ptr
    while it != self._cfunction_set_ptr[0].end():
      func_ptr = deref(it)
      inc(it)
      del func_ptr
    del self._cfunction_set_ptr

  def __getitem__(self, object key):
    cdef void * pyptr
    cdef cfunction_ptr fptr
    cdef bytes cstr_key = key.encode("ascii")
    if not self._csymtableptr:
      raise ReferenceError("Parent Symbol_Table no longer exists")
    fptr = self._getitem(cstr_key)
    if fptr:
      pyptr = fptr[0].get_pycallable()
      pyfunction = <object>pyptr
      return pyfunction
    else:
      raise KeyError("Unknown function: "+key)

  def __setitem__(self, object key, object f):
    cdef int rv
    cdef string strkey
    cdef cfunction_ptr cfuncptr
    if not self._csymtableptr:
      raise ReferenceError("Parent Symbol_Table no longer exists")
    strkey = key.encode("ascii")

    if key in self._reservedFunctions:
      raise ReservedFunctionShadowException("Function has same name as a built-in exprtk function: "+str(key))

    # Check if there is already a variable or constant assigned to this key.
    # If there is, then raise VariableShadow exception.
    if self._csymtableptr[0].get_variable(strkey) != NULL:
      raise VariableNameShadowException("Function cannot be set as a variable or constant shares the same name:" + key)

    cfuncptr = self._getitem(strkey)
    if cfuncptr != NULL:
      raise KeyError("Function '"+key+"' was already in symbol table.")
    
    # Wrap the new function
    numArgs = self._checkFunction(key,f)
    self._wrapFunction(key, strkey, f, numArgs)
    

  def __iter__(self):
    return self.iterkeys()

  def __len__(self):
    return self._cfunction_set_ptr[0].size()

  cpdef list items(self):
    if not self._csymtableptr:
      raise ReferenceError("Parent Symbol_Table no longer exists")
    cdef cset[cfunction_ptr].iterator it = self._cfunction_set_ptr[0].begin()
    cdef cfunction_ptr func_ptr
    cdef object pyfunc
    cdef string cstr
    cdef object strk
    cdef list retlist = []
    while it != self._cfunction_set_ptr[0].end():
      func_ptr = deref(it)
      cstr = func_ptr[0].get_key()
      strk = cstr.decode("ascii")
      pyfunc = <object> func_ptr[0].get_pycallable()
      retlist.append((strk, pyfunc))
      inc(it)
    return retlist

  def iteritems(self):
    return iter(self.items())

  def iterkeys(self):
    return iter(self.keys())

  def itervalues(self):
    return iter(self.values())

  def keys(self):
    return [ k for (k,v) in self.items()]

  def values(self):
    return [ v for (k,v) in self.items() ]

  cpdef has_key(self, object key):
    cdef bytes cstr_key = key.encode("ascii")
    return self._getitem(cstr_key) != NULL

  def __contains__(self, object key):
    return self.has_key(key)