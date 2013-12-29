# distutils: language = c++


from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.pair cimport pair

ctypedef pair[string,double] LabelFloatPair

cdef extern from "cexprtk.hpp":
  double evaluate(string expression_string, vector[LabelFloatPair] variables, vector[string] error_messages)
  void check(string expression_string, vector[string] error_list)

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

