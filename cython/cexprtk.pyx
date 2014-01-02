# distutils: language = c++


from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.pair cimport pair

ctypedef pair[string,double] LabelFloatPair
ctypedef vector[LabelFloatPair] LabelFloatPairVector

cdef extern from "cexprtk.hpp":
  double evaluate(string expression_string, LabelFloatPairVector variables, vector[string] error_messages)
  void check(string expression_string, vector[string] error_list)

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


ctypedef symbol_table[double] symbol_table_type
ctypedef expression[double] expression_type
ctypedef parser[double] parser_type

cdef extern from "cexprtk.hpp":
  void variableAssign(symbol_table_type & symtable, string& name, double value)


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


def evaluate_expression(expression, variables):
  """Evaluate a mathematical formula using the exprtk library and return result.

  For more information about supported functions and syntax see the
  exprtk C++ library website http://code.google.com/p/exprtk/

  :param expression: Expression to be evaluated.
  :type expression: str

  :param variables: Dictionary containing variable name, variable value pairs to be used in expression.
  :type variables: dict

  :return: Evaluated expression
  :rtype float:

  :raises ParseException: if ``expression`` is invalid"""

  cdef vector[string] errorlist
  cdef double v = evaluate(expression, variables.items(), errorlist)

  if not errorlist.empty():
    # List is not empty, throw ParseException
    errorstring = ", ".join(errorlist)
    raise ParseException("Error evaluating expression '%s': %s" % (expression, errorstring))

  return v

cdef class Expression:
  """Class representing mathematical expression"""

  cdef Symbol_Table _symbol_table
  cdef expression_type * _cexpressionptr

  def __cinit__(self):
    # Create the expression
    self._cexpressionptr = new expression_type()


  def __dealloc__(self):
    del self._cexpressionptr


  def __init__(self, expression, symbol_table):
    """Define a mathematical expression.

    :param expression: String giving expression to be calculated.
    :type expression: str

    :param symbol_table: Object defining variables and constants.
    :type symbol_table: cexprtk.Symbol_Table"""

    self._symbol_table = symbol_table
    self._init_expression(expression)

  cdef _init_expression(self, str expression_string):
    cdef parser_type p
    self._cexpressionptr[0].register_symbol_table(self._symbol_table._csymtableptr[0])
    #TODO: Check this step is successful
    p.compile(expression_string, self._cexpressionptr[0])


  def value(self):
    """Evaluate expression using variable values currently set within associated Symbol_Table

    :return: Value resulting from evaluation of expression.
    :rtype: float"""
    cdef double v = self._cexpressionptr[0].value()
    return v

  def __call__(self):
    """Equivalent to calling value() method."""
    return self.value()

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
      return self._variables


  property constants:
    def __get__(self):
      return self._constants



cdef class _Symbol_Table_Variables:
  """Class providing the .variables property for Symbol_Table.

  Provides a dictionary like interface, methods pass-through to
  C++ symbol_table object owned by parent Symbol_Table."""

  cdef symbol_table_type* _csymtableptr

  cdef symbol_table_type* _symbolTable(self) except *:
    """Used to access _csymtableptr, raises ReferenceError if
    the ptr has been deleted due to gc of parent Symbol_Table"""
    if not self._csymtableptr:
      raise ReferenceError("Parent Symbol_Table no longer exists")
    return self._csymtableptr

  def __getitem__(self, key):
    if not self.has_key(key):
      raise KeyError("Unknown variable: "+str(key))
    vptr = self._symbolTable().get_variable(key)
    val = vptr[0].value()
    return val


  def __setitem__(self, key, double value):
    if not self.has_key(key):
      raise KeyError("Unknown variable: "+str(key))
    variableAssign(self._symbolTable()[0], key, value)

  def __iter__(self):
    return self.iterkeys()

  def __len__(self):
    return len(self.items())

  def items(self):
    return [ (k,v) for (k,v) in self._get_variable_list() if not self._symbolTable().is_constant_node(k) ]

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
    self._symbolTable().get_variable_list(itemvector)
    return itemvector

  def has_key(self, key):
    try:
      key = str(key)
    except ValueError:
      return False
    return self._symbolTable()[0].is_variable(key) and not self._symbolTable()[0].is_constant_node(key)

  def __contains__(self, key):
    return self.has_key(key)


cdef class _Symbol_Table_Constants:
  """Class providing the .constants property for Symbol_Table.

  Provides a dictionary like interface, methods pass-through to
  C++ symbol_table object owned by parent Symbol_Table."""

  cdef symbol_table_type* _csymtableptr

  cdef symbol_table_type* _symbolTable(self) except *:
    """Used to access _csymtableptr, raises ReferenceError if
    the ptr has been deleted due to gc of parent Symbol_Table"""
    if not self._csymtableptr:
      raise ReferenceError("Parent Symbol_Table no longer exists")
    return self._csymtableptr


  def __getitem__(self, key):
    if not self.has_key(key):
      raise KeyError("Unknown variable: "+str(key))
    vptr = self._symbolTable().get_variable(key)
    val = vptr[0].value()
    return val


  def __iter__(self):
    return self.iterkeys()

  def __len__(self):
    return len(self.items())

  def items(self):
    return [ (k,v) for (k,v) in self._get_variable_list() if self._symbolTable().is_constant_node(k)]

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
    self._symbolTable().get_variable_list(itemvector)
    return itemvector

  def has_key(self, key):
    try:
      key = str(key)
    except ValueError:
      return False
    return self._symbolTable()[0].is_variable(key) and self._symbolTable()[0].is_constant_node(key)

  def __contains__(self, key):
    return self.has_key(key)


