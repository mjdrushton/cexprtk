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
    variable_ptr get_variable(string& variable_name)
    int is_variable(string& variable_name)
    int get_variable_list(LabelFloatPairVector& vlist)
    int variable_count()



ctypedef symbol_table[double] symbol_table_type

cdef extern from "cexprtk.hpp":
  void variableAssign(symbol_table_type & symtable, string& name, double value)



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


cdef class Symbol_Table:
  """Class for providing variable and constant values to Expression instances."""

  cdef symbol_table_type* _csymtableptr
  cdef _Symbol_Table_Variables _variables

  def __cinit__(self):
    self._csymtableptr = new symbol_table_type()
    self._variables = _Symbol_Table_Variables()
    self._variables._csymtableptr = self._csymtableptr

  def __dealloc__(self):
    del self._csymtableptr

  def __init__(self, variables, constants = {}):
    """Instantiate Symbol_Table defining variables and constants for Expression class.

    :param variables: Mapping between variable name and initial variable value.
    :type variables: dict

    :param constants: Constant name to value dictionary.
    :type constants: dict
    """
    self._populateVariables(variables)

  cdef _populateVariables(self,object variables):
    for s, v in variables.iteritems():
      self._csymtableptr[0].create_variable(s,v)

  property variables:
    def __get__(self):
      return self._variables


cdef class _Symbol_Table_Variables:
  """Class providing the .variables property for Symbol_Table.

  Provides a dictionary like interface, methods pass-through to
  C++ symbol_table object held within Symbol_table."""

  cdef symbol_table_type* _csymtableptr

  def __getitem__(self, key):
    if not self.has_key(key):
      raise KeyError("Unknown variable: "+str(key))
    vptr = self._csymtableptr.get_variable(key)
    val = vptr[0].value()
    return val


  def __setitem__(self, key, double value):
    if not self.has_key(key):
      raise KeyError("Unknown variable: "+str(key))
    variableAssign(self._csymtableptr[0], key, value)

  def __iter__(self):
    return self.iterkeys()

  def __len__(self):
    return self._csymtableptr.variable_count()

  def items(self):
    return self._get_variable_list()

  def iteritems(self):
    return iter(self._get_variable_list())

  def iterkeys(self):
    return iter(self.keys())

  def itervalues(self):
    return iter(self.values())

  def keys(self):
    return [ k for (k,v) in self._get_variable_list() ]

  def values(self):
    return [ v for (k,v) in self._get_variable_list() ]




  cdef list _get_variable_list(self):
    cdef LabelFloatPairVector itemvector = LabelFloatPairVector()
    self._csymtableptr.get_variable_list(itemvector)
    return itemvector


  def has_key(self, key):
    try:
      key = str(key)
    except ValueError:
      return False
    return self._csymtableptr[0].is_variable(key)

  def __contains__(self, key):
    return self.has_key(key)

