# distutils: language = c++

cimport cython
cimport exprtk
cimport cexprtk_unknown_symbol_resolver

cimport cexprtk_util

from cpython.ref cimport Py_INCREF
from cython.operator cimport dereference

from libcpp.cast cimport dynamic_cast
from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp cimport bool

from ._symbol_table cimport Symbol_Table, _Symbol_Table_Functions

from ._exceptions import ParseException, UnknownSymbolResolverException

def check_expression(expression):
  """Check that expression can be parsed. If successful do nothing, if unsuccessful raise ParseException

  :param expression: Formula to be evaluated
  :type expression: str

  :raises ParseException: If expression is invalid. """

  cdef vector[string] errorlist
  cdef list strerrorlist
  cdef bytes c_expression = expression.encode("ascii")
  cexprtk_util.check(c_expression, errorlist)

  if not errorlist.empty():
    # List is not empty, throw ParseException
    strerrorlist = [ s.decode("ascii") for s in errorlist]
    errorstring = ", ".join(strerrorlist)
    
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
  cdef exprtk.expression_type * _cexpressionptr
  cdef object _expression
  cdef object _unknown_symbol_resolver_callback

  def __cinit__(self):
    # Create the expression
    self._cexpressionptr = new exprtk.expression_type()

  def __dealloc__(self):
    del self._cexpressionptr

  def __reduce__(self):
    return (Expression, (self._expression, self.symbol_table, self._unknown_symbol_resolver_callback))

  def __init__(self, expression, symbol_table, unknown_symbol_resolver_callback = None):
    """Instantiate ``Expression`` from a text string giving formula and ``Symbol_Table``
    instance encapsulating variables and constants used by the expression.

    :param expression: String giving expression to be calculated.
    :type expression: str

    :param symbol_table: Object defining variables and constants.
    :type symbol_table: cexprtk.Symbol_Table

    :param unknown_symbol_resolver_callback:
    :type unknown_symbol_resolver_callback: callable (see above)"""
    if not symbol_table:
      symbol_table = Symbol_Table({})

    self._expression = expression
    self._symbol_table = symbol_table
    self._unknown_symbol_resolver_callback = unknown_symbol_resolver_callback

    cdef vector[string] error_list  = vector[string]()
    cdef list strerror_list

    self._init_expression(expression, error_list, unknown_symbol_resolver_callback)
    if not error_list.empty():
      strerror_list = [ s.decode("ascii") for s in error_list]
      msg =  ", ".join(strerror_list)
      raise ParseException(msg)


  cdef _init_expression(self, object expression_string, vector[string]& error_list, object unknown_symbol_resolver_callback):
    cdef exprtk.parser_type p
    cdef cexprtk_unknown_symbol_resolver.PythonCallableUnknownSymbolResolver * pcurPtr = NULL
    cdef exprtk.parser[double].unknown_symbol_resolver * usrPtr = NULL

    self._cexpressionptr.register_symbol_table(self._symbol_table._csymtableptr[0])

    if not unknown_symbol_resolver_callback == None:
      pcurPtr = new cexprtk_unknown_symbol_resolver.PythonCallableUnknownSymbolResolver(
        <void *> unknown_symbol_resolver_callback,
        unknownResolverCythonCallable)
      usrPtr = cexprtk_unknown_symbol_resolver.dynamic_cast_PythonCallableUnknownSymbolResolver(pcurPtr)
      p.enable_unknown_symbol_resolver(usrPtr)

    p.replace_symbol(b"math.acos"  ,b"acos" )
    p.replace_symbol(b"math.acosh" ,b"acosh")
    p.replace_symbol(b"math.asin"  ,b"asin" )
    p.replace_symbol(b"math.asinh" ,b"asinh")
    p.replace_symbol(b"math.atan2" ,b"atan2")
    p.replace_symbol(b"math.atan"  ,b"atan" )
    p.replace_symbol(b"math.atanh" ,b"atanh")
    p.replace_symbol(b"math.ceil"  ,b"ceil" )
    p.replace_symbol(b"math.cos"   ,b"cos"  )
    p.replace_symbol(b"math.cosh"  ,b"cosh" )
    p.replace_symbol(b"math.erfc"  ,b"erfc" )
    p.replace_symbol(b"math.erf"   ,b"erf"  )
    p.replace_symbol(b"math.exp"   ,b"exp"  )
    p.replace_symbol(b"math.expm1" ,b"expm1")
    p.replace_symbol(b"math.fabs"  ,b"fabs" )
    p.replace_symbol(b"math.floor" ,b"floor")
    p.replace_symbol(b"math.hypot" ,b"hypot")
    p.replace_symbol(b"math.log10" ,b"log10")
    p.replace_symbol(b"math.log1p" ,b"log1p")
    p.replace_symbol(b"math.log2"  ,b"log2" )
    p.replace_symbol(b"math.log"   ,b"log"  )
    p.replace_symbol(b"math.pow"   ,b"pow"  )
    p.replace_symbol(b"math.sinh"  ,b"sinh" )
    p.replace_symbol(b"math.sin"   ,b"sin"  )
    p.replace_symbol(b"math.sqrt"  ,b"sqrt" )
    p.replace_symbol(b"math.tanh"  ,b"tanh" )
    p.replace_symbol(b"math.tan"   ,b"tan"  )
    p.replace_symbol(b"math.trunc" ,b"trunc")

    try:
      cexprtk_util.parser_compile_and_process_errors(expression_string.encode("ascii"),
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
    cdef _Symbol_Table_Functions funcs = self._symbol_table._functions
    funcs._resetFunctionExceptions()
    cdef double v = self._cexpressionptr.value()
    cdef object exception = funcs._checkForException()
    if exception:
      raise exception[0], exception[1], exception[2]
    return v

  def results(self):
    """Gets the results of evaluating the expression.

    :return: A list of the results from evaluating the expression, if any.
    :rtype: list"""
    cdef exprtk.type_store_type ts
    cdef exprtk.type_store[double].scalar_view * sv
    cdef exprtk.type_store[double].string_view * string_view
    cdef exprtk.type_store[double].vector_view * vector_view
    cdef double x
    cdef exprtk.results_context_type resultscontext = self._cexpressionptr.results()
    ret_list = []
    for i in range(resultscontext.count()):
      ts = resultscontext[i]
      if ts.type == 1:
        sv = new exprtk.type_store[double].scalar_view(ts)
        ret_list.append(sv.v_)
        del sv
      elif ts.type == 2:
        # Get the vector and append it here
        # ret_list.append(f'Type: {ts.type}')
        vector_view = new exprtk.type_store[double].vector_view(ts)
        sub_list = []
        for i in range(vector_view.size()):
          x = dereference(vector_view)[i]
          sub_list.append(x)
        ret_list.append(sub_list)
        del vector_view
      elif ts.type == 3:
        # Get string and append it here
        string_view = new exprtk.type_store[double].string_view(ts)
        ret_list.append(exprtk.to_str(dereference(string_view)).decode('ascii'))
        del string_view
        # pass
      else:
        # No idea what type it is, ignore it
        continue
    return ret_list

  def __call__(self):
    """Equivalent to calling value() method."""
    return self.value()

  property expression:
    def __get__(self):
      return self._expression
  
  property symbol_table:
    def __get__(self):
      return self._symbol_table

@cython.internal
cdef class _USRSymbolType:
  cdef:
    readonly int VARIABLE
    readonly int CONSTANT

  def __cinit__(self):
    self.VARIABLE = exprtk.e_variable_type
    self.CONSTANT = exprtk.e_constant_type

USRSymbolType = _USRSymbolType()

# Function with PythonCallableFunctionPtr signature that is used to allow
# a python callback to be invoked from C++ within PythonCallableUnknownSymbolResolver.
cdef bool unknownResolverCythonCallable(
    const string& sym,
    cexprtk_unknown_symbol_resolver.PythonCallableUnknownSymbolResolverReturnTuple&
    retvals, void * pyobj):

  cdef bytes c_errorString
  cdef object py_sym
  cdef bytes c_sym = sym
  try:
    py_sym = c_sym.decode("ascii")
    handledFlag, usrSymbolType, value, errorString = (<object>pyobj)(py_sym)
    retvals.handledFlag = handledFlag

    if usrSymbolType == exprtk.e_variable_type:
      retvals.usrSymbolType = exprtk.e_variable_type
    elif usrSymbolType == exprtk.e_constant_type:
      retvals.usrSymbolType = exprtk.e_constant_type
    else:
      raise UnknownSymbolResolverException("Unknown symbol type returned by unknown_symbol_resolver_callback.")

    retvals.value = value
    c_errorString = errorString.encode("ascii")
    retvals.errorString = c_errorString
    return True
  except Exception as e:
    #Increment e's ref count and then store it in return tuple as void*
    Py_INCREF(e)
    retvals.pyexception = <void * >e
    c_errorString  = str(e).encode("ascii")
    retvals.errorString = c_errorString
    return False