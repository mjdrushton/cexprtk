# distutils: language = c++


from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.pair cimport pair
from libcpp cimport bool

from cpython.weakref  cimport PyWeakref_NewProxy
from cpython.ref cimport Py_INCREF

cimport cython


ctypedef pair[string,double] LabelFloatPair
ctypedef vector[LabelFloatPair] LabelFloatPairVector

cdef extern from "exprtk.hpp" namespace "exprtk::details":
  cdef cppclass variable_node[T]:
    T& ref()
    T value()


ctypedef variable_node[double] variable_t
ctypedef variable_t * variable_ptr

cdef extern from "exprtk.hpp" namespace "exprtk":
  cdef cppclass symbol_table[T]:
    symbol_table() except +
    int create_variable(string& variable_name, T& value)
    int add_constant(string& constant_name, T& value)
    int add_constants()
    variable_ptr get_variable(string& variable_name)
    int is_variable(string& variable_name)
    int is_constant_node(string& symbol_name)
    int get_variable_list(LabelFloatPairVector& vlist)
    int variable_count()

  cdef cppclass expression[T]:
    expression() except +
    void register_symbol_table(symbol_table[T])
    T value()


  cdef cppclass parser[T]:
    parser() except +
    int compile(string& expression_string, expression[T]&  expr)
    cppclass unknown_symbol_resolver:
      pass
    void enable_unknown_symbol_resolver(unknown_symbol_resolver* usr)

  cdef enum c_symbol_type "exprtk::parser<double>::unknown_symbol_resolver::symbol_type":
    e_variable_type "exprtk::parser<double>::unknown_symbol_resolver::e_variable_type"
    e_constant_type "exprtk::parser<double>::unknown_symbol_resolver::e_constant_type"


ctypedef symbol_table[double] symbol_table_type
ctypedef expression[double] expression_type
ctypedef parser[double] parser_type


cdef extern from "cexprtk.hpp":
  int variableAssign(symbol_table_type & symtable, string& name, double value)
  void parser_compile_and_process_errors(string& expression_string, parser_type& parser, expression_type& expression, vector[string]& error_messages)
  void check(string& expression_string, vector[string]& error_list)

  cdef cppclass PythonCallableReturnTuple:
    bool handledFlag
    int usrSymbolType
    double value
    string errorString
    void* pyexception


ctypedef (bool (*)(string&, PythonCallableReturnTuple&, void*)) PythonCallableCythonFunctionPtr

cdef extern from "cexprtk.hpp":
  cdef cppclass PythonCallableUnknownResolver:
    PythonCallableUnknownResolver(void *, PythonCallableCythonFunctionPtr)
    bool wasExceptionRaised() const
    void* exception()


cdef extern from *:
    parser[double].unknown_symbol_resolver* dynamic_cast_PythonCallableUnknownResolver "dynamic_cast<exprtk::parser<double>::unknown_symbol_resolver*>" (PythonCallableUnknownResolver*) except NULL


class BadVariableException(Exception):
  pass

class VariableNameShadowException(Exception):
  pass

class ParseException(Exception):
  pass


def check_expression(expression):
  """Check that expression can be parsed. If successful do nothing, if unsuccessful raise ParseException

  :param expression: Formula to be evaluated
  :type expression: str

  :raises ParseException: If expression is invalid. """

  cdef vector[string] errorlist
  check(expression, errorlist)

  if not errorlist.empty():
    # List is not empty, throw ParseException
    errorstring = ", ".join(errorlist)
    raise ParseException("Error evaluating expression '%s': %s" % (expression, errorstring))


def evaluate_expression(expression_string, variables):
  """Evaluate a mathematical formula using the exprtk library and return result.

  For more information about supported functions and syntax see the
  exprtk C++ library website http://code.google.com/p/exprtk/

  :param expression_string: Expression to be evaluated.
  :type expression_string: str

  :param variables: Dictionary containing variable name, variable value pairs to be used in expression.
  :type variables: dict

  :return: Evaluated expression
  :rtype float:

  :raises ParseException: if ``expression`` is invalid"""

  cdef Symbol_Table symbol_table = Symbol_Table(variables)
  cdef Expression expression = Expression(expression_string, symbol_table)
  return expression.value()


cdef class Expression:
  """Class representing mathematical expression.

  * Following instantiation, the expression is evaluated calling the expression or
  invoking its ``value()`` method.
  * The variable values used by the Expression can be modified through the ``variables``
  property of the ``Symbol_Table`` instance associated with the expression.
  The ``Symbol_Table`` can be accessed using the ``Expression.symbol_table`` property.

  Description of ``unknown_symbol_resolver_callback`` argument:
  -------------------------------------------------------------

  The ``unknown_symbol_resolver_callback`` argument  to the ``Expression``
  constructor accepts a callable which is invoked  whenever a symbol (i.e. a
  variable or a constant), is not found in the ``Symbol_Table`` given by the
  ``symbol_table`` argument. The ``unknown_symbol_resolver_callback`` can be
  used to provide a value for the missing value or to set an error condition.

  The callable should have following signature::

    def callback(symbol_name):
      ...


  Where ``symbol_name`` is a string identifying the missing symbol.

  The callable should return a tuple of the form::

    (HANDLED_FLAG, USR_SYMBOL_TYPE, SYMBOL_VALUE, ERROR_STRING)

  Where:
    * ``HANDLED_FLAG`` is a boolean, ``True`` indicates that callback was able
      handle the error condition and that ``SYMBOL_VALUE`` should be used for
      the missing symbol. ``False``, flags and error condition, the reason why
      the unknown symbol could not be resolved by the callback is described by
      ``ERROR_STRING``.
    * ``USR_SYMBOL_TYPE`` gives type of symbol (constant or variable)
      that should be added to the ``symbol_table`` when unkown symbol is resolved.
      Value should be one of those given in ``cexprtk.USRSymbolType``;
    * ``SYMBOL_VALUE``, floating point value that should be used when resolving
      missing symbol.
    * ``ERROR_STRING`` when ``HANDLED_FLAG`` is ``False`` this can be used to
      describe error condition.
  """

  cdef Symbol_Table _symbol_table
  cdef expression_type * _cexpressionptr

  def __cinit__(self):
    # Create the expression
    self._cexpressionptr = new expression_type()


  def __dealloc__(self):
    del self._cexpressionptr


  def __init__(self, expression, symbol_table, unknown_symbol_resolver_callback = None):
    """Instantiate ``Expression`` from a text string giving formula and ``Symbol_Table``
    instance encapsulating variables and constants used by the expression.


    :param expression: String giving expression to be calculated.
    :type expression: str

    :param symbol_table: Object defining variables and constants.
    :type symbol_table: cexprtk.Symbol_Table

    :param unknown_symbol_resolver_callback:
    :type unknown_symbol_resolver_callback: callable (see above)"""

    self._symbol_table = symbol_table

    cdef vector[string] error_list  = vector[string]()

    self._init_expression(expression, error_list, unknown_symbol_resolver_callback)
    if not error_list.empty():
      msg = ", ".join([ s for s in error_list])
      raise ParseException(msg)


  cdef _init_expression(self, str expression_string, vector[string]& error_list, object unknown_symbol_resolver_callback):
    cdef parser_type p
    cdef PythonCallableUnknownResolver * pcurPtr = NULL
    cdef parser[double].unknown_symbol_resolver * usrPtr = NULL

    self._cexpressionptr.register_symbol_table(self._symbol_table._csymtableptr[0])

    if not unknown_symbol_resolver_callback == None:
      pcurPtr = new PythonCallableUnknownResolver(
        <void *> unknown_symbol_resolver_callback,
        unknownResolverCythonCallable)
      usrPtr = dynamic_cast_PythonCallableUnknownResolver(pcurPtr)
      p.enable_unknown_symbol_resolver(usrPtr)


    try:
      parser_compile_and_process_errors(expression_string,
                                        p,
                                        self._cexpressionptr[0],
                                        error_list)

      # Check for exceptions raised by callback. Re-raise if found.
      if pcurPtr != NULL and pcurPtr.wasExceptionRaised():
          exception = <object> pcurPtr.exception()
          raise exception

    finally:
      if pcurPtr != NULL:
        del pcurPtr

  def value(self):
    """Evaluate expression using variable values currently set within associated Symbol_Table

    :return: Value resulting from evaluation of expression.
    :rtype: float"""
    cdef double v = self._cexpressionptr.value()
    return v

  def __call__(self):
    """Equivalent to calling value() method."""
    return self.value()

  property symbol_table:
    def __get__(self):
      return self._symbol_table

cdef class Symbol_Table:
  """Class for providing variable and constant values to Expression instances."""

  cdef symbol_table_type* _csymtableptr
  cdef _Symbol_Table_Variables _variables
  cdef _Symbol_Table_Constants _constants

  def __cinit__(self):
    self._csymtableptr = new symbol_table_type()

    # Set up the variables dictionary
    self._variables = _Symbol_Table_Variables()
    # ... set the internal pointer held by _variables
    self._variables._csymtableptr = self._csymtableptr

    # Set up the constants dictionary
    self._constants = _Symbol_Table_Constants()
    # ... set the internal pointer held by _constants
    self._constants._csymtableptr = self._csymtableptr


  def __dealloc__(self):
    del self._csymtableptr
    self._variables._csymtableptr = NULL
    self._constants._csymtableptr = NULL


  def __init__(self, variables, constants = {}, add_constants = False):
    """Instantiate Symbol_Table defining variables and constants for Expression class.

    :param variables: Mapping between variable name and initial variable value.
    :type variables: dict

    :param constants: Constant name to value dictionary.
    :type constants: dict

    :param add_constants: If True, add the standard constants ``pi``, ``inf``, ``epsilon``
      to the 'constants' dictionary before populating the ``Symbol_Table``
    :type add_constants: bool
    """

    shadowed = set(variables.keys()) & set(constants.keys())
    if shadowed:
      msg = [str(s) for s in sorted(shadowed)]
      msg = "The following names are in both variables and constants: %s" % ",".join(msg)
      raise VariableNameShadowException(msg)

    self._populateVariables(variables)
    self._populateConstants(constants, add_constants)


  def _populateVariables(self,object variables):
    for s, v in variables.iteritems():
      if not self._csymtableptr[0].create_variable(s,v):
        raise BadVariableException("Error creating variable named: %s with value: %s" % (s,v))


  def _populateConstants(self, object constants, int add_constants):
    if add_constants:
      self._csymtableptr[0].add_constants()

    for s,v in constants.iteritems():
      if not self._csymtableptr[0].add_constant(s,v):
        raise BadVariableException("Error creating constant named: %s with value: %s" % (s,v))


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

  cdef object __weakref__

  cdef symbol_table_type* _csymtableptr

  def __getitem__(self, string key):
    cdef symbol_table_type* st = self._csymtableptr
    cdef variable_ptr vptr = st[0].get_variable(key)
    if vptr != NULL and not st[0].is_constant_node(key):
      return vptr[0].value()
    else:
      raise KeyError("Unknown variable: "+key)

  def __setitem__(self, string key, double value):
    cdef int rv
    if not self._csymtableptr:
      raise ReferenceError("Parent Symbol_Table no longer exists")
    rv = variableAssign(self._csymtableptr[0], key, value)
    if not rv:
      raise KeyError("Unknown variable: "+key)

  def __iter__(self):
    return self.iterkeys()

  def __len__(self):
    return len(self.items())

  cpdef list items(self):
    return [ (k,v) for (k,v) in self._get_variable_list() if not self._csymtableptr.is_constant_node(k) ]

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
    cdef LabelFloatPairVector itemvector = LabelFloatPairVector()
    self._csymtableptr.get_variable_list(itemvector)
    return itemvector

  cpdef has_key(self, key):
    try:
      key = str(key)
    except ValueError:
      return False
    return self._csymtableptr[0].is_variable(key) and not self._csymtableptr[0].is_constant_node(key)

  def __contains__(self, key):
    return self.has_key(key)


cdef class _Symbol_Table_Constants:
  """Class providing the .constants property for Symbol_Table.

  Provides a dictionary like interface, methods pass-through to
  C++ symbol_table object owned by parent Symbol_Table."""

  cdef object __weakref__

  cdef symbol_table_type* _csymtableptr

  def  __getitem__(self, string key):
    cdef symbol_table_type* st = self._csymtableptr
    cdef variable_ptr vptr = st[0].get_variable(key)
    if vptr != NULL and st[0].is_constant_node(key):
      return vptr[0].value()
    else:
      raise KeyError("Unknown variable: "+key)

  def __iter__(self):
    return self.iterkeys()

  def __len__(self):
    return len(self.items())

  cpdef list items(self):
    return [ (k,v) for (k,v) in self._get_variable_list() if self._csymtableptr.is_constant_node(k)]

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
    cdef LabelFloatPairVector itemvector = LabelFloatPairVector()
    self._csymtableptr.get_variable_list(itemvector)
    return itemvector

  cpdef has_key(self, key):
    try:
      key = str(key)
    except ValueError:
      return False
    return self._csymtableptr[0].is_variable(key) and self._csymtableptr[0].is_constant_node(key)

  def __contains__(self, key):
    return self.has_key(key)

@cython.internal
cdef class _USRSymbolType:
  cdef:
    readonly int VARIABLE
    readonly int CONSTANT

  def __cinit__(self):
    self.VARIABLE = e_variable_type
    self.CONSTANT = e_constant_type

USRSymbolType = _USRSymbolType()


class UnknownSymbolResolverException(Exception):
  pass

# Function with PythonCallableFunctionPtr signature that is used to allow
# a python callback to be invoked from C++ within PythonCallableUnknownResolver.
cdef bool unknownResolverCythonCallable(
  const string& sym,
  PythonCallableReturnTuple&
  retvals, void * pyobj):
  try:
    handledFlag, usrSymbolType, value, errorString = (<object>pyobj)(sym)
    retvals.handledFlag = handledFlag

    if usrSymbolType == e_variable_type:
      retvals.usrSymbolType = e_variable_type
    elif usrSymbolType == e_constant_type:
      retvals.usrSymbolType = e_constant_type
    else:
      raise UnknownSymbolResolverException("Unknown symbol type returned by unknown_symbol_resolver_callback.")

    retvals.value = value
    retvals.errorString = errorString
    return True
  except Exception as e:
    #Increment e's ref count and then store it in return tuple as void*
    Py_INCREF(e)
    retvals.pyexception = <void * >e
    retvals.errorString = str(e)
    return False

